class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.1-dev-37852850219-20732e9"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-37852850219-20732e9/ghosttykit_0.7.1-dev-37852850219-20732e9_darwin_arm64.zip"
      sha256 "d6d6e4e021a11bb9a73dc66cc071c7d45ea696a872a3036e9269f8eaf606b11f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-37852850219-20732e9/ghosttykit_0.7.1-dev-37852850219-20732e9_linux_arm64.zip"
      sha256 "baac184e845d27eb17b7055a757d98a4be28b8b5e9360270ace3af12fbfc5313"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-37852850219-20732e9/ghosttykit_0.7.1-dev-37852850219-20732e9_linux_amd64.zip"
      sha256 "22d3cb41e296c1893643ae3923b627a005bca603257a299676047540ef2065b9"
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
    assert_match "gty 0.7.1-dev-37852850219-20732e9 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.1-dev-37852850219-20732e9", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
