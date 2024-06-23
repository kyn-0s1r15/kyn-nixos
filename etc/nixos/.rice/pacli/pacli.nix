with import <nixpkgs> {}; 
with pkgs.python3Packages;
let
inherit (import ../../../settings.nix) NixDir ;
in {
  buildPythonPackage rec {
    name = "pacli"; 
    src = "${NixDir}/.rice/pacli";
    propogatedBuildInputs = with pkgs; [
      python311
    ];
    propogatedBuildInputs = with pkgs.python311Packages; [
      pdfplumber unidecode tiktoken openai
      charset-normalizer distro httpx tqdm
    ];
    propogatedBuildPhase = ''
import pytest
import os
import resource
import pdfplumber
import importlib.util

def has_pypdfium2():
    spec = importlib.util.find_spec("pypdfium2")
    return spec is not Non

def test_issue_1089():
    """
    Page.to_image() leaks file descriptors
    
    This is because PyPdfium2 leaks file descriptors.  Explicitly
    close the `PdfDocument` to prevent this.
    """
    if resource is None or not has_pypdfium2():
        pytest.skip("Skipping test: Required modules or resources not available")
        
    # Any PDF will do
    path = os.path.join(HERE, "pdfs/test-punkt.pdf")
    soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
    with pdfplumber.open(path) as pdf:
        for idx in range(soft):
            _ = pdf.pages[0].to_image()

    python311 ${NixDir}/.rice/pacli/pacli.py
    '';
    propogatedInstallPhase = ''
    mkdir -p $out/bin
    cp ${NixDir}/.rice/pacli/pacli.py $out/bin
    '';
  };
}
