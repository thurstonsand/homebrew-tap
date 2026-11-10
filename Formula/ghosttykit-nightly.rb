class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-42890315288-e003a1d"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-42890315288-e003a1d/ghosttykit_0.8.2-dev-42890315288-e003a1d_darwin_arm64.zip"
      sha256 "0f20044486229dad578becbce3631f722aa6777d615ae8192082293daab05977"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-42890315288-e003a1d/ghosttykit_0.8.2-dev-42890315288-e003a1d_linux_arm64.zip"
      sha256 "8889a6e1de4c46b82030ca05b7c3f33515f95a824dc522c87b405d140a26fef5"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-42890315288-e003a1d/ghosttykit_0.8.2-dev-42890315288-e003a1d_linux_amd64.zip"
      sha256 "6f121a5a8987599317fde88440f8052523d5c0b32d24bcca2346aa4545598142"
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
    assert_match "gty 0.8.2-dev-42890315288-e003a1d protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-42890315288-e003a1d", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
