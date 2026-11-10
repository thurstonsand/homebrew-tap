class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-42894294953-2984e56"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-42894294953-2984e56/ghosttykit_0.8.2-dev-42894294953-2984e56_darwin_arm64.zip"
      sha256 "7a039cbf46728098868af2aad44a5efc9752278cfa22f2b5f1c271b3febd0234"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-42894294953-2984e56/ghosttykit_0.8.2-dev-42894294953-2984e56_linux_arm64.zip"
      sha256 "8d393639e15fa5b0a984262ff7a90eb8b4e9bd64502d977e3d00ba3eaf93a0b9"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-42894294953-2984e56/ghosttykit_0.8.2-dev-42894294953-2984e56_linux_amd64.zip"
      sha256 "4b4ea10360158b183784c2cefe337649a29d8b5ec7f7786ecd9b8ee628fa83da"
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
    assert_match "gty 0.8.2-dev-42894294953-2984e56 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-42894294953-2984e56", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
