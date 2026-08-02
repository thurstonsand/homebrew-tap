# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.1.1-dev-30757689628-9f47729"
  sha256 "81094c4d08e074bce51228e6bdd91b4e0c46268e314a625d2acd9434dc16dea5"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.1.1-dev-30757689628-9f47729/MiniWhisper_0.1.1-dev-30757689628-9f47729_darwin_arm64.zip"
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
