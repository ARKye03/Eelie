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
          # nil
        ];
        shell = pkgs.mkShell {
          nativeBuildInputs = with pkgs.buildPackages; [
            clang
            clang-tools
            meson
            muon
            ninja
            gnumake
            cmake
          ] ++ nix-utils;
          buildInputs = with pkgs; [
            pkg-config
          ];
        };

      in
      {
        devShells.default = shell;
      }
    );
}
