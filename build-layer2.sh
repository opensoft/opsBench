#!/bin/bash
# Build script for Layer 2: Ops Bench Image
# Creates: ops-bench:$USERNAME

set -e

echo "=========================================="
echo "Building Layer 2: Ops Bench"
echo "=========================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if Layer 1b exists
if ! docker image inspect "adminbench-base:latest" >/dev/null 2>&1; then
    echo "❌ Error: Layer 1b (adminbench-base:latest) not found!"
    echo ""
    echo "Please build Layer 1b first:"
    echo "  cd ../base-image"
    echo "  ./build.sh"
    exit 1
fi

# Build the image (user-agnostic)
echo "Building ops-bench:latest..."
docker build \
    -f Dockerfile.layer2 \
    -t "ops-bench:latest" \
    .

echo ""
echo "✓ Layer 2 (Ops Bench) built successfully!"
echo "  Image: ops-bench:latest"
echo ""
echo "Layer 3 (user personalization) is handled automatically by"
echo "ensure-layer3.sh when opening a devcontainer."
