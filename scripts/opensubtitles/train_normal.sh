#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# train_normal.sh


NORMAL_BIN=/data/lixiaoya/dataset/attack/experiments/data-bin
MODEL_DIR=/data/lixiaoya/outputs/attack/normal
mkdir -p $MODEL_DIR
LOG=$MODEL_DIR/log.txt
CUDA_VISIBLE_DEVICES=0 fairseq-train $NORMAL_BIN \
    --optimizer adam --adam-betas '(0.9, 0.98)' --adam-eps 1e-9 \
    --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
    --arch transformer_wmt_en_de --share-all-embeddings \
    --dropout 0.2 --weight-decay 0.0001 \
    --save-dir $MODEL_DIR \
    --max-epoch 25 --update-freq 1 \
    --lr 7e-4 --lr-scheduler inverse_sqrt \
    --warmup-updates 4000 --warmup-init-lr 1e-07 \
    --eval-bleu \
    --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
    --eval-bleu-print-samples --max-sentences 256 \
    --best-checkpoint-metric bleu --maximize-best-checkpoint-metric \
    --keep-best-checkpoints 10 --fp16 --ddp-backend=no_c10d --validate-interval 20  >$LOG 2>&1 & tail -f $LOG
