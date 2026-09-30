class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-36668584261-bec496a"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-36668584261-bec496a/ghosttykit_0.6.1-dev-36668584261-bec496a_darwin_arm64.zip"
      sha256 "b4f6ded7da0f9cf0c490b7714a2dd6339a0fdb1b99fe0caa8853ce8a0fdeabe5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-36668584261-bec496a/ghosttykit_0.6.1-dev-36668584261-bec496a_linux_arm64.zip"
      sha256 "0178c6a1a9c8b401dd8c999a837070e6fbdf2125020f751928cea7889c7c745f"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-36668584261-bec496a/ghosttykit_0.6.1-dev-36668584261-bec496a_linux_amd64.zip"
      sha256 "3e6137fc0c60a9292534a8a940f62dfbc15e20686aa1896ef54a92b71a89ea54"
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
    assert_match "gty 0.6.1-dev-36668584261-bec496a protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-36668584261-bec496a", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
