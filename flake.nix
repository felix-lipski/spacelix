{
  description = "Spacelix color theme for nix, pywal";

  outputs = { self, nixpkgs }: {

    spacelix-module = import ./spacelix-module.nix;

  # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
  # defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

  };
}
