pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:125826edbd668fbd94d4ca649e9892a6a57304a56d79f7e13697ebfade5ea60c";
  hash = "sha256-DFMVs2piphlqKlAQ/2KTh+WH+45zo4GR5fCZca6WEsU=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
