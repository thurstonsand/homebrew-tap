class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.8.0/ghosttykit_0.8.0_darwin_arm64.zip"
      sha256 "ae6f6102abab73d1a57f87459ed690844caf14f3fdf8e1ba1f28cf5e03769a44"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.8.0/ghosttykit_0.8.0_linux_arm64.zip"
      sha256 "ba768cf764d229c9a55e33a030367957491a34ce7128085e63800269c9f3eac3"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.8.0/ghosttykit_0.8.0_linux_amd64.zip"
      sha256 "03f0bfc0c34b38b18f0a5a5a995642397fdf37cd6a5f161706ace5b7073c0769"
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
    assert_match "gty 0.8.0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.0", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
