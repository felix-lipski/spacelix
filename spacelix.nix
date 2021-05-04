{ lib }:
rec {
  utils = (import ./utils.nix) {inherit lib;};

  spacelix-base = {
    red     = "#cc2200"; 
    green   = "#77aa00"; 
    yellow  = "#ccbb00"; 
    blue    = "#0066ff"; 
    magenta = "#ff0055"; 
    cyan    = "#00aa77"; 
    white   = "#ffffff"; 
  };

# spacelix-base-dark = builtins.mapAttrs (name: value: utils.darkenHex 0.1 value) spacelix-base;
# spacelix-base-light = builtins.mapAttrs (name: value: utils.lightenHex 0.5 value) spacelix-base;

  genSpacelix = background: {
    light = spacelix-base // {black = utils.lightenHex 0.4 background;};
    dark = spacelix-base // {black = background;};
  };

  spacelix-slate  = genSpacelix "#1b253a";
  spacelix-dark   = genSpacelix "#111111";
  spacelix-black  = genSpacelix "#000000";
  spacelix-ocean  = genSpacelix "#012456";
  spacelix-sea    = genSpacelix "#073642";
  spacelix-deep   = genSpacelix "#001133";
}
