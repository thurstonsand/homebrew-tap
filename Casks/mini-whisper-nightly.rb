# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.3.1-nightly-42666790174-7774b10"
  sha256 "d86f242c29778c1cbd221c0d450e8b31c4ff2da7e1ad3313369496f82547483f"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.3.1-nightly-42666790174-7774b10/MiniWhisper_0.3.1-nightly-42666790174-7774b10_darwin_arm64.zip"
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
