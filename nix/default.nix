{ pkgs, dock-name, version, gtk-utils, compile-utils, stdenv }:

let
  dock = stdenv.mkDerivation {
    name = dock-name;
    version = version;
    buildInputs = with pkgs; [ pkg-config ] ++ compile-utils ++ gtk-utils;
    src = ../.;

    buildPhase = ''
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
  dock = dock;
  nonNixosDock = nonNixos-dock;
}
