{ callPackage
, python3
}:

{
  rbql = callPackage ./rbql {
    inherit (python3.pkgs) buildPythonPackage fetchPypi;
  };

  i3-scripts = callPackage ./i3-scripts {};
}
