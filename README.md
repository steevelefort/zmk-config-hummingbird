# ZMK configuration for a Hummingbird

ZMK configuration for Hummingbird keyboard (30-key split).

## Local Build with Docker

### NixOS users

Enter the nix-shell environment first:

```bash
nix-shell
```

### Build a single variant

```bash
# BLE version (default)
./build.sh

# RP2040 version
./build.sh seeeduino_xiao_rp2040
```

### Build all variants

```bash
./build-all.sh
```

### Flashing the firmware

1. Put the keyboard in bootloader mode (double-press reset button)
2. Copy the `build/*.uf2` file to the mounted drive

## Keyboard Layers

- **Layer 0 (DEF)**: QWERTY with home row mods
- **Layer 1 (NAV)**: Navigation, vim/tmux shortcuts
- **Layer 2 (NUM)**: Function keys and numbers
- **Layer 3 (Media)**: Bluetooth and media controls
- **Layer 4 (Mouse)**: Mouse control
- **Layer 5 (Numpad)**: Numeric keypad

