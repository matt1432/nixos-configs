import argparse
import os
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import TypedDict, cast

import requests
from loguru import logger


class User(TypedDict):
    Name: str
    ServerId: str
    Id: str
    HasPassword: bool
    HasConfiguredPassword: bool
    HasConfiguredEasyPassword: bool
    EnableAutoLogin: bool
    # LastLoginDate: datetime
    # LastActivityDate: datetime
    # Configuration: Configuration
    # Policy: Policy


class Person(TypedDict):
    Name: str
    ServerId: str
    Id: str
    ChannelId: str | None
    Type: str
    ImageTags: dict[str, str]
    BackdropImageTags: list[dict[str, str]]
    ImageBlurHashes: dict[str, str]
    LocationType: str
    MediaType: str


class FetchPersonsResult(TypedDict):
    Items: list[Person]
    TotalRecordCount: int
    StartIndex: int


# Set logging level
log_level = os.getenv("LOG_LEVEL", "INFO").upper()
# Configure Loguru logger
logger.remove()  # Remove default configuration
_ = logger.add(
    sys.stderr,
    format="{level} {message}",
    level=log_level,
    enqueue=True,
)

# ANSI Color codes
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
RESET = "\033[0m"


class ActorProcessor:
    api_url: str
    api_key: str
    user_id: str

    max_retries: int
    max_workers: int

    session: requests.Session

    def __init__(
        self,
        api_url: str,
        api_key: str,
        max_retries: int = 3,
        max_workers: int = 10,
    ):
        """Initialize the ActorProcessor with API credentials."""
        self.api_url = api_url.rstrip("/")
        self.api_key = api_key

        self.session = requests.Session()

        user_ids = self.get_uids()
        user_id = user_ids[0] if user_ids else None

        if user_id is None:
            logger.error(f"{RED}✗{RESET} No user IDs found.")
            sys.exit(1)

        self.user_id = user_id
        self.max_retries = max_retries
        self.max_workers = max_workers

    def get_uids(self) -> list[str]:
        """Retrieve user IDs from the server."""
        user_ids: list[str] = []
        us = cast(
            list[User],
            requests.get(
                f"{self.api_url}/Users",
                headers={"X-Emby-Token": self.api_key},
            ).json(),
        )
        for u in us:
            user_ids.append(u["Id"])
        return user_ids

    def calculate_speed(self, content_length: int, response_time: float) -> str:
        """Calculate and format network speed."""
        if response_time == 0:
            return f"{RED}N/A{RESET}"
        speed_mbps = (content_length * 8) / (response_time / 1000) / 1_000_000
        color = GREEN if speed_mbps > 10 else YELLOW if speed_mbps > 5 else RED
        return f"{color}{speed_mbps:.2f} Mbps{RESET}"

    def check_server_connectivity(self) -> bool:
        """Check if the server is reachable using requests."""
        try:
            start_time = time.time()
            response = self.session.get(
                f"{self.api_url}/System/Info",
                headers={"X-Emby-Token": self.api_key},
            )
            response_time = (time.time() - start_time) * 1000
            speed = self.calculate_speed(len(response.content), response_time)

            if response.status_code == 200:
                logger.info(
                    f"{GREEN}✓{RESET} Server is reachable (Response time: {BLUE}{response_time:.2f}ms{RESET}, Speed: {speed})"
                )
                return True
            else:
                logger.error(
                    f"{RED}✗{RESET} Server returned status code {RED}{response.status_code}{RESET}"
                )
                return False
        except requests.exceptions.RequestException as e:
            logger.error(f"{RED}✗{RESET} Connection error: {str(e)}")
            return False

    def fetch_person_data(
        self, force: bool = False
    ) -> FetchPersonsResult | None:
        """Fetch person data from the jellyfin server."""
        try:
            start_time = time.time()
            response = self.session.get(
                f"{self.api_url}/Persons",
                params={"enableImages": "false" if force else "true"},
                headers={"X-Emby-Token": self.api_key},
            )
            response_time = (time.time() - start_time) * 1000
            speed = self.calculate_speed(len(response.content), response_time)

            response.raise_for_status()
            logger.info(
                f"{GREEN}✓{RESET} Retrieved person data (Response time: {BLUE}{response_time:.2f}ms{RESET}, Speed: {speed})"
            )
            return cast(FetchPersonsResult, response.json())
        except requests.exceptions.RequestException as e:
            logger.error(
                f"{RED}✗{RESET} Failed to retrieve person data: {str(e)}"
            )
            return None

    def process_persons(self, force: bool = False):
        """Process persons based on the force flag."""
        person_data = self.fetch_person_data(force)
        if person_data is None:
            return

        total_persons = person_data.get('TotalRecordCount', len(person_data.get("Items", [])))
        logger.info(f"{BLUE}ℹ{RESET} Total persons: {total_persons}")

        persons_to_process = []
        if force:
            persons_to_process = person_data["Items"]
        else:
            persons_to_process = [
                item
                for item in person_data["Items"]
                if not item.get("ImageTags")
            ]

        if not persons_to_process:
            logger.info(f"{YELLOW}⚠{RESET} No persons to process.")
            return

        self._process_person_ids(persons_to_process)

    def _process_person_ids(self, persons: list[Person]):
        """Process each person with progress tracking."""
        total = len(persons)
        with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            futures = {
                executor.submit(
                    self._process_person, person, idx, total
                ): person
                for idx, person in enumerate(persons, 1)
            }

            for future in as_completed(futures):
                if future.exception():
                    logger.error(
                        f"{RED}✗{RESET} Error processing person: {future.exception()}"
                    )

    def _process_person(self, person: Person, idx: int, total: int):
        """Process a single person with retries."""
        person_id = person["Id"]
        person_name = person["Name"]
        retry_count = 0
        consecutive_errors = 0

        while retry_count <= self.max_retries:
            try:
                start_time = time.time()
                response = self.session.get(
                    f"{self.api_url}/Users/{self.user_id}/Items/{person_id}",
                    headers={"X-Emby-Token": self.api_key},
                )
                response_time = (time.time() - start_time) * 1000
                speed = self.calculate_speed(
                    len(response.content), response_time
                )

                status_emoji = (
                    f"{GREEN}✓{RESET}"
                    if response.status_code == 200
                    else f"{RED}✗{RESET}"
                )
                retry_info = (
                    f" (Retry {retry_count}/{self.max_retries})"
                    if retry_count > 0
                    else ""
                )
                status = f"{status_emoji} Processing {idx}/{total} - ID: {BLUE}{person_id}{RESET} - Response time: {response_time:.2f}ms, Speed: {speed}{retry_info} - (Name: {person_name})"

                logger.info(f"{status}")

                if response.status_code == 200:
                    consecutive_errors = 0
                    break
                else:
                    retry_count += 1
                    if retry_count <= self.max_retries:
                        logger.warning(
                            f"\n{YELLOW}⚠{RESET} Request failed (Status: {response.status_code}). Retrying ({retry_count}/{self.max_retries})..."
                        )
                        time.sleep(0.5)

            except requests.exceptions.RequestException as e:
                retry_count += 1
                if retry_count <= self.max_retries:
                    logger.warning(
                        f"\n{YELLOW}⚠{RESET} Request error: {str(e)}. Retrying ({retry_count}/{self.max_retries})..."
                    )
                    time.sleep(0.5)
                else:
                    consecutive_errors += 1
                    logger.error(
                        f"\n{RED}✗{RESET} Failed after {self.max_retries} retries: {str(e)}"
                    )

        if consecutive_errors >= 10:
            logger.error(
                f"\n{RED}⚠{RESET} Too many consecutive errors. Stopping."
            )
            sys.exit(1)


