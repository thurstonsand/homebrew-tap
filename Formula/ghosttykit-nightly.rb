class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.2-dev-40879795958-955ecc4"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-40879795958-955ecc4/ghosttykit_0.7.2-dev-40879795958-955ecc4_darwin_arm64.zip"
      sha256 "08ea5746bbffb4a18b1f483d3d7a807c86a305e64c7f7af3b90531bc81702a9f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-40879795958-955ecc4/ghosttykit_0.7.2-dev-40879795958-955ecc4_linux_arm64.zip"
      sha256 "7714f712ba49fc201194bc02aeeea71914c4949e4bfcf6e957216b6d51df8477"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-40879795958-955ecc4/ghosttykit_0.7.2-dev-40879795958-955ecc4_linux_amd64.zip"
      sha256 "f7d712eb6508ca232722d59d16a513a0d2ad5bf01a091ea7571b95450e5909b0"
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
    assert_match "gty 0.7.2-dev-40879795958-955ecc4 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.2-dev-40879795958-955ecc4", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
