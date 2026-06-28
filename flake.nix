{
  description = "RetroArch development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      enableNvidiaCgToolkit = false;
      withVulkan = true;
      withWayland = true;
    in
    {
      devShells.${system}.default =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.mkShell {
          nativeBuildInputs =
            with pkgs;
            [
              pkg-config
              qt6.wrapQtAppsHook
              wrapGAppsHook3
            ]
            ++ lib.optional withWayland wayland;
            # ++ lib.optional (runtimeLibs != [ ]) makeBinaryWrapper;
          buildInputs =
            with pkgs;
            [
              ffmpeg_7
              flac
              freetype
              libGL
              libGLU
              libxml2
              mbedtls
              python3
              qt6.qtbase
              SDL2
              spirv-tools
              zlib
            ]
            ++ lib.optional enableNvidiaCgToolkit nvidia_cg_toolkit
            ++ lib.optional withVulkan vulkan-loader
            ++ lib.optionals withWayland [
              wayland
              wayland-scanner
            ]
            ++ lib.optionals stdenv.hostPlatform.isLinux [
              alsa-lib
              dbus
              libx11
              libxdmcp
              libxext
              libxxf86vm
              libdrm
              libpulseaudio
              libv4l
              libxkbcommon
              libgbm
              pipewire
              udev
            ];
        };
    };
}
