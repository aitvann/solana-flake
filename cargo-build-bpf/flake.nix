{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs: {
    packages.x86_64-linux.default = with import inputs.nixpkgs
      {
        system = "x86_64-linux";
      }; rustPlatform.buildRustPackage rec {
      pname = "solana-cargo-build-bpf";
      version = "1.10.29";

      src = fetchFromGitHub {
        owner = "solana-labs";
        repo = "solana";
        rev = "v${version}";
        hash = "sha256-tw6WLSZXnqTVr7avQSJf4N4Fz87VTjbQtA5PXjiheUY=";
      };
      buildAndTestSubdir = "sdk/cargo-build-bpf";

      cargoHash = "sha256-b+bEbq2F+a8XkvNw9rqQJeQzynvj8zvAUvKJwi2tRs0=";

      nativeBuildInputs = [
        pkg-config
        perl
        cmake
        clang
        libclang.lib
      ];

      buildInputs = [
        udev
        clang
        libclang.lib
      ];

      LIBCLANG_PATH = "${libclang.lib}/lib";
      NIX_CFLAGS_COMPILE = "-I${libclang.lib}/clang/11.1.0/include";

      doCheck = false;

      cargoPatches = [
        ./patches/main.rs.diff
        ./patches/Cargo.toml.diff
        ./patches/Cargo.lock.diff
      ];

      meta = with lib; {
        homepage = "https://github.com/solana-labs/solana/tree/master/sdk/cargo-build-bpf";
        platforms = platforms.linux;
      };
    };
  };
}
