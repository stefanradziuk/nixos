{ callPackage
, python3
}:

{
  rbql = callPackage ./rbql {
    inherit (python3.pkgs) buildPythonPackage fetchPypi;
  };
}
