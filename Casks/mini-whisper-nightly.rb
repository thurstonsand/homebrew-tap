# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.1.1-dev-30754980422-cdc4606"
  sha256 "1c916b4f31232a7f6f50491286ae84dd36c405b42c39b7871e7ac7231572dffb"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.1.1-dev-30754980422-cdc4606/MiniWhisper_0.1.1-dev-30754980422-cdc4606_darwin_arm64.zip"
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
