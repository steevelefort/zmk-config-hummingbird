{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    bash
    docker
  ];

  shellHook = ''
    echo "ZMK Build Environment"
    echo "====================="
    echo "Docker: $(docker --version 2>/dev/null || echo 'not available')"
    echo ""
    echo "Usage:"
    echo "  ./build.sh                    - Build BLE version"
    echo "  ./build.sh seeeduino_xiao_rp2040 - Build RP2040 version"
    echo "  ./build-all.sh                - Build all versions"
    echo ""
  '';
}
