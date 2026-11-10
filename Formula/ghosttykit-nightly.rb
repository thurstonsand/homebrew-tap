class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.1-dev-42883888511-574196f"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42883888511-574196f/ghosttykit_0.8.1-dev-42883888511-574196f_darwin_arm64.zip"
      sha256 "144f6328fbb0719d7ca08cfe5bf91334183896e799f5b9ded3198bd259031b3c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42883888511-574196f/ghosttykit_0.8.1-dev-42883888511-574196f_linux_arm64.zip"
      sha256 "3848ab30856003402943ac1d13e42647d2943371c041b20669878ac1acf51a36"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42883888511-574196f/ghosttykit_0.8.1-dev-42883888511-574196f_linux_amd64.zip"
      sha256 "28c7520f3bcd5d3c212f07ffa91d4fe29e8daee92e17f1e17e5b6ecabb3c49ca"
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
    assert_match "gty 0.8.1-dev-42883888511-574196f protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.1-dev-42883888511-574196f", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
