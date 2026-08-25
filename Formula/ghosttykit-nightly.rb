class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-32806555376-869cca9"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32806555376-869cca9/ghosttykit_0.6.1-dev-32806555376-869cca9_darwin_arm64.zip"
      sha256 "a5c5ecb99f4818a00cc84b68907f82243f4d47c44d8f8f5fb15197a5685c952a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32806555376-869cca9/ghosttykit_0.6.1-dev-32806555376-869cca9_linux_arm64.zip"
      sha256 "ba3f7dbb990fc388fc603cb337b92cf4654037dffaf8d70858be12727c528fa2"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32806555376-869cca9/ghosttykit_0.6.1-dev-32806555376-869cca9_linux_amd64.zip"
      sha256 "5c987f2abcc86c1d38f4a6337e3f4f3be25c7f1bcef5d0e2fd2c9b8b6286e40d"
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
    assert_match "gty 0.6.1-dev-32806555376-869cca9 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-32806555376-869cca9", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
