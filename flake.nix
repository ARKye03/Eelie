{
  description = "CPlusPlus";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        gtk-utils = with pkgs; [
          gtk4
          gtk4-layer-shell
          glib
        ];
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
          ] ++ nix-utils ++ gtk-utils;
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
