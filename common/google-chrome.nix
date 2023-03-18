{ lib
, pkgs
# Disabling GPU VSync seems to fix UI freezes
# without turning off hardware acceleration completely
, disableGpuVsync ? false
, ...
}:

pkgs.google-chrome.override {
  # Note: keeping --enable-features at the end to work around a bug in Chrome
  commandLineArgs = [
    "--force-device-scale-factor=1.0"
    "--password-store=basic"
    "--force-dark-mode"
  ] ++ (lib.optional disableGpuVsync "--disable-gpu-vsync") ++ [
    "--enable-features=WebUIDarkMode"
  ];
}
