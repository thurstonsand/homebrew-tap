class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-45631772064-f36ff72"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45631772064-f36ff72/ghosttykit_0.8.2-dev-45631772064-f36ff72_darwin_arm64.zip"
      sha256 "35572b4dc62e46ecd92112ef34b6bff775853bf85d0ff0c5598d2432eb4cf7c5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45631772064-f36ff72/ghosttykit_0.8.2-dev-45631772064-f36ff72_linux_arm64.zip"
      sha256 "bc259620e2dd75f11cbd91e132529d38c45bc3676ffb136d6cfd2b347f37fb83"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-45631772064-f36ff72/ghosttykit_0.8.2-dev-45631772064-f36ff72_linux_amd64.zip"
      sha256 "37f5d39c583c0f867f960f1a76094f97e9063b4be5afbea82dfaf4f5b3f59006"
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
    assert_match "gty 0.8.2-dev-45631772064-f36ff72 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-45631772064-f36ff72", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
