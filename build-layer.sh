#!/bin/bash
# Build Layer 2 (ops-bench)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec "${SCRIPT_DIR}/build-layer2.sh"
