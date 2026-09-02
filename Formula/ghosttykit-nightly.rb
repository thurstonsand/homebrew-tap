class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-33587489840-4b69801"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-33587489840-4b69801/ghosttykit_0.6.1-dev-33587489840-4b69801_darwin_arm64.zip"
      sha256 "c75bc0cd27120cbab4555ee904a15fa274e0ca054c19a9e996144c7e3c895822"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-33587489840-4b69801/ghosttykit_0.6.1-dev-33587489840-4b69801_linux_arm64.zip"
      sha256 "64b429c86c3d17d66b8a6dd94d142775d9cf00891e1a0f1884ee765297832ffb"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-33587489840-4b69801/ghosttykit_0.6.1-dev-33587489840-4b69801_linux_amd64.zip"
      sha256 "c20ff33bb308214f32ed0aa098501ad873ee67f311f733a4592d02760173a732"
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
    assert_match "gty 0.6.1-dev-33587489840-4b69801 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-33587489840-4b69801", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
