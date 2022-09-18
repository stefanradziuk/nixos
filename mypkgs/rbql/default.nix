{ buildPythonPackage
, callPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "rbql";
  version = "0.25.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-b84KeTxvlWMHbYFFZHCKvLH12ZkIL4D/Lmk3SNh+ydk=";
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/pytoolz/toolz";
    description = "Rainbow Query Language";
  };
}
