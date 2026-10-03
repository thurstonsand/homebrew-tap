# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-37157695987-50685aa"
  sha256 "779b902aa50296da2a5c12448476cfbe8561500c5a38aaee05e9a5bc334b2f3d"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-37157695987-50685aa/MiniWhisper_0.2.1-nightly-37157695987-50685aa_darwin_arm64.zip"
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