class Namespace(argparse.Namespace):
    url: str = ""
    api_key: str = ""
    force: bool = False
    retries: int = 3
    workers: int = 10


def main():
    parser = argparse.ArgumentParser(description="Jellyfin Actor Processor")
    _ = parser.add_argument(
        "-url", "--url", required=True, help="Jellyfin server URL"
    )
    _ = parser.add_argument(
        "-key", "--api-key", required=True, help="Jellyfin API key"
    )
    _ = parser.add_argument(
        "-f", "--force", action="store_true", help="Process all persons"
    )
    _ = parser.add_argument(
        "-r",
        "--retries",
        type=int,
        default=3,
        help="Maximum number of retries for failed requests",
    )
    _ = parser.add_argument(
        "-w",
        "--workers",
        type=int,
        default=10,
        help="Maximum number of parallel workers",
    )
    args = parser.parse_args(namespace=Namespace())

    logger.info(f"{BLUE}ℹ{RESET} Jellyfin Actor Processor")
    logger.info(f"{BLUE}ℹ{RESET} Server URL: {args.url}")
    logger.info(f"{BLUE}ℹ{RESET} API Key: {args.api_key}")
    logger.info(f"{BLUE}ℹ{RESET} Force: {args.force}")
    logger.info(f"{BLUE}ℹ{RESET} Retries: {args.retries}")
    logger.info(f"{BLUE}ℹ{RESET} Workers: {args.workers}")

    processor = ActorProcessor(
        args.url, args.api_key, args.retries, args.workers
    )

    if not processor.check_server_connectivity():
        sys.exit(1)

    processor.process_persons(args.force)


if __name__ == "__main__":
    main()
