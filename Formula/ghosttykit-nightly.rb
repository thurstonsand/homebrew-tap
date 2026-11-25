class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-45633882471-f945fa9"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45633882471-f945fa9/ghosttykit_0.8.2-dev-45633882471-f945fa9_darwin_arm64.zip"
      sha256 "c2f31f67884b574322f917449b89e56a93f21f0e30713ea7f6aab363a8481e26"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45633882471-f945fa9/ghosttykit_0.8.2-dev-45633882471-f945fa9_linux_arm64.zip"
      sha256 "7b1af9c3aebeb80aa388ca422171a6f42352cad7ccfd55e14814ec4f72239311"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45633882471-f945fa9/ghosttykit_0.8.2-dev-45633882471-f945fa9_linux_amd64.zip"
      sha256 "e32a91280cd7501e735ebd42e7aa4295e3a44e4a395ceaeb1a6bfea7337e70f9"
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
    assert_match "gty 0.8.2-dev-45633882471-f945fa9 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-45633882471-f945fa9", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
