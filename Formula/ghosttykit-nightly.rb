class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.1-dev-38254517739-0271ca1"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38254517739-0271ca1/ghosttykit_0.7.1-dev-38254517739-0271ca1_darwin_arm64.zip"
      sha256 "836d4fc0279b417f751bb4db62fa763f694b60266f2125c8eecd04a435f73e03"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38254517739-0271ca1/ghosttykit_0.7.1-dev-38254517739-0271ca1_linux_arm64.zip"
      sha256 "67767f5cb0ebfc39dde6996eb6fffc47f3d2748518738c8c8b2706484e5986b3"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38254517739-0271ca1/ghosttykit_0.7.1-dev-38254517739-0271ca1_linux_amd64.zip"
      sha256 "00769a637983e08458a32b98b7f10535d47455b32c5957ea1b6187df29535960"
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
    assert_match "gty 0.7.1-dev-38254517739-0271ca1 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.1-dev-38254517739-0271ca1", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
