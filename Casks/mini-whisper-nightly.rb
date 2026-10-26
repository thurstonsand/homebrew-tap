# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-40270306693-03bc3e5"
  sha256 "65ccf25f6193eb53ef9b51f15d4a0173f9756e33c82602c3e090355812577b86"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-40270306693-03bc3e5/MiniWhisper_0.2.1-nightly-40270306693-03bc3e5_darwin_arm64.zip"
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
