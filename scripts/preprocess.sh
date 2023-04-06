LANGUAGE=$1
DATABIN=../data-bin

fairseq-preprocess \
    --source-lang="../data/neural/${LANGUAGE}.input" \
    --target-lang="../data/neural/${LANGUAGE}.output" \
    --trainpref=train \
    --validpref=dev \
    --tokenizer=space \
    --thresholdsrc=1 \
    --thresholdtgt=1 \
    --destdir="${DATABIN}/${LANGUAGE}"
