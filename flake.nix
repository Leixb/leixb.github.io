{
  outputs = {self, nixpkgs}:

  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    pnpm = pkgs.nodePackages_latest.pnpm.override {
      preRebuild = ''
        mkdir -p $out/bin/
        for i in pnpm pnpx; do
          ln -s $out/lib/node_modules/pnpm/bin/$i.cjs $out/bin/$i
        done
      '';
    };
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [ pnpm pkgs.nodejs_latest ];
    };

    packages.${system}.pnpm = pnpm;
  };
}
