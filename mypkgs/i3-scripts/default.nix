{ stdenv
}:

stdenv.mkDerivation {
  name = "i3-scripts";
  src = ./src;
  installPhase = ''
    mkdir -p $out/bin/
    mv * $out/bin/
  '';
}
