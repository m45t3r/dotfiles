{ pkgs, nodejs, nodePackages, stdenv, lib, ... }:

let

  packageName = with lib; concatStrings (map (entry: (concatStrings (mapAttrsToList (key: value: "${key}-${value}") entry))) (importJSON ./package.json));

  nodePackagesLocal = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackagesLocal.flood.override {
  buildInputs = [ nodePackages.node-pre-gyp ];
  meta = with lib; {
    homepage = "https://github.com/jesec/flood";
    description = "A web UI for rTorrent with a Node.js backend and React frontend.";
    maintainers = with maintainers; [ thiagokokada ];
    license = licenses.gpl3;
  };
}
