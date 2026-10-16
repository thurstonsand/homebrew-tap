class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.1-dev-38849726345-9ddc023"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38849726345-9ddc023/ghosttykit_0.7.1-dev-38849726345-9ddc023_darwin_arm64.zip"
      sha256 "4377776f1aada461c743f1b0f0d3560db813aff1e1a239ae6ff72a8aedf943d4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38849726345-9ddc023/ghosttykit_0.7.1-dev-38849726345-9ddc023_linux_arm64.zip"
      sha256 "a3337c3d526fc31c610ac06c01795d46a3bb2d62a24355623049815bf24cc397"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38849726345-9ddc023/ghosttykit_0.7.1-dev-38849726345-9ddc023_linux_amd64.zip"
      sha256 "68d434bf018bfdf4237148011f3500e61470aad998e4641643dc75775d2924cc"
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
    assert_match "gty 0.7.1-dev-38849726345-9ddc023 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.1-dev-38849726345-9ddc023", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
