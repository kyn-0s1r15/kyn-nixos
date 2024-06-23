#!/usr/bin/env nix-shell
#!nix-shell -i bash -p "python3.withPackages(ps: [ ps.pip ])"

export OPENAI_BASE_URL="https://saltmelon.jett.usbx.me/litellm"
export OPENAI_API_KEY="sk-gqb2gfm86nmyon8n9p3jbmun49i"

CWD=$(pwd)

cd ~/devenv/pacli

if [ -d ./venv ]; then
    source venv/bin/activate
else
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
fi

cd "$CWD"

python3 /etc/nixos/.rice/pacli/pacli.sh  /etc/nixos/.rice/pacli/pacli.py "$@"
