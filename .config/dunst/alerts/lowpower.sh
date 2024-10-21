#!/usr/bin/env bash

echo 'э, зарадка болшэ нэт!!!' |
  /opt/piper-tts/piper --model $HOME/Music/voices/ka_GE-natia-medium.onnx --output-raw |
  aplay -r 22050 -f S16_LE -t raw -
