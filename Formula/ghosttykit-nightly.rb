class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-36661845341-92fea1d"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-36661845341-92fea1d/ghosttykit_0.6.1-dev-36661845341-92fea1d_darwin_arm64.zip"
      sha256 "ac0966c47db103bf0e26a08eecf7d0b361d8f194c4566feb1717f43e7ab2ca52"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-36661845341-92fea1d/ghosttykit_0.6.1-dev-36661845341-92fea1d_linux_arm64.zip"
      sha256 "03452b0e869259c561fc00d53316028c2c5a3734ee8954c83d4b794ee696ade8"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-36661845341-92fea1d/ghosttykit_0.6.1-dev-36661845341-92fea1d_linux_amd64.zip"
      sha256 "8cf879dedaf10950012a9816bfdb212d607f37cdca2a12be1a01224835978810"
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
    assert_match "gty 0.6.1-dev-36661845341-92fea1d protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-36661845341-92fea1d", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
