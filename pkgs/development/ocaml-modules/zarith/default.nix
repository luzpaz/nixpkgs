{ stdenv, fetchurl
, ocaml, findlib, pkgconfig, perl
, gmp
}:

let source =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "1.8";
    url = https://github.com/ocaml/Zarith/archive/release-1.8.tar.gz;
    sha256 = "1cn63c97aij19nrw5hc1zh1jpnbsdkzq99zyyk649c4s3xi3iqq7";
  } else {
    version = "1.3";
    url = http://forge.ocamlcore.org/frs/download.php/1471/zarith-1.3.tgz;
    sha256 = "1mx3nxcn5h33qhx4gbg0hgvvydwlwdvdhqcnvfwnmf9jy3b8frll";
  };
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-zarith-${version}";
  inherit (source) version;
  src = fetchurl { inherit (source) url sha256; };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib perl ];
  propagatedBuildInputs = [ gmp ];

  patchPhase = "patchShebangs ./z_pp.pl";
  configurePhase = ''
    ./configure -installdir $out/lib/ocaml/${ocaml.version}/site-lib
  '';

  preInstall = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs";

  meta = with stdenv.lib; {
    description = "Fast, arbitrary precision OCaml integers";
    homepage    = "http://forge.ocamlcore.org/projects/zarith";
    license     = licenses.lgpl2;
    inherit (ocaml.meta) platforms;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
