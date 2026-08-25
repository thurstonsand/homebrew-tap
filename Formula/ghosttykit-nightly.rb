class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-32807367333-b80eeb2"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32807367333-b80eeb2/ghosttykit_0.6.1-dev-32807367333-b80eeb2_darwin_arm64.zip"
      sha256 "8d42e7e8ba6983926ceba04573e702326068ff1a30a362f53a0cf6baa457ee76"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32807367333-b80eeb2/ghosttykit_0.6.1-dev-32807367333-b80eeb2_linux_arm64.zip"
      sha256 "cb46c16fc55c26828608d10f490e8a29d6229cc470e11417ced935eceb60b3a0"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32807367333-b80eeb2/ghosttykit_0.6.1-dev-32807367333-b80eeb2_linux_amd64.zip"
      sha256 "167795d9457dc65410116ed473d1c54d0a23583c2d6b10cea119c0307eb6392e"
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
    assert_match "gty 0.6.1-dev-32807367333-b80eeb2 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-32807367333-b80eeb2", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
