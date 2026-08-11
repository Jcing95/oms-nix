{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "oms";
  version = "1.303.0";

  src = fetchFromGitHub {
    owner = "codesphere-cloud";
    repo = "oms";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uaFiEtkXufzjJb0yt4cRtF5aE2vZc6SMMoMcYUlcHzk=";
  };

  vendorHash = "sha256-Vag6EZdzsp6s9+OEUMHbP0hHG0x6QEjhqDDtcrxdlac=";

  subPackages = [ "cli" ];

  ldflags =
    let
      pkg = "github.com/codesphere-cloud/oms/internal/version";
    in
    [
      "-X ${pkg}.version=${finalAttrs.version}"
      "-X ${pkg}.commit=${finalAttrs.src.rev}"
      "-X ${pkg}.os=${stdenv.hostPlatform.parsed.kernel.name}"
      "-X ${pkg}.arch=${stdenv.hostPlatform.parsed.cpu.name}"
    ];

  postInstall = ''
    mv $out/bin/cli $out/bin/oms
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Codesphere OMS CLI";
    homepage = "https://github.com/codesphere-cloud/oms";
    changelog = "https://github.com/codesphere-cloud/oms/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "oms";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
