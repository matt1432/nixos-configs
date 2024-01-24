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
      firstColor = "#9d0909";
      secondColor = "#700707";
      thirdColor = "#430404";
      fourthColor = "#160101";
    };

    "blue" = {
      textColor = "#e3e5e5";
      firstColor = "#092a9d";
      secondColor = "#071e70";
      thirdColor = "#041243";
      fourthColor = "#010616";
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
