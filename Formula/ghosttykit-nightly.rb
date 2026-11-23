class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-45192613958-185686c"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45192613958-185686c/ghosttykit_0.8.2-dev-45192613958-185686c_darwin_arm64.zip"
      sha256 "b9d457b931b5266d552ac7f464e1721a4c91229948d7f91c33a465f7a4421d88"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45192613958-185686c/ghosttykit_0.8.2-dev-45192613958-185686c_linux_arm64.zip"
      sha256 "33eb4879058eaabd57fc4127367387b9f62da8178d9a5b08b3acda28589cfe99"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45192613958-185686c/ghosttykit_0.8.2-dev-45192613958-185686c_linux_amd64.zip"
      sha256 "f8a8a307e75a973edbd44f106fdf83a881900891c833a69dde4c1089996d9271"
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
    assert_match "gty 0.8.2-dev-45192613958-185686c protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-45192613958-185686c", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
