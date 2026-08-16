# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-31918407229-e52890b"
  sha256 "6ebb68d4f1fe79419f70c45aa19243527960a49a26cb5cb44bec84fcb5ad4497"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-31918407229-e52890b/MiniWhisper_0.2.1-nightly-31918407229-e52890b_darwin_arm64.zip"
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
