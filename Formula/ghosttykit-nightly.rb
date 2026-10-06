class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-37517604596-99cbd8b"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-37517604596-99cbd8b/ghosttykit_0.6.1-dev-37517604596-99cbd8b_darwin_arm64.zip"
      sha256 "c2c78c9f047421dffa968fce64cbe231eeb601cc4648e59948807abfcf0a28f2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-37517604596-99cbd8b/ghosttykit_0.6.1-dev-37517604596-99cbd8b_linux_arm64.zip"
      sha256 "782bf3136e3d9bd6965dd144f0fd96419d2bf75e00d91b53215e29dd65084ee8"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-37517604596-99cbd8b/ghosttykit_0.6.1-dev-37517604596-99cbd8b_linux_amd64.zip"
      sha256 "3482d7b167f731fcf7445c7d617500615b4d67aade3a855268b819723eb37839"
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
    assert_match "gty 0.6.1-dev-37517604596-99cbd8b protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-37517604596-99cbd8b", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
