{ lib, ... }:
with lib;
{
  options.palette =
    let
      mkColorOption = name: {
        inherit name;
        value = mkOption {
          type = types.strMatching "#[a-fA-F0-9]{6}";
          description = "Color ${name}.";
        };
      };
      colorList = [ red green yellow blue magenta cyan white ];
      colorAttrs = listToAttrs (map mkColorOption colorList);
    in
    { 
      light = colorAttrs;
      dark = colorAttrs;
    };
]
      
