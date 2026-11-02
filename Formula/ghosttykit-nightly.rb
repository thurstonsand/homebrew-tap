class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.1-dev-41526842270-6df0094"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-41526842270-6df0094/ghosttykit_0.8.1-dev-41526842270-6df0094_darwin_arm64.zip"
      sha256 "28d15bed03a2e3afb8508c8f3b5250defe96230b1b85e3c4378425829d8917d8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-41526842270-6df0094/ghosttykit_0.8.1-dev-41526842270-6df0094_linux_arm64.zip"
      sha256 "e5f163e6bf761680334df4ea4fffaf83140ed930aa47ca2e6e26509fdcb3ce94"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-41526842270-6df0094/ghosttykit_0.8.1-dev-41526842270-6df0094_linux_amd64.zip"
      sha256 "40d85eb4d9a07286abd676becf697fe75a6596c827d047881240dd59547611f1"
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
    assert_match "gty 0.8.1-dev-41526842270-6df0094 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.1-dev-41526842270-6df0094", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
