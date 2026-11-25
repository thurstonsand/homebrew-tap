class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-45666330468-8518457"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45666330468-8518457/ghosttykit_0.8.2-dev-45666330468-8518457_darwin_arm64.zip"
      sha256 "0941141314c950adbaf3563245478cc5de9613f6f310f7595d15b2eddb61ffee"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45666330468-8518457/ghosttykit_0.8.2-dev-45666330468-8518457_linux_arm64.zip"
      sha256 "c5d1e28b236429982b64b443ddab2fb2df09dbae671419ca989d2595cd50b20b"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45666330468-8518457/ghosttykit_0.8.2-dev-45666330468-8518457_linux_amd64.zip"
      sha256 "2608d1fc015c02ec7d49fc555ddb44b17ca996599db9570433d65ae5c6199e80"
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
    assert_match "gty 0.8.2-dev-45666330468-8518457 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-45666330468-8518457", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
