#!/usr/bin/env bash
# fix-ollama-mlx.sh
# After `brew upgrade ollama`, the MLX dynamic libraries aren't linked into
# the versioned cellar path that ollama searches. Run this to fix it.
#
# Searched paths (from ollama error output):
#   <cellar>/bin/lib/ollama
#   <cellar>/bin
#   /opt/homebrew/var/build/lib/ollama

set -euo pipefail

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
OLLAMA_CELLAR="${HOMEBREW_PREFIX}/Cellar/ollama"

# Resolve the currently linked ollama version
OLLAMA_VERSION=$(readlink "${HOMEBREW_PREFIX}/opt/ollama" | xargs basename)
OLLAMA_LIB_DIR="${OLLAMA_CELLAR}/${OLLAMA_VERSION}/bin/lib/ollama"

echo "Ollama version : ${OLLAMA_VERSION}"
echo "Target lib dir : ${OLLAMA_LIB_DIR}"

# Create the lib/ollama directory ollama searches at startup
mkdir -p "${OLLAMA_LIB_DIR}"

# Symlink each MLX library homebrew provides
for lib in libmlx.dylib libmlxc.dylib; do
    src="${HOMEBREW_PREFIX}/lib/${lib}"
    dst="${OLLAMA_LIB_DIR}/${lib}"
    if [[ ! -f "${src}" ]]; then
        echo "WARNING: ${src} not found — skipping (run: brew install mlx mlx-c)"
        continue
    fi
    if [[ -L "${dst}" ]]; then
        echo "  already linked: ${dst}"
    else
        ln -sf "${src}" "${dst}"
        echo "  linked: ${dst} -> ${src}"
    fi
done

# Restart ollama so it picks up the new libraries
echo "Restarting ollama service..."
brew services restart ollama

echo "Done. Test with: ollama run llama3.2"
