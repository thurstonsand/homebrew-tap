# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-40331089727-37642c1"
  sha256 "adda54a09faa48b049e68cb23f642764e1823ee044a10affcfb28ae8426c77e6"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-40331089727-37642c1/MiniWhisper_0.2.1-nightly-40331089727-37642c1_darwin_arm64.zip"
  name "MiniWhisper Nightly"
  desc "Local speech-to-text dictation"
  homepage "https://github.com/thurstonsand/mini-whisper"

  livecheck do
    skip "Nightly builds are published from main."
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "MiniWhisper Nightly.app"

  # This also removes the downloaded speech model.
  zap trash: "~/Library/Application Support/MiniWhisper Nightly"
end
