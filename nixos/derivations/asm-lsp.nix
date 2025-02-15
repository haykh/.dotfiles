{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
rustPlatform.buildRustPackage rec {
  pname = "asm-lsp";
  version = "master";

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = pname;
    rev = version;
    hash = "sha256-0Vh2EQrJqGltqdM6q5hGaS36Oyy1V531tXX242rLfsA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

  cargoHash = "sha256-ol3wA/ryZcJi84DT9W2ilMRQ/12QaI4KoqPGfuB64qc=";

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Language server for NASM/GAS/GO Assembly";
    homepage = "https://github.com/bergercookie/asm-lsp";
    license = pkgs.lib.licenses.bsd2;
    maintainers = [ "morninbru" ];
    mainProgram = "asm-lsp";
    platforms = lib.platforms.unix;
  };
}
