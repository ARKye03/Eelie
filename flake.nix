{
  description = "CPlusPlus";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dock-name = "com.github.ARKye03.Eelie";
        version = builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile ./version);

        gtk-utils = with pkgs; [
          gtk4
          gtkmm4
          gtk4-layer-shell
          glib
        ];
        nix-utils = with pkgs; [
          nixpkgs-fmt
          nixd
        ];
        compile-utils = with pkgs; [
          meson
          ninja
        ];

        stdenv = pkgs.gcc14Stdenv;

        shell = import ./nix/shell.nix {
          inherit pkgs nix-utils compile-utils gtk-utils stdenv;
        };

        dockDefinitions = import ./nix/default.nix {
          inherit pkgs dock-name version gtk-utils compile-utils stdenv;
        };

      in
      {
        devShells.default = shell;
        packages = {
          nixos = dockDefinitions.dock;
          non_nixos = dockDefinitions.nonNixosDock;
        };
        apps.default = {
          type = "app";
          program = "${dockDefinitions.dock}/bin/${dock-name}";
        };
      });
}
