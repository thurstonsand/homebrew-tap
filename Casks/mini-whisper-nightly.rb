# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-32393076217-a12fea4"
  sha256 "4b68e2679c4417f5ec487ebb131a293e0b8c4c60efcb5087eeb894b9a3fc5a88"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-32393076217-a12fea4/MiniWhisper_0.2.1-nightly-32393076217-a12fea4_darwin_arm64.zip"
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
