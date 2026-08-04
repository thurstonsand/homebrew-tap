class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.6.0/ghosttykit_0.6.0_darwin_arm64.zip"
      sha256 "af8b2031b4e2cbe929c989d892fc787e106ba9a47efe30ecec839803f2c09b9f"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.6.0/ghosttykit_0.6.0_darwin_amd64.zip"
      sha256 "03c19cec78ca20976803ccf5836822776ae8d91a231d165e556cef2c516f0256"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.6.0/ghosttykit_0.6.0_linux_arm64.zip"
      sha256 "7f913cecf812d220fba349dd6cdc734f51b4dcaa899eeae8ce62f3ed6b3857cd"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.6.0/ghosttykit_0.6.0_linux_amd64.zip"
      sha256 "511a6e4af805addbffff8fd0558bf47182939ec06e00655326c8550a79b2ea6e"
    end
  end

  conflicts_with "ghosttykit-nightly", because: "both install gty"

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
    notice = ""
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
    assert_match "gty 0.6.0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.0", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
