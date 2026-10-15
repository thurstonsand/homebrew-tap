class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.1-dev-38809667305-f97f40e"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38809667305-f97f40e/ghosttykit_0.7.1-dev-38809667305-f97f40e_darwin_arm64.zip"
      sha256 "5130119e06cdbdd0ff6175556222e2f5dbd781fcf17121ed0d41791f16d0a9bf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38809667305-f97f40e/ghosttykit_0.7.1-dev-38809667305-f97f40e_linux_arm64.zip"
      sha256 "34faedf1bd59e338e79530d22544289a90facc6f12665f9216a32883028ebe30"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38809667305-f97f40e/ghosttykit_0.7.1-dev-38809667305-f97f40e_linux_amd64.zip"
      sha256 "66529e19148b5348f6466f7d9bc078842ea1b7a7eeffa893f7594574e8e75bfc"
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
    assert_match "gty 0.7.1-dev-38809667305-f97f40e protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.1-dev-38809667305-f97f40e", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
