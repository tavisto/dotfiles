#!/usr/bin/env bash

# This script sets up asdf version manager and installs specified plugins and versions.

# Install asdf-rust plugins
asdf plugin add rust https://github.com/asdf-community/asdf-rust.git

# Install latest versions of Rust and Cargo
asdf install rust latest
asdf reshim rust
