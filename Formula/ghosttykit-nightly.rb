class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-44751937576-fd4b185"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-44751937576-fd4b185/ghosttykit_0.8.2-dev-44751937576-fd4b185_darwin_arm64.zip"
      sha256 "30c2c7b61a2c16cdd8212603fb592a2a7eb14be72b63ffe47385990c2ce95d27"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-44751937576-fd4b185/ghosttykit_0.8.2-dev-44751937576-fd4b185_linux_arm64.zip"
      sha256 "2cebf32062314f3a81518561122e53eafc3568368794b1ae7884d960a06fae8d"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-44751937576-fd4b185/ghosttykit_0.8.2-dev-44751937576-fd4b185_linux_amd64.zip"
      sha256 "ee74f4189ee3db703620bfe94319f1ea46a32345cc34cf83c9401ba785d10ab9"
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
    assert_match "gty 0.8.2-dev-44751937576-fd4b185 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-44751937576-fd4b185", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
