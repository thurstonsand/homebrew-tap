# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-32057957254-2638a5b"
  sha256 "4456d51929428cf277c95b226071f3190ba50f66ce70428dad92b66c88cb7145"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-32057957254-2638a5b/MiniWhisper_0.2.1-nightly-32057957254-2638a5b_darwin_arm64.zip"
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
