class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.2-dev-39257900017-6d82741"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-39257900017-6d82741/ghosttykit_0.7.2-dev-39257900017-6d82741_darwin_arm64.zip"
      sha256 "a7b55b361a706b95dc26c86def096bd55e26428a61bca57dea641906305cc926"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-39257900017-6d82741/ghosttykit_0.7.2-dev-39257900017-6d82741_linux_arm64.zip"
      sha256 "1d57a9fdff4103754679e36296627e7883e10c66ae579e58f8e964e29e8932b0"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-39257900017-6d82741/ghosttykit_0.7.2-dev-39257900017-6d82741_linux_amd64.zip"
      sha256 "05b1b574874419f1508da0b1ef976fcd912cd501fb3b10389214fcff6cd7c812"
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
    assert_match "gty 0.7.2-dev-39257900017-6d82741 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.2-dev-39257900017-6d82741", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
