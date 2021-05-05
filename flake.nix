{
  description = "Spacelix color theme for nix, pywal";

  outputs = { self, nixpkgs }: {

    spacelix = import ./spacelix.nix;

  # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
  # defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

  };
}
