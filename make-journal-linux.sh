#!/bin/bash -eu

if [ $# -lt 2 ]; then
  echo "usage: make-journal-linux.sh SOURCE_PATH OUTPUT_DIR"
  exit 1
fi

source_path="$1"
output_dir="$2"
venv="$(mktemp -d)"
workpath="$(mktemp -d)"
journal_linux_name=_______

function atexit {
  [ -n "$venv" ] && rm -rf "$venv"
  [ -n "$workpath" ] && rm -rf "$workpath"
}

trap atexit EXIT

# Create and initialize venv
python3 -m venv "$venv"
set +u
source "$venv/bin/activate"
set -u
pip install --upgrade pip
pip install pyqt5 pyinstaller

# Create standalone python distribution
pyi-makespec --onefile \
	     --specpath="$source_path/journal/unix" \
	     "$source_path/journal/unix/journal.py" \
             --paths="." \
             --add-data="images:images" \
             --add-data="qt.conf:." \
             --exclude-module='libgio-*' \
             --exclude-module='libglib-*' \
             --exclude-module='libsystemd.*' \
             --exclude-module='librt.*' \
	     --name="$journal_linux_name" \

pyinstaller --distpath="$output_dir" \
	    --workpath="$workpath" \
	    "$source_path/journal/unix/$journal_linux_name.spec" \

