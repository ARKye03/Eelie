{
  description = "CPlusPlus";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nix-utils = with pkgs; [
          nixpkgs-fmt
          nixd
        ];
        shell = pkgs.mkShell {
          nativeBuildInputs = with pkgs.buildPackages; [
            pkg-config
            clang
            meson
            muon
            ninja
            hello
          ] ++ nix-utils;
        };

      in
      {
        devShells.default = shell;
      }
    );
}
