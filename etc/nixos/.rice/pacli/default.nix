{ pkgs ? import <nixpkgs> {} }:
let
inherit (import ../../../settings.nix) NixDir ;
in {
pkgs.python3Packages.buildPythonPackage rec {
  name = "pacli";

  # pacli.pydirectory
  src = "${NixDir}/.rice/pacli";
  propagatedBuildInputs = with pkgs.python311Packages; [
    pdfplumber unidecode tiktoken openai charset-normalizer distro httpx tqdm
  ];
  testInputs = with pkgs.python311Packages; [
    pytest
  ];
  checkInputs = with pkgs; [
    python311
  ];
  buildInputs = [ pkgs.python311 ];
  propogatedBuildPhase = ''
    ${pkgs.python311}/bin/python -m pytest test_pacli.py
  '';
  };
}
