class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.5.0/ghosttykit_0.5.0_darwin_arm64.zip"
      sha256 "c6218bb2aa624f06cc913d2484ab9379f774e32b8a3a4b8d83577fc07f0e0765"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.5.0/ghosttykit_0.5.0_darwin_amd64.zip"
      sha256 "afb04dd72c40ef5f03523c7005566dbb118b81621616ec1444d65b0828c81601"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.5.0/ghosttykit_0.5.0_linux_arm64.zip"
      sha256 "4eb60e24b5469f421bf18a97e2af3312b81d3d6f398fad37dcf089460e6d8be2"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.5.0/ghosttykit_0.5.0_linux_amd64.zip"
      sha256 "7f3b5bfa451d2b45a1814ce346bc20e599b0f1e9a441acbed99a6590edc6b9c5"
    end
  end

  conflicts_with "ghosttykit-nightly", because: "both install gty"

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
    notice = ""
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
    assert_match "gty 0.5.0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.5.0", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
