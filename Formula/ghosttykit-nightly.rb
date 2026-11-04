class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.1-dev-41850403712-fa6cb58"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-41850403712-fa6cb58/ghosttykit_0.8.1-dev-41850403712-fa6cb58_darwin_arm64.zip"
      sha256 "1af3b5cac473d146286b01b7c252bd3a9848c47404df80553f396043c10c9a18"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-41850403712-fa6cb58/ghosttykit_0.8.1-dev-41850403712-fa6cb58_linux_arm64.zip"
      sha256 "b6ba69346e48606ec8e34a90e9d74792c1f4a063201a7d0385cb231872c8eee8"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-41850403712-fa6cb58/ghosttykit_0.8.1-dev-41850403712-fa6cb58_linux_amd64.zip"
      sha256 "f7b1ce582a067fc78bd3defeadb0b0a413e5d58ad54fadb68351e5567a47ae00"
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
    assert_match "gty 0.8.1-dev-41850403712-fa6cb58 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.1-dev-41850403712-fa6cb58", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
