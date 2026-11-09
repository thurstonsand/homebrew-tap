class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.1-dev-42676547166-75f8be0"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42676547166-75f8be0/ghosttykit_0.8.1-dev-42676547166-75f8be0_darwin_arm64.zip"
      sha256 "dd6905ba2dc30cb7a6f05e3e0dd0b4ad01d7a3b1324427cc2f1874951f12ac1f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42676547166-75f8be0/ghosttykit_0.8.1-dev-42676547166-75f8be0_linux_arm64.zip"
      sha256 "f75d38735a36e2ca2c9d0a633450e521e084443b3c4a2bbbd65c023c983f601d"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42676547166-75f8be0/ghosttykit_0.8.1-dev-42676547166-75f8be0_linux_amd64.zip"
      sha256 "424d524c4c7ce2f71cce9820ecc44f95fb86d71bbcb8f9d4b005fcfe9038a6fe"
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
    assert_match "gty 0.8.1-dev-42676547166-75f8be0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.1-dev-42676547166-75f8be0", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
