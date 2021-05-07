{ pkgs, nixpkgs }:
let
  lib           = nixpkgs.lib;
  utils         = (import ./utils.nix) {inherit lib;};
  spacelix      = (import ./spacelix.nix) {inherit lib;};
  
  xresTempStr   = builtins.readFile ./templates/xresources;
  xresTempPath  = builtins.toFile "xresources" xresTempStr;
  pywalTempStr  = builtins.readFile ./templates/pywal;
  pywalTempPath = builtins.toFile "pywal" pywalTempStr;

  withGray      = shades: shades.dark // {grey = shades.light.black;};
  palPath       = tempStr: palette: builtins.toFile "foo" 
    (utils.interpolateColors (withGray palette) tempStr);
  xresPalPath   = palette: builtins.toFile "foo" 
    (utils.interpolateColors (withGray palette) xresTempStr);
in
pkgs.pkgs.stdenv.mkDerivation rec {
  pname       = "spacelix";
  version     = "0.0.1";
  dontUnpack  = true;
  buildPhase  = 
  let
    genXres = utils.concatLines
    (map (x: "cat ${palPath xresTempStr spacelix."${x}"} > spacelix-${x}-xresources") spacelix.names);
    genPywal = utils.concatLines
    (map (x: "cat ${palPath pywalTempStr spacelix."${x}"} > spacelix-${x}-pywal.json") spacelix.names);
  in
  genXres + genPywal;

  installPhase = 
  let
    exportXres = "mkdir -p $out/xresources\n" + (utils.concatLines
    (map (x: "mv spacelix-${x}-xresources $out/xresources") spacelix.names));
    exportPywal = "mkdir -p $out/pywal\n" + (utils.concatLines
    (map (x: "mv spacelix-${x}-pywal.json $out/pywal") spacelix.names));
  in
  exportXres + exportPywal;
}
