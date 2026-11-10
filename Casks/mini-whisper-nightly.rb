# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.3.1-nightly-42848740877-5962f5c"
  sha256 "a0830480ab85a40a36b32b5e343ba356eff479470c3fb981b936bbc80aee2390"

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
