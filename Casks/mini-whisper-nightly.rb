# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.0.0-dev-30734427024-6e24028"
  sha256 "eb71fd9f6f32e8a87932ac5d4193681e95842c080e674b2aff053cae50143434"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.0.0-dev-30734427024-6e24028/MiniWhisper_0.0.0-dev-30734427024-6e24028_darwin_arm64.zip"
  name "MiniWhisper"
  desc "Local speech-to-text dictation"
  homepage "https://github.com/thurstonsand/mini-whisper"

  livecheck do
    skip "Nightly builds are published from main."
  end

  conflicts_with cask: "mini-whisper"
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "MiniWhisper.app"

  # This also removes the downloaded speech model.
  zap trash: "~/Library/Application Support/MiniWhisper"
end
