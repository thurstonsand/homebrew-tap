class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.5.1-dev-30878789550-0860082"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30878789550-0860082/ghosttykit_0.5.1-dev-30878789550-0860082_darwin_arm64.zip"
      sha256 "6ab71d53b03e0638102e53de6c4aca91d0765a99013e619763736d35f823bed2"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30878789550-0860082/ghosttykit_0.5.1-dev-30878789550-0860082_darwin_amd64.zip"
      sha256 "9b9105f95667ec91987fc935ad613d2fd4f0963db8e818450e530a0d3b7cca69"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30878789550-0860082/ghosttykit_0.5.1-dev-30878789550-0860082_linux_arm64.zip"
      sha256 "dd3cdd248fa341f4322a44e4cfb81d13190c945c2d110e625f4de0ba2ac0221d"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30878789550-0860082/ghosttykit_0.5.1-dev-30878789550-0860082_linux_amd64.zip"
      sha256 "f152fc480da758e1f28dc4bf5930ea79746264a3ba050b4a061a5187c29d7d80"
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
    assert_match "gty 0.5.1-dev-30878789550-0860082 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.5.1-dev-30878789550-0860082", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
