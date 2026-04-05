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

# Parse arguments
USERNAME=${1:-$(whoami)}
if [ "$USERNAME" = "--user" ]; then
    USERNAME="${2:-$(whoami)}"
fi

echo "Configuration:"
echo "  Username: $USERNAME"
echo "  Base image: adminbench-base:$USERNAME"
echo ""

# Check if Layer 1b exists
if ! docker image inspect "adminbench-base:$USERNAME" >/dev/null 2>&1; then
    echo "❌ Error: Layer 1b (adminbench-base:$USERNAME) not found!"
    echo ""
    echo "Please build Layer 1b first:"
    echo "  cd ../base-image"
    echo "  ./build.sh --user $USERNAME"
    exit 1
fi

# Build the image
echo "Building ops-bench:$USERNAME..."
docker build \
    --build-arg BASE_IMAGE="adminbench-base:$USERNAME" \
    --build-arg USERNAME="$USERNAME" \
    -f Dockerfile.layer2 \
    -t "ops-bench:$USERNAME" \
    .

echo ""
echo "✓ Layer 2 (Ops Bench) built successfully!"
echo "  Image: ops-bench:$USERNAME"
echo ""
echo "Next step: Create workspaces from devcontainer.example/"
echo "  cp -r devcontainer.example workspaces/my-ops-project"
echo "  cd workspaces/my-ops-project"
echo "  # Edit docker-compose.yml and use image: ops-bench:$USERNAME"
