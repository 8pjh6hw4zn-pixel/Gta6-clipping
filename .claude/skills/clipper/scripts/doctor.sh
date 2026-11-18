#!/usr/bin/env bash
SKILL="$(cd "$(dirname "$0")/.." && pwd)"
VENV="$SKILL/.venv"
ok=1
say() { printf '%-16s %s\n' "$1" "$2"; }

good_python() {
  "$1" -c 'import sys; sys.exit(0 if (3, 10) <= sys.version_info[:2] else 1)' 2>/dev/null
}

if [ -x "$VENV/bin/python3" ] && good_python "$VENV/bin/python3"; then
  PY="$VENV/bin/python3"
else
  PY=""
  for c in python3.12 python3.13 python3.11 python3.10 python3 python3.14; do
    p="$(command -v $c)"
    [ -n "$p" ] && good_python "$p" || continue
    [ -z "$PY" ] && PY="$p"
    if "$p" -c 'import faster_whisper, numpy, PIL, cv2; cv2.CascadeClassifier' 2>/dev/null; then PY="$p"; break; fi
  done
fi

if ! command -v brew >/dev/null && { [ -z "$PY" ] || ! command -v ffmpeg >/dev/null; }; then
  say homebrew 'missing. Fix: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
fi

if [ -z "$PY" ]; then
  say python3 "missing or older than 3.10. Fix: brew install python@3.12"
  ok=0
else
  say python3 "ok ($("$PY" -c 'import platform; print(platform.python_version())'), $PY)"
fi

for t in ffmpeg ffprobe; do
  if command -v $t >/dev/null; then say $t ok; else say $t "missing. Fix: brew install ffmpeg"; ok=0; fi
done

if [ -n "$PY" ]; then
  missing=""
  for pair in "faster_whisper:faster-whisper" "cv2;cv2.CascadeClassifier:opencv-python<5" "numpy:numpy" "PIL:Pillow" "yt_dlp:yt-dlp"; do
    mod="${pair%%:*}"
    pkg="${pair##*:}"
    if [ "$pkg" = yt-dlp ] && command -v yt-dlp >/dev/null; then continue; fi
    "$PY" -c "import $mod" 2>/dev/null || missing="$missing $pkg"
  done
  if [ -n "$missing" ]; then
    ok=0
    if [ "$PY" != "$VENV/bin/python3" ]; then
      say venv "missing. Fix: $PY -m venv \"$VENV\""
    fi
    for pkg in $missing; do
      say "${pkg%%<*}" "missing. Fix: \"$VENV/bin/python3\" -m pip install -U '$pkg'"
    done
  else
    for pkg in faster-whisper opencv-python numpy Pillow yt-dlp; do say "$pkg" ok; done
  fi
fi

if [ $ok = 1 ]; then
  echo "PYTHON=$PY"
  echo "ready"
else
  echo "fix the lines above in order, then run this again"
  exit 1
fi
