{ lib, ... }:
with lib;
{
  options.ui.spacelix = 
  let
    hexType = types.strMatching "#[a-fA-F0-9]{6}";
    shadeType = types.attrsOf hexType;
    paletteType = types.attrsOf shadeType;
    palettesType = types.attrsOf paletteType;
  in mkOption {
    description = "spacelix palettes";
    type = palettesType;
    default = (import ./spacelix.nix) {inherit lib;};
  };
}

