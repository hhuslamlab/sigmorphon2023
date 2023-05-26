#!/bin/bash

LANGUAGE=$1
DATABIN=data-bin

fairseq-preprocess \
    --source-lang="${LANGUAGE}.input" \
    --target-lang="${LANGUAGE}.output" \
    --trainpref=train \
    --validpref=valid \
    --testpref=test   \
    --tokenizer=space \
    --thresholdsrc=1 \
    --thresholdtgt=1 \
    --destdir="${DATABIN}/${LANGUAGE}"
