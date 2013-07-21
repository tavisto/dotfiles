#!/usr/bin/env bash
export SSH_CONFIG_DIR=$HOME/.ssh/conf.d
cat $SSH_CONFIG_DIR/head $SSH_CONFIG_DIR/hosts $SSH_CONFIG_DIR/footer > $HOME/.ssh/config