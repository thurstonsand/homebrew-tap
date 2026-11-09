class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.1-dev-42665349896-8652375"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42665349896-8652375/ghosttykit_0.8.1-dev-42665349896-8652375_darwin_arm64.zip"
      sha256 "163340978ffd640416d4219c1216fe3787a4d22dd804485d0db4fb6333b4f87b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42665349896-8652375/ghosttykit_0.8.1-dev-42665349896-8652375_linux_arm64.zip"
      sha256 "b3f1747ee7a2d9bc7569919dc7d5d0153f52b3778ab7615bdcee20f6a8c5cd75"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42665349896-8652375/ghosttykit_0.8.1-dev-42665349896-8652375_linux_amd64.zip"
      sha256 "96bd6fa0adb47cce42731bde4936371b06064ef1e5b1fda7543dc30aba0f36cd"
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
    assert_match "gty 0.8.1-dev-42665349896-8652375 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.1-dev-42665349896-8652375", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
