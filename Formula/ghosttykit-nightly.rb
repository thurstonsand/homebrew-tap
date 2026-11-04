class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.1-dev-41844010819-389bfb7"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-41844010819-389bfb7/ghosttykit_0.8.1-dev-41844010819-389bfb7_darwin_arm64.zip"
      sha256 "01ec8e774f89559dd7307925d7a6196bec5f7217d381313e649a8054199905a8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-41844010819-389bfb7/ghosttykit_0.8.1-dev-41844010819-389bfb7_linux_arm64.zip"
      sha256 "158d6292be98b70fd706e5bec028335dc62b7be6b3117d410917300e08a34d47"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-41844010819-389bfb7/ghosttykit_0.8.1-dev-41844010819-389bfb7_linux_amd64.zip"
      sha256 "e88ac2c927b9ee15088e870c25a6e140a6c201b8946ca8c6e48a02dcbf5cb4bd"
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
    assert_match "gty 0.8.1-dev-41844010819-389bfb7 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.1-dev-41844010819-389bfb7", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
