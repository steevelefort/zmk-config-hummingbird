#!/usr/bin/env bash

# Build all variants of Hummingbird firmware

set -e

echo "Building all Hummingbird variants..."
echo ""

# Build BLE version
echo "=== Building BLE version (Seeeduino Xiao BLE) ==="
./build.sh xiao_ble

echo ""
echo "=== Building RP2040 version (Seeeduino Xiao RP2040) ==="
./build.sh xiao_rp2040

echo ""
echo "========================================="
echo "All builds complete!"
echo "========================================="
echo ""
ls -lh build/*.uf2
