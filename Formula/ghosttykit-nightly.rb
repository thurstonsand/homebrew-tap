class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.1-dev-42680835153-38abfa1"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42680835153-38abfa1/ghosttykit_0.8.1-dev-42680835153-38abfa1_darwin_arm64.zip"
      sha256 "5effe4147938d1e03945e0d93bc8a127ff50bba556c7a88e97508252efddf678"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42680835153-38abfa1/ghosttykit_0.8.1-dev-42680835153-38abfa1_linux_arm64.zip"
      sha256 "f8b3b95a8a787e88753048ec4e56d3cc8dc24e27db5f596062daad01f005aa90"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.1-dev-42680835153-38abfa1/ghosttykit_0.8.1-dev-42680835153-38abfa1_linux_amd64.zip"
      sha256 "4b6c8ec3bf5b404d2c9ce7f086e34e8ccf194a36917c47fef51d1c418e1572d9"
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
    assert_match "gty 0.8.1-dev-42680835153-38abfa1 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.1-dev-42680835153-38abfa1", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
