{ pkgs ? import <nixpkgs> {}
, buildDir ? "_build"
, profile ? "default"
, ... }:
let

  inherit (pkgs) stdenv erlang;

  releaseName = "fahrradboten";
  releasePath="${buildDir}/${profile}/rel/${releaseName}";
  releaseBin="${releasePath}/bin/${releaseName}";

in stdenv.mkDerivation {
  name = "${releaseName}-shell";
  buildInputs = [ erlang ];

  shellHook = ''
    PATH+=":${releasePath}/bin"
    alias rel="${releaseBin}"
    alias erlnodes="pgrep -fla beam.smp"

    make all
    if ${releaseBin} ping 2>/dev/null; then
      echo "Already running ${releaseName}"
    else
      echo -ne "Starting ${releaseName}..."
      ${releaseBin} start
      echo -e "done."
    fi
  '';
}
