# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.3.1-nightly-42845901707-d48f454"
  sha256 "cae23a0461c3651fb8d6376fb00ddca8d0f1b75194510f9544b8d7569b56b6b3"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-#{version}/MiniWhisper_#{version}_darwin_arm64.zip"
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
