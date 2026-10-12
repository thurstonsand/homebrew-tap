class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.1-dev-38255232890-99845b5"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38255232890-99845b5/ghosttykit_0.7.1-dev-38255232890-99845b5_darwin_arm64.zip"
      sha256 "caa4f1beffa293579f760a0f035ebdbeb152c1d2e254e048b456dc066f140859"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38255232890-99845b5/ghosttykit_0.7.1-dev-38255232890-99845b5_linux_arm64.zip"
      sha256 "94a48678337ace97b407656a68b3aab7b054ad84ff1969b29a44cecd17f2e714"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38255232890-99845b5/ghosttykit_0.7.1-dev-38255232890-99845b5_linux_amd64.zip"
      sha256 "512bf3f29f23c1cce914153242bc36fb24f531b75ad6338b3fa71f63a61cff54"
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
    assert_match "gty 0.7.1-dev-38255232890-99845b5 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.1-dev-38255232890-99845b5", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
