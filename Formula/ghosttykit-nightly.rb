class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.2-dev-41461023634-9845d6e"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-41461023634-9845d6e/ghosttykit_0.7.2-dev-41461023634-9845d6e_darwin_arm64.zip"
      sha256 "a3995eb29a1d81aabd4db4a4bce948419d6db4791ff6368cbfa1414c00a07cea"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-41461023634-9845d6e/ghosttykit_0.7.2-dev-41461023634-9845d6e_linux_arm64.zip"
      sha256 "12867ad9097c9dde0eff7989bd35bfefd3dcc6fdd2edc7eed9cfd1a382a26ac0"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-41461023634-9845d6e/ghosttykit_0.7.2-dev-41461023634-9845d6e_linux_amd64.zip"
      sha256 "85d13347bfc332806d11062ab7f9d9e11823c216f7bc1b134323080bffc1325a"
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
    assert_match "gty 0.7.2-dev-41461023634-9845d6e protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.2-dev-41461023634-9845d6e", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
