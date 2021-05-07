{ pkgs, nixpkgs }:
let
  lib           = nixpkgs.lib;
  utils         = (import ./utils.nix) {inherit lib;};
  spacelix      = (import ./spacelix.nix) {inherit lib;};
  withGray      = shades: shades.dark // {grey = shades.light.black;};
  
  xresTempStr   = builtins.readFile ./templates/xresources;
  pywalTempStr  = builtins.readFile ./templates/pywal;
in
pkgs.pkgs.stdenv.mkDerivation rec {
  pname       = "spacelix";
  version     = "0.0.2";
  dontUnpack  = true;

  buildPhase  = 
  let
    palPath = tempStr: palette: builtins.toFile "foo" 
      (utils.interpolateColors (withGray palette) tempStr);
    gen = tempStr: extStr: utils.concatLines
      (map (palName: "cat ${palPath tempStr spacelix."${palName}"} > spacelix-${palName}-${extStr}") spacelix.names);
  in
  (gen xresTempStr "xresources") + (gen pywalTempStr "pywal.json");

  installPhase = 
  let
    export = name: extStr: "mkdir -p $out/${name}\n" + (utils.concatLines
    (map (palName: "mv spacelix-${palName}-${extStr} $out/${name}") spacelix.names));
  in
  (export "xresources" "xresources") + (export "pywal" "pywal.json");
}
