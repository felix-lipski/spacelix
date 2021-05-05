{ lib, config, pkgs, ... }:
{
  config.spacelix = (import ./spacelix.nix) {inherit lib;};
}
      
