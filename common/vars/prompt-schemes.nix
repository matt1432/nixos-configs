color: let
  schemes = {
    "purple" = {
      textColor = "#e3e5e5";
      firstColor = "#bd93f9";
      secondColor = "#715895";
      thirdColor = "#382c4a";
      fourthColor = "#120e18";
    };

    "green" = {
      textColor = "#e3e5e5";
      firstColor = "#78ae66";
      secondColor = "#567c49";
      thirdColor = "#334a2c";
      fourthColor = "#11180e";
    };

    "red" = {
      textColor = "#e3e5e5";
      firstColor = "#e04242";
      secondColor = "#9c2e2e";
      thirdColor = "#591a1a";
      fourthColor = "#160606";
    };

    "blue" = {
      textColor = "#e3e5e5";
      firstColor = "#6684ee";
      secondColor = "#475ca6";
      thirdColor = "#28345f";
      fourthColor = "#010617";
    };

    # Template
    "color" = {
      textColor = "#e3e5e5";
      firstColor = "";
      secondColor = "";
      thirdColor = "";
      fourthColor = "";
    };
  };
in
  schemes.${color}
