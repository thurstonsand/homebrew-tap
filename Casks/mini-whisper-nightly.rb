# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.3.1-nightly-42583170952-6b9870d"
  sha256 "2c21a7ceba7bd1100f168cedafdb0e860f0a4e56bc3a291ea1e356424ebf59f4"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.3.1-nightly-42583170952-6b9870d/MiniWhisper_0.3.1-nightly-42583170952-6b9870d_darwin_arm64.zip"
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
  zap trash: [
    "~/Library/Application Support/MiniWhisper Nightly",
    "~/Library/Caches/com.thurstonsand.MiniWhisper.nightly",
    "~/Library/HTTPStorages/com.thurstonsand.MiniWhisper.nightly",
    "~/Library/Preferences/com.thurstonsand.MiniWhisper.nightly.plist",
  ]
end
