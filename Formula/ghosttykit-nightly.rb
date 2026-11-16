class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-43897247830-1f3397f"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-43897247830-1f3397f/ghosttykit_0.8.2-dev-43897247830-1f3397f_darwin_arm64.zip"
      sha256 "7899f975012a903f70cf621f461aed391d02070b42a2b321b530e738d6bac6da"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-43897247830-1f3397f/ghosttykit_0.8.2-dev-43897247830-1f3397f_linux_arm64.zip"
      sha256 "ae6ea900dec070a6579d225bc742f27f4359e655a0a5b6ed841f919c9204113e"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-43897247830-1f3397f/ghosttykit_0.8.2-dev-43897247830-1f3397f_linux_amd64.zip"
      sha256 "2dc9e58359485fee74a72264df9d62bc605297fb482848531f95e680355f16ac"
    end
  end

  conflicts_with "ghosttykit", because: "both install gty"

  def install
    bin.install "bin/gty"
    return unless OS.mac?

    prefix.install "GhosttyKitD.app"
    bin.install_symlink prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd" => "ghosttykitd"
  end

  service do
    run macos: [opt_prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd"]
    keep_alive true
    working_dir var
    log_path var/"log/ghosttykitd.log"
    error_log_path var/"log/ghosttykitd.log"
  end

  def caveats
    notice = "This formula tracks nightly builds from GhosttyKit main and may break.\n\n"
    if OS.mac?
      notice + <<~EOS
        Start Ghostty, then start the GhosttyKit daemon:

          brew services start #{full_name}

        On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
        Grant access, then verify the install with:

          gty doctor
      EOS
    else
      notice + <<~EOS
        This installs the gty CLI only. The GhosttyKit daemon is macOS-only, so gty here
        serves SSH sessions bridged from a macOS host by gty ssh.
      EOS
    end
  end

  test do
    assert_match "gty 0.8.2-dev-43897247830-1f3397f protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-43897247830-1f3397f", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
