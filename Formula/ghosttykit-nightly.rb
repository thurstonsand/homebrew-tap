class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-37155446752-24f5f7a"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-37155446752-24f5f7a/ghosttykit_0.6.1-dev-37155446752-24f5f7a_darwin_arm64.zip"
      sha256 "63a0bce3009dc0fd9801e13e72074c5ab4c6063c6901ed18a6e13bd6d357cb1b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-37155446752-24f5f7a/ghosttykit_0.6.1-dev-37155446752-24f5f7a_linux_arm64.zip"
      sha256 "32e64dfbbc489c8aa84add15e4aed6bc8a55615b1a90ddccb0e1c36e3c6f1404"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-37155446752-24f5f7a/ghosttykit_0.6.1-dev-37155446752-24f5f7a_linux_amd64.zip"
      sha256 "ae1a12f461b6f52cbb648851bf424326a002322bc7da2641d92d9152f9eb23da"
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
    assert_match "gty 0.6.1-dev-37155446752-24f5f7a protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-37155446752-24f5f7a", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
