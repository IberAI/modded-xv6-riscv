{
  description = "Development environment for xv6-riscv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages = [
          # RISC-V bare-metal compiler/binutils/newlib
          pkgs.pkgsCross.riscv64-embedded.buildPackages.gcc

          # QEMU system emulator
          pkgs.qemu
          pkgs.python3
          # Build tools used by the xv6 Makefile
          pkgs.gnumake
          pkgs.perl
          pkgs.gdb
          pkgs.clang-tools
        ];

        shellHook = ''
          echo "xv6 development shell"
          echo
          echo "RISC-V GCC:"
          riscv64-none-elf-gcc --version | head -n 1
          echo
          echo "QEMU:"
          qemu-system-riscv64 --version | head -n 1
        '';
      };
    });
  };
}
