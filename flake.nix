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
        genCppProps = pkgs.stdenv.mkDerivation
          {
            name = "generate-cpp-properties";
            buildInputs = with pkgs; [ pkg-config jq gtk4 gtk4-layer-shell ];

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
        eelieDock = pkgs.stdenv.mkDerivation
          {
            name = "eelie-dock";
            buildInputs = with pkgs; [ pkg-config ];
            src = ./.;
            installPhase = ''
              mkdir -p $out/bin
              cp eelie-dock $out/bin
              chmod +x $out/bin/eelie-dock
            '';
          };

      in
      {
        devShells.default = shell;
        packages.default = genCppProps;
      });
}
