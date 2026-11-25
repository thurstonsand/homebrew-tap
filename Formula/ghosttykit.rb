class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.8.2/ghosttykit_0.8.2_darwin_arm64.zip"
      sha256 "a83e5cf867bae8d3c54835685652e712c3fba744b5cd72cd7ca942259eae6392"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.8.2/ghosttykit_0.8.2_linux_arm64.zip"
      sha256 "ecf2736d4f146bac78112a9871fee487f9f2860482206e1e836ef28e71d2b4ab"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.8.2/ghosttykit_0.8.2_linux_amd64.zip"
      sha256 "48c4f17772eede82306c17b3b75167f9b8eac333ad42831eadd1934f32f04fd8"
    end
  end

  conflicts_with "ghosttykit-nightly", because: "both install gty"

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
    notice = ""
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
    assert_match "gty 0.8.2 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end
