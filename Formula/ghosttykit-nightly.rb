class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.5.1-dev-30762249837-8c50911"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30762249837-8c50911/ghosttykit_0.5.1-dev-30762249837-8c50911_darwin_arm64.zip"
      sha256 "11968e8bd3e192ed0308d11251d3f9af8a01904ecdc88f7e8d7086f03b6fa16e"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30762249837-8c50911/ghosttykit_0.5.1-dev-30762249837-8c50911_darwin_amd64.zip"
      sha256 "b9ed606786f5267a6b687bd49231b27d050e9c700e7d342377ee9f5a414e2605"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30762249837-8c50911/ghosttykit_0.5.1-dev-30762249837-8c50911_linux_arm64.zip"
      sha256 "2a1f7d017a361431990aca44ac489311f338c17b260a22e1ac5f2d93edca0a0f"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30762249837-8c50911/ghosttykit_0.5.1-dev-30762249837-8c50911_linux_amd64.zip"
      sha256 "d925a34783cb935216f4eaf12d8992622d8789234835f049e5e73a1f960bf1c7"
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
    assert_match "gty 0.5.1-dev-30762249837-8c50911 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.5.1-dev-30762249837-8c50911", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
