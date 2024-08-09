{
  description = "CPlusPlus";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:

    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = nixpkgs.legacyPackages.${system};
        dockpp = "org.codeberg.ARKye03.Eelie";
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
          # nil
        ];
        compile-utils = with pkgs; [
          clang-tools
          clang
          meson
          ninja
          blueprint-compiler
        ];
        shell = pkgs.mkShell {
          nativeBuildInputs = with pkgs.buildPackages; [
            muon
            gnumake
            cmake
          ] ++ nix-utils ++ compile-utils;
          buildInputs = with pkgs; [
            pkg-config
          ] ++ gtk-utils;
        };

        eelie-dock = pkgs.stdenv.mkDerivation {
          name = "eelie-dock";
          version = version;
          buildInputs = with pkgs; [ pkg-config ] ++ compile-utils ++ gtk-utils;
          src = ./.;

          buildPhase = ''
            export CC=clang
            export CXX=clang++
            mkdir -p $TMPDIR/buildNix
            cd $TMPDIR/buildNix
            meson setup $TMPDIR/buildNix $src
            ninja -C $TMPDIR/buildNix
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp $TMPDIR/buildNix/src/${dockpp} $out/bin
            chmod +x $out/bin/${dockpp}
          '';

          meta = with pkgs.lib; {
            description = "Eelie Dock Application";
            license = licenses.mit;
            maintainers = with maintainers; [ ARKye03 ];
          };
        };

      in
      {
        devShells.default = shell;
        apps.default = {
          type = "app";
          program = "${eelie-dock}/bin/${dockpp}";
        };
      });
}
