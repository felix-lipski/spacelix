{ pkgs, nixpkgs }:
let
  lib           = nixpkgs.lib;
  utils         = (import ./utils.nix) {inherit lib;};
  spacelix      = (import ./spacelix.nix) {inherit lib;};
  xresTempStr   = builtins.readFile ./templates/xresources;
  xresTempPath  = builtins.toFile "xresources" xresTempStr;
  withGray      = shades: shades.dark // {grey = shades.light.black;};
  xresPalPath   = palette: builtins.toFile "foo" 
    (utils.interpolateColors (withGray palette) xresTempStr);
in
pkgs.pkgs.stdenv.mkDerivation rec {
  pname       = "spacelix";
  version     = "0.0.1";
  dontUnpack  = true;
  buildPhase  = utils.concatLines
    (map (x: "cat ${xresPalPath spacelix."${x}"} > spacelix-${x}-xresources") spacelix.names);
# buildPhase  = ''
#   cat ${xresPalPath spacelix.slate} > txt
# '';
  installPhase = "mkdir -p $out/xresources\n" + (utils.concatLines
    (map (x: "mv spacelix-${x}-xresources $out/xresources") spacelix.names));
# installPhase = ''
#   mkdir -p $out/bin
#   mv txt $out/bin
# '';
}
