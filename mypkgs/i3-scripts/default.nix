{ pkgs
, stdenv
}:

let
  python3 = pkgs.python3.withPackages (python-packages:
  with python-packages; [ i3ipc ]
  );

in stdenv.mkDerivation {
  name = "i3-scripts";
  src = ./src;
  propagatedBuildInputs = [ python3 ];
  installPhase = ''
    mkdir -p $out/bin/
    mv * $out/bin/
  '';
}
