class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.4.0-dev-29559553277-3944d02"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-29559553277-3944d02/ghosttykit_0.4.0-dev-29559553277-3944d02_darwin_arm64.zip"
      sha256 "9f017fbbe44983262eea288d53048e0a8e2661bdbf97a33a51ded8c44d4ec57c"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-29559553277-3944d02/ghosttykit_0.4.0-dev-29559553277-3944d02_darwin_amd64.zip"
      sha256 "4d61229d609035528edb7d2675c2bda814ceeff70dc23fa83e1ffc315c78d0eb"
    end
  end

  conflicts_with "ghosttykit", because: "both install gty and ghosttykitd"

  def install
    bin.install "bin/gty"
    prefix.install "GhosttyKitD.app"
    bin.install_symlink prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd" => "ghosttykitd"
  end

  service do
    run [opt_prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd"]
    keep_alive true
    working_dir var
    log_path var/"log/ghosttykitd.log"
    error_log_path var/"log/ghosttykitd.log"
  end

  def caveats
    <<~EOS
      This formula tracks nightly builds from GhosttyKit main and may break.

      Start Ghostty, then start the GhosttyKit daemon:

        brew services start #{full_name}

      On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
      Grant access, then verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty 0.4.0-dev-29559553277-3944d02 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.4.0-dev-29559553277-3944d02", shell_output("#{bin}/ghosttykitd --version")
  end
end
