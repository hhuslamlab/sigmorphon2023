#!/bin/bash

LANGUAGE=$1
DATABIN=../data/neural/data-bin

CKPTS=../data/neural/checkpoints


fairseq-generate \
      "${DATABIN}/${LANGUAGE}" \
      --gen-subset "valid" \
      --source-lang "${LANGUAGE}.input" \
      --target-lang "${LANGUAGE}.output" \
      --path "${CKPTS}/${LANGUAGE}-models/checkpoint_best.pt" \
      --beam 5 \
      > "../data/neural/predictions/${LANGUAGE}.pred"
