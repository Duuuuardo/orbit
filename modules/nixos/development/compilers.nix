{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    clang
    cmake
    ninja
    pkg-config
    openssl
  ];
}