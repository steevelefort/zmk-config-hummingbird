#!/usr/bin/env bash

# ZMK Local Build Script with Docker
# Builds firmware for Hummingbird keyboard

set -e

BOARDS=("xiao_ble//zmk" "xiao_rp2040//zmk")
SHIELD="hummingbird"
BUILD_DIR="build"
WORKSPACE_DIR="zmk-workspace"
DOCKER_IMAGE="zmkfirmware/zmk-build-arm:3.5"

# Create directories if they don't exist
mkdir -p "$BUILD_DIR"
mkdir -p "$WORKSPACE_DIR"

# Copy config to workspace directory so it's accessible inside Docker
cp -r config "$WORKSPACE_DIR/" 2>/dev/null || true
cp -r boards "$WORKSPACE_DIR/" 2>/dev/null || true

# Pull Docker image once
echo "Pulling Docker image..."
docker pull "$DOCKER_IMAGE"

for BOARD in "${BOARDS[@]}"; do
  echo ""
  echo "=== Building $BOARD ==="

  ARTIFACT_NAME="${BOARD//\//_}_${SHIELD}"

  docker run --rm -it \
    -v "$(pwd)/$WORKSPACE_DIR:/workspace" \
    -v "$(pwd)/$BUILD_DIR:/workspace/artifacts" \
    "$DOCKER_IMAGE" \
    sh -c "
      set -e
      cd /workspace

      # Initialize west workspace if needed
      if [ ! -d .west ]; then
        echo 'Initializing west workspace...'
        west init -l config
        echo 'Updating dependencies (this may take a while on first run)...'
        west update
      fi

      # Always run zephyr-export to ensure CMake can find Zephyr
      echo 'Exporting Zephyr CMake package...'
      west zephyr-export

      # Clean previous build
      rm -rf build

      # Build firmware
      west build -s zmk/app -b $BOARD -- \
        -DZMK_CONFIG=/workspace/config \
        -DSHIELD=$SHIELD

      # Copy artifacts to build directory
      if [ -f build/zephyr/zmk.uf2 ]; then
        cp build/zephyr/zmk.uf2 /workspace/artifacts/$ARTIFACT_NAME.uf2
        echo ''
        echo 'Build successful!'
        echo \"Firmware: build/$ARTIFACT_NAME.uf2\"
      else
        echo 'Build failed: UF2 file not found'
        exit 1
      fi
    "
done

echo ""
echo "========================================="
echo "All builds complete!"
echo "========================================="
echo ""
ls -lh build/*.uf2
echo ""
echo "To flash:"
echo "1. Put your keyboard in bootloader mode (double-press reset)"
echo "2. Copy the UF2 file to the mounted drive"
