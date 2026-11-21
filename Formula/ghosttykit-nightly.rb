class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-44853704229-809ff59"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-44853704229-809ff59/ghosttykit_0.8.2-dev-44853704229-809ff59_darwin_arm64.zip"
      sha256 "c8e505f27af0a9295977836a7bb1c3b1f200ebf83900e874da41213978a1e616"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-44853704229-809ff59/ghosttykit_0.8.2-dev-44853704229-809ff59_linux_arm64.zip"
      sha256 "f6fd3e2678734729160d79b8a3fd20f7035b8035438e0fc1c7fcfe24706136aa"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-44853704229-809ff59/ghosttykit_0.8.2-dev-44853704229-809ff59_linux_amd64.zip"
      sha256 "ac0e508f119263a1f3663646d8bdd9d297ce6f53eaa6417ab3969af19464d106"
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
    assert_match "gty 0.8.2-dev-44853704229-809ff59 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-44853704229-809ff59", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
