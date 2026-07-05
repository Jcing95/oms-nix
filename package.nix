{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "oms";
  version = "1.226.0";

  src = fetchFromGitHub {
    owner = "codesphere-cloud";
    repo = "oms";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RLJqYQH2Wqu3G/18kA/psXkLFKnPfQCtZBbFnHC+FH4=";
  };

  vendorHash = "sha256-quv5709hRS6K590F19cavZ68E9SCbpKNRayUuULG34k=";

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
