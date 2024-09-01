{
  description = "CPlusPlus";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dock-name = "org.codeberg.ARKye03.Eelie";
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

        dock = pkgs.stdenv.mkDerivation {
          name = dock-name;
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
            cp $TMPDIR/buildNix/src/${dock-name} $out/bin
            chmod +x $out/bin/${dock-name}
          '';

          meta = with pkgs.lib; {
            description = "Eelie Dock Application";
            license = licenses.mit;
            maintainers = with maintainers; [ ARKye03 ];
          };
        };
        nonNixos-dock = dock.overrideAttrs {
          installPhase = ''
            mkdir -p $out/bin
            cp $TMPDIR/buildNix/src/${dock-name} $out/bin
            ${pkgs.patchelf}/bin/patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 $out/bin/${dock-name}
            ${pkgs.patchelf}/bin/patchelf --set-rpath /lib:/usr/lib $out/bin/${dock-name}
            ${pkgs.patchelf}/bin/patchelf --shrink-rpath $out/bin/${dock-name}
            chmod +x $out/bin/${dock-name}
          '';
        };

      in
      {
        devShells.default = shell;
        packages = {
          nixos = dock;
          non_nixos = nonNixos-dock;
        };
        apps.default = {
          type = "app";
          program = "${dock}/bin/${dock-name}";
        };
      });
}
