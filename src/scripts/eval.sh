#!/bin/bash

LANGUAGE=$1

python3 ../src/evaluate.py \
	--lang "${LANGUAGE}" \
	--prediction-filepath "predictions_orig/.pred" \
	--gold-filepath "${LANGUAGE}.output" \
