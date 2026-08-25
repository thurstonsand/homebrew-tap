class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-32800022198-b6361f2"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32800022198-b6361f2/ghosttykit_0.6.1-dev-32800022198-b6361f2_darwin_arm64.zip"
      sha256 "c517f5ef388d201b4bea563d30652fcf41dbee7c9c35ff03037204adefcc5bf5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32800022198-b6361f2/ghosttykit_0.6.1-dev-32800022198-b6361f2_linux_arm64.zip"
      sha256 "c3b5be4f767b30fbbdd56ea8d054608c82aaff71c01d929e6478f2e59413d44d"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32800022198-b6361f2/ghosttykit_0.6.1-dev-32800022198-b6361f2_linux_amd64.zip"
      sha256 "d81ca2e641773e230bd6ccfda5e150459e4ea9bd67e7af4d11dcf045f4e80fe0"
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
    assert_match "gty 0.6.1-dev-32800022198-b6361f2 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-32800022198-b6361f2", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
