{
  description = "CPlusPlus";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        system = "x86_64-linux";
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
        compile-utils = with pkgs; [
          clang-tools
          clang
          meson
          ninja
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
        genCppProps = pkgs.stdenv.mkDerivation
          {
            name = "generate-cpp-properties";
            buildInputs = with pkgs; [ pkg-config jq ] ++ gtk-utils;

            src = ./.;

            buildPhase = ''
              # No build steps required
            '';

            installPhase = /* shell */ ''
              mkdir -p $out/.vscode
              includePaths=$(pkg-config --cflags gtk4 gtk4-layer-shell-0 | tr ' ' '\n' | grep '\-I' | sed 's/-I//g' | jq -R -s -c 'split("\n") | map(select(length > 0))')
              cat > $out/.vscode/c_cpp_properties.json <<EOF
              {
                  "configurations": [
                      {
                          "name": "Linux",
                          "includePath": $includePaths,
                          "defines": [],
                          "compilerPath": "/usr/bin/clang",
                          "cStandard": "c23",
                          "cppStandard": "c++23",
                          "intelliSenseMode": "linux-clang-x64"
                      }
                  ],
                  "version": 4
              }
              EOF
            '';
          };
        eelie-dock = pkgs.stdenv.mkDerivation {
          pname = "eelie-dock";
          version = "0.0.1";
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
            cp $TMPDIR/buildNix/src/com.github.ARKye03.Eelie $out/bin
            chmod +x $out/bin/com.github.ARKye03.Eelie
          '';

          meta = with pkgs.lib; {
            description = "Eelie Dock Application";
            license = licenses.mit;
            maintainers = with maintainers; [ yourGitHubUsername ];
          };
        };

      in
      {
        devShells.default = shell;
        packages.default = genCppProps;
        apps = {
          dock = {
            type = "app";
            program = "${eelie-dock}/bin/com.github.ARKye03.Eelie";
          };
        };
      });
}
