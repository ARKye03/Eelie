{ pkgs, nix-utils, compile-utils, gtk-utils, stdenv }:

pkgs.mkShell.override
{
  inherit stdenv;
}
{
  nativeBuildInputs = with pkgs.buildPackages; [
    muon
    gnumake
    cmake
  ] ++ nix-utils ++ compile-utils;
  buildInputs = with pkgs; [
    pkg-config
  ] ++ gtk-utils;
}
