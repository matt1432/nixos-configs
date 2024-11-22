{color ? null}: let
  inherit (builtins) attrNames removeAttrs;

  schemes = {
    "purple" = {
      textColor = "#090c0c";
      firstColor = "#bd93f9";
      secondColor = "#715895";
      thirdColor = "#382c4a";
      fourthColor = "#120e18";
    };

    "green" = {
      textColor = "#090c0c";
      firstColor = "#78ae66";
      secondColor = "#567c49";
      thirdColor = "#334a2c";
      fourthColor = "#11180e";
    };

    "red" = {
      textColor = "#090c0c";
      firstColor = "#e04242";
      secondColor = "#9c2e2e";
      thirdColor = "#591a1a";
      fourthColor = "#160606";
    };

    "blue" = {
      textColor = "#090c0c";
      firstColor = "#6684ee";
      secondColor = "#475ca6";
      thirdColor = "#28345f";
      fourthColor = "#010617";
    };

    "orange" = {
      textColor = "#090c0c";
      firstColor = "#ff9c42";
      secondColor = "#c66b00";
      thirdColor = "#874500";
      fourthColor = "#3a1c00";
    };

    "yellow" = {
      textColor = "#090c0c";
      firstColor = "#ffea42";
      secondColor = "#d4c300";
      thirdColor = "#8f8b00";
      fourthColor = "#3e3c00";
    };

    "cyan" = {
      textColor = "#090c0c";
      firstColor = "#42eaff";
      secondColor = "#00a2b8";
      thirdColor = "#005768";
      fourthColor = "#001f26";
    };

    "pink" = {
      textColor = "#090c0c";
      firstColor = "#ff42cb";
      secondColor = "#b80073";
      thirdColor = "#6b003f";
      fourthColor = "#2d0017";
    };

    # Template
    "color" = {
      textColor = "#090c0c";
      firstColor = "";
      secondColor = "";
      thirdColor = "";
      fourthColor = "";
    };
  };
in
  if ! isNull color
  then schemes.${color}
  else attrNames (removeAttrs schemes ["color"])
