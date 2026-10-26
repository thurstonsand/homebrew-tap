# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-40281748274-78f175f"
  sha256 "5c71e98796eb108405993b762147f517c93ca6a91b9f314e6d1bd961a106ef6a"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-40281748274-78f175f/MiniWhisper_0.2.1-nightly-40281748274-78f175f_darwin_arm64.zip"
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
