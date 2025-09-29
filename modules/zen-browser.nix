{ pkgs-unstable, ... }:

let
  # Use the unstable version of Nixpkgs
  pkgs = pkgs-unstable;

  # Define the version of Zen Browser and Firefox
  version = "1.12.10b";
  firefoxVersion = "132.0.1";

  # Feature flags
  generic = false;
  debugBuild = false;

  # On 32bit platforms, we disable adding "-g" for easier linking.
  enableDebugSymbols = !pkgs.stdenv.hostPlatform.is32bit;
  alsaSupport = pkgs.stdenv.hostPlatform.isLinux;
  ffmpegSupport = true;
  gssSupport = true;
  jackSupport = pkgs.stdenv.hostPlatform.isLinux;
  jemallocSupport = !pkgs.stdenv.hostPlatform.isMusl;
  pipewireSupport = waylandSupport && webrtcSupport;
  pulseaudioSupport = pkgs.stdenv.hostPlatform.isLinux;
  sndioSupport = pkgs.stdenv.hostPlatform.isLinux;
  waylandSupport = true;
  privacySupport = false;
  crashreporterSupport =
    !privacySupport && !pkgs.stdenv.hostPlatform.isRiscV && !pkgs.stdenv.hostPlatform.isMusl;
  geolocationSupport = !privacySupport;
  webrtcSupport = !privacySupport;

  # Surfer required for building Zen Browser (combining with firefox)
  surfer = pkgs.buildNpmPackage {
    pname = "surfer";
    version = "1.6.0";

    src = pkgs.fetchFromGitHub {
      owner = "zen-browser";
      repo = "surfer";
      # rev = "50af7094ede6e9f0910f010c531f8447876a6464";
      rev = "fafc5b8db7c59e3f63c0bcc22bb4b3f152e7535a";
      hash = "sha256-wmAWg6hoICNHfoXJifYFHmyFQS6H22u3GSuRW4alexw=";
    };

    patches = [
      (pkgs.fetchpatch {
        url = "https://github.com/youwen5/nixpkgs/raw/refs/heads/zen-browser-latest/pkgs/by-name/ze/zen-browser-unwrapped/surfer-dont-check-update.patch";
        hash = "sha256-CC8+hw6p8Mf9XGaLcerAmbfrIWffuMsy7tx81IBYEps=";
      })
    ];

    npmDepsHash = "sha256-p0RVqn0Yfe0jxBcBa/hYj5g9XSVMFhnnZT+au+bMs18=";
    makeCacheWritable = true;

    SHARP_IGNORE_GLOBAL_LIBVIPS = false;
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.vips ];
  };

  # LLVM for cross-compilation
  llvmPackages0 = pkgs.rustc.llvmPackages;
  llvmPackagesBuildBuild0 = pkgs.pkgsBuildBuild.rustc.llvmPackages;

  llvmPackages = llvmPackages0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };
  llvmPackagesBuildBuild = llvmPackagesBuildBuild0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };

  buildpkgs.stdenv = pkgs.overrideCC llvmPackages.stdenv (
    llvmPackages.stdenv.cc.override { bintools = pkgs.buildPackages.rustc.llvmPackages.bintools; }
  );

  # Wasm
  inherit (pkgs.pkgsCross) wasi32;

  wasiSysRoot = pkgs.runCommand "wasi-sysroot" { } ''
    mkdir -p "$out"/lib/wasm32-wasi
    for lib in ${wasi32.llvmPackages.libcxx}/lib/*; do
      ln -s "$lib" "$out"/lib/wasm32-wasi
    done
  '';

  # Firefox build environment
  firefox-l10n = pkgs.fetchFromGitHub {
    owner = "mozilla-l10n";
    repo = "firefox-l10n";
    rev = "9d639cd79d6b73081fadb3474dd7d73b89732e7b";
    hash = "sha256-+2JCaPp+c2BRM60xFCeY0pixIyo2a3rpTPaSt1kTfDw=";
  };
  disableAVX = if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then "--disable-wasm-avx" else "";
in
let
  python = pkgs.python311Full;
  zen-browser-unwrapped = buildpkgs.stdenv.mkDerivation rec {
    pname = "zen-browser-unwrapped";
    inherit version;
    inherit (pkgs) gtk3;

    src = pkgs.fetchFromGitHub {
      owner = "zen-browser";
      repo = "desktop";
      rev = version;
      hash = "sha256-7GsZk3zzNMrcP2Iwxkhzxq/ztIFHcFi/hTCXidM4cso=";
      fetchSubmodules = true;
    };

    patches = [];

    inherit firefoxVersion;
    firefoxSrc = pkgs.fetchurl {
      url = "mirror://mozilla/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
      hash = "sha256-XAMbVywdpyZnfi/5e2rVp+OyM4em/DljORy1YvgKXkg=";
    };

     # Create a custom Python environment with exact versions
     psutil_5_9_4 = pkgs.python311Packages.psutil.overrideAttrs (old: {
      version = "5.9.4";
      src = pkgs.fetchPypi {
        pname = "psutil";
        version = "5.9.4";
        hash = "sha256-PX+XOetDXUsTOJRKviP0lYS95TlfJ0h9LuJa2ah3SmI=";
      };
        # Remove macOS-specific patches for Linux builds :cite[1]
        patches = pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
          # Add Linux-specific patches if needed
        ];
        
        # Disable macOS-specific substitution
        postPatch = pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
          substituteInPlace psutil/arch/osx/cpu.c \
            --replace 'kIOMainPortDefault' 'kIOMasterPortDefault'
        '';
    });
    zstandard_0_22_0 = pkgs.python311Packages.buildPythonPackage rec {
    pname = "zstandard";
    version = "0.22.0";
    format = "setuptools";
    src = pkgs.fetchPypi {
      pname = "zstandard";
      version = "0.22.0";
      hash = "sha256-giajPFQry1TNa9CjZgZ7YQtBcTtkyavsG8RTPWn1HnA=";
    };
    nativeBuildInputs = [
      pkgs.python311Packages.cffi
      pkgs.python311Packages.setuptools
      pkgs.python311Packages.wheel
    ];
    postPatch = ''
      sed -i '/requires = \[/ s/setuptools/&<69.0.0, /' pyproject.toml
    '';
    doCheck = false; # Optionally disable tests if they require network or fail
  };

    # glean_sdk_61_2_0 = pkgs.python3Packages.buildPythonPackage rec {
    #   version = "61.2.0";
    #   pname = "glean-sdk";

    #   src = pkgs.fetchPypi {
    #     pname = "glean_sdk";
    #     version = "61.2.0";
    #     hash = "sha256-ZJ4TKOPBt3VjE0twqg4e7G02ZL9cEa7uSkzcfgfDuQw=";
    #   };

    #   # Enable PEP 517 build mode
    #   format = "pyproject";

    #   # Add Rust build dependencies
    #   nativeBuildInputs = with pkgs; [
    #     cargo
    #     rustc
    #     maturin
    #     python3Packages.setuptools-rust
    #     python3Packages.pythonRelaxDepsHook
    #   ];

    #   # Required for Rust bindings
    #   buildInputs = with pkgs; [
    #     openssl
    #   ];

    #   # Set environment variables for Rust build
    #   preBuild = ''
    #     export OPENSSL_DIR="${pkgs.openssl.dev}"
    #     export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"

    #     # Ensure maturin is in PATH and importable

    
    #   '';

    #   # Workaround for missing Cargo.lock in source
    #   cargoDeps = pkgs.rustPlatform.importCargoLock {
    #     lockFile = ./Cargo.lock;
    #   };


    #   # Disable tests that require network access
    #   doCheck = false;

    #   # Fix maturin discovery
    #   pythonRemoveDeps = [ "maturin" ];
    # };
    # glean_sdk_61_2_0 = pkgs.python3Packages.glean-sdk.overrideAttrs (old: {
    #   version = "61.2.0";
    #   pname = "glean-sdk";
    #   # https://files.pythonhosted.org/packages/b2/58/4a83d7c607fd3cfb5872c9d7dd4da244f87f1474dd82f99493656b977dca/glean_sdk-61.2.0.tar.gz
    #   src = pkgs.fetchPypi {
    #     pname = "glean_sdk";
    #     version = "61.2.0";
    #     hash = "sha256-ZJ4TKOPBt3VjE0twqg4e7G02ZL9cEa7uSkzcfgfDuQw="; # Update hash
    #   };
    #   cargoHash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";
    #   # src = pkgs.fetchurl rec {
    #   #   version = "60.4.0";
    #   #   url = "https://files.pythonhosted.org/packages/b2/58/4a83d7c607fd3cfb5872c9d7dd4da244f87f1474dd82f99493656b977dca/glean_sdk-${version}.tar.gz";
    #   #   hash = "sha256-ZJ4TKOPBt3VjE0twqg4e7G02ZL9cEa7uSkzcfgfDuQw=";
    #   #   name = "glean-sdk-${version}.tar.gz"; 
    #   # };

    #   # unpackCmd = "tar xzf $curSrc";
    # });

    glean_sdk_61_2_0 = pkgs.python311Packages.buildPythonPackage rec {
      pname = "glean-sdk";
      version = "61.2.0";

      format = "setuptools";

      src = pkgs.fetchFromGitHub {
        owner = "mozilla";
        repo = "glean";
        rev = "v${version}";
        hash = "sha256-MB+1NzQvOooYlUaMHGBBjpCTGGM7Tq/sNMyLkoe0U0Q=";
      };

      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        inherit src;
        name = "${pname}-${version}";
        hash = "sha256-7HOJEpFIRUqkR3lTwCt3NmEV0VgYWFpMDxeLun7x4JI=";
      };

      nativeBuildInputs = with pkgs; [
        rustPlatform.cargoSetupHook
        rustPlatform.maturinBuildHook
        cargo
        rustc
        maturin
        python311Packages.setuptools
      ];

      buildInputs = with pkgs; [
        openssl
        python311Packages.glean-parser
        python311Packages.semver
        tcl
        tk
        libtommath
      ];

      preBuild = ''
        export OPENSSL_DIR="${pkgs.openssl.dev}"
        export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
        export NIX_CFLAGS_COMPILE="-I${pkgs.libtommath}/include $NIX_CFLAGS_COMPILE"
      '';
    };
    mozillaPython = pkgs.python311.buildEnv.override {
      extraLibs = with pkgs.python311Packages; [
        psutil_5_9_4
        glean_sdk_61_2_0
        zstandard_0_22_0  
        macholib
        wheel
        semver
        (setuptools.overridePythonAttrs (old: { version = "68.2.2"; })) # Pin setuptools
      ];
    };

    nativeBuildInputs = with pkgs; [
      autoconf cargo git gnum4 llvmPackagesBuildBuild.bintools makeWrapper nasm
      nodejs pkg-config python311 rsync rust-cbindgen rustPlatform.bindgenHook
      rustc surfer unzip wrapGAppsHook3 xorg.xvfb
      mozillaPython

    ] ++ pkgs.lib.optionals crashreporterSupport [
        pkgs.dump_syms
        pkgs.patchelf
    ];

    extraConfigureFlags = [
      "--with-system-python=${pkgs.python311.interpreter}"
    ];

    buildInputs = with pkgs; [
      atk cairo cups dbus dbus-glib ffmpeg fontconfig freetype gdk-pixbuf gtk3 glib icu73 libGL libGLU
      libevent libffi libglvnd libjpeg libnotify libpng libstartup_notification libva libvpx
      libwebp libxml2 mesa nspr nss_latest pango pciutils pipewire udev xcb-util-cursor zlib
    ] ++ (with pkgs.xorg; [
      libX11 libXcursor libXdamage libXext libXft libXi libXrender libXt libXtst pixman
      xorgproto libxcb libXrandr libXcomposite libXfixes libXScrnSaver
    ])
    ++ pkgs.lib.optional alsaSupport pkgs.alsa-lib
    ++ pkgs.lib.optional jackSupport pkgs.libjack2
    ++ pkgs.lib.optional pulseaudioSupport pkgs.libpulseaudio
    ++ pkgs.lib.optional sndioSupport pkgs.sndio
    ++ pkgs.lib.optional gssSupport pkgs.libkrb5
    ++ pkgs.lib.optional jemallocSupport pkgs.jemalloc
    ++ pkgs.lib.optionals waylandSupport [
      pkgs.libdrm
      pkgs.libxkbcommon
    ];

    configureFlags =
    [
      "--disable-bootstrap"
      "--disable-updater"
      "${disableAVX}"
      "--enable-default-toolkit=cairo-gtk3${pkgs.lib.optionalString waylandSupport "-wayland"}"
      "--enable-system-pixman"
      "--with-distribution-id=org.nixos"
      "--with-libclang-path=${llvmPackagesBuildBuild.libclang.lib}/lib"
      "--with-system-ffi"
      "--with-system-icu"
      "--with-system-jpeg"
      "--with-system-libevent"
      "--with-system-libvpx"
      "--with-system-nspr"
      "--with-system-nss"
      "--with-system-png" # needs APNG support
      "--with-system-webp"
      "--with-system-zlib"
      "--with-wasi-sysroot=${wasiSysRoot}"
      "--host=${buildpkgs.stdenv.buildPlatform.config}"
      "--target=${buildpkgs.stdenv.hostPlatform.config}"
    ]
    ++ [
      (pkgs.lib.enableFeature alsaSupport "alsa")
      (pkgs.lib.enableFeature ffmpegSupport "ffmpeg")
      (pkgs.lib.enableFeature geolocationSupport "necko-wifi")
      (pkgs.lib.enableFeature gssSupport "negotiateauth")
      (pkgs.lib.enableFeature jackSupport "jack")
      (pkgs.lib.enableFeature jemallocSupport "jemalloc")
      (pkgs.lib.enableFeature pulseaudioSupport "pulseaudio")
      (pkgs.lib.enableFeature sndioSupport "sndio")
      (pkgs.lib.enableFeature webrtcSupport "webrtc")
      # --enable-release adds -ffunction-sections & LTO that require a big amount
      # of RAM, and the 32-bit memory space cannot handle that linking
      (pkgs.lib.enableFeature (!debugBuild && !pkgs.stdenv.hostPlatform.is32bit) "release")
      (pkgs.lib.enableFeature enableDebugSymbols "debug-symbols")
    ];

    configureScript = pkgs.writeShellScript "configureMozconfig" ''
    ${
    if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then
      ''
        echo "ac_add_options --with-libclang-path=/usr/lib64" >> ./configs/linux/mozconfig

        # linux mozconfig
        sed -i 's/x86-\(64\|64-v3\)/native/g' ./configs/linux/mozconfig
        sed -i 's/x86_64-pc-linux/aarch64-linux-gnu/g' ./configs/linux/mozconfig

        # eme/widevine must be disabled on arm64 (thx google)
        sed -i '/--enable-eme/s/^/# /' ./configs/common/mozconfig
        sed -i 's/-msse3//g' ./configs/linux/mozconfig
        sed -i 's/-mssse3//g' ./configs/linux/mozconfig
        sed -i 's/-msse4.1//g' ./configs/linux/mozconfig
        sed -i 's/-msse4.2//g' ./configs/linux/mozconfig
        sed -i 's/-mavx2//g' ./configs/linux/mozconfig
        sed -i 's/-mavx//g' ./configs/linux/mozconfig
        sed -i 's/-mfma//g' ./configs/linux/mozconfig
        sed -i 's/-maes//g' ./configs/linux/mozconfig
        sed -i 's/-mpopcnt//g' ./configs/linux/mozconfig
        sed -i 's/-mpclmul//g' ./configs/linux/mozconfig
        sed -i 's/+avx2//g' ./configs/linux/mozconfig
        sed -i 's/+sse4.1//g' ./configs/linux/mozconfig
      ''
    else
      ""
    }

    for flag in $@; do
      echo "ac_add_options $flag" >> mozconfig
    done
    '';

    preConfigure = ''
      export HOME="$TMPDIR"
      git config --global user.email "nixbld@localhost"
      git config --global user.name "nixbld"
      git init
      git add --all
      git commit -m 'nixpkgs'

      export LLVM_PROFDATA=llvm-profdata
      export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=system
      export WASM_CC=${wasi32.pkgs.stdenv.cc}/bin/${wasi32.pkgs.stdenv.cc.targetPrefix}cc
      export WASM_CXX=${wasi32.pkgs.stdenv.cc}/bin/${wasi32.pkgs.stdenv.cc.targetPrefix}c++

      export ZEN_RELEASE=1
      echo "Running"
      export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="system"
      export PYTHONPATH="${mozillaPython}/${mozillaPython.sitePackages}"
      surfer ci --brand alpha --display-version ${version}
      install -D ${firefoxSrc} .surfer/engine/firefox-${firefoxVersion}.source.tar.xz
      echo "Using Firefox source: ${firefoxSrc}"
      echo "Skipping surfer download due to version mismatch bug"
      surfer download
      surfer import
      patchShebangs engine/mach engine/build engine/tools
    '';

    preBuild = ''
      cp -r ${firefox-l10n} l10n/firefox-l10n

      for lang in $(cat ./l10n/supported-languages); do
        rsync -av --progress l10n/firefox-l10n/"$lang"/ l10n/"$lang" --exclude .git
      done

      sh scripts/copy-language-pack.sh en-US

      for lang in $(cat ./l10n/supported-languages); do
        sh scripts/copy-language-pack.sh "$lang"
      done

      Xvfb :2 -screen 0 1024x768x24 &
      export DISPLAY=:2
    '';

    buildPhase = ''
      runHook preBuild

      surfer build

      runHook postBuild
    '';

    preInstall = ''
      cd engine/obj-*
    '';

    meta = {
      mainProgram = "zen";
      description = "Firefox based browser with a focus on privacy and customization";
      homepage = "https://www.zen-browser.app/";
      license = pkgs.lib.licenses.mpl20;
      platforms = [
        "x86_64-linux"
      ];
    };

    enableParallelBuilding = true;
    requiredSystemFeatures = [ "big-parallel" ];

    passthru = {
      updateScript = ./update.sh;

      # These values are used by `wrapFirefox`.
      # ref; `pkgs/applications/networking/browsers/firefox/wrapper.nix'
      binaryName = meta.mainProgram;
      applicationName = "zen";
      inherit alsaSupport;
      inherit jackSupport;
      inherit pipewireSupport;
      inherit sndioSupport;
      inherit (pkgs.nspr);
      inherit ffmpegSupport;
      inherit gssSupport;
      inherit (pkgs.gtk3);
      inherit wasiSysRoot;
    };
  };
in
pkgs.wrapFirefox zen-browser-unwrapped {
  pname = "zen-browser";
  libName = "zen";
}

