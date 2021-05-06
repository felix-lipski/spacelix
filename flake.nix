{
  description = "Spacelix color theme for nix, pywal";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs-channels/nixos-unstable;
  };

  outputs = { self, nixpkgs, nix, ... }@inputs: 
  let pkgs = import nixpkgs { system = "x86_64-linux"; }; in
  {
    spacelix-module = import ./spacelix-module.nix;
    export = (import ./export.nix) { inherit pkgs; inherit nixpkgs; };
  };
}
