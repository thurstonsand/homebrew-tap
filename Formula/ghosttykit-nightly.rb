class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.4.0-dev-30729387334-53d9e8f"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-30729387334-53d9e8f/ghosttykit_0.4.0-dev-30729387334-53d9e8f_darwin_arm64.zip"
      sha256 "7fbe98aedbfba01615289ed49a808cf84ae01c7116c88c3eed50ff67ba51fb31"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-30729387334-53d9e8f/ghosttykit_0.4.0-dev-30729387334-53d9e8f_darwin_amd64.zip"
      sha256 "aaee2bb8e09f34d406bbec54de1ce529775b51995d82e43c0f870cb811b30eee"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-30729387334-53d9e8f/ghosttykit_0.4.0-dev-30729387334-53d9e8f_linux_arm64.zip"
      sha256 "bb80ffa9e0625ac1dd46d333613674aa2dcaf7cf71518ea89966e947ac7b272b"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-30729387334-53d9e8f/ghosttykit_0.4.0-dev-30729387334-53d9e8f_linux_amd64.zip"
      sha256 "82c695d76af949c07e76bc0a5f0b5532f67f30a3a0b02b5d74db3b784a13efdb"
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
    assert_match "gty 0.4.0-dev-30729387334-53d9e8f protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.4.0-dev-30729387334-53d9e8f", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
