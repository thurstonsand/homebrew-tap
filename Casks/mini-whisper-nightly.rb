# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-36651331484-beea3ea"
  sha256 "7dee6ab9500b0e0fffe1e8a2a69735f080cfd95693f46b853198eb3c8ab13bec"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-36651331484-beea3ea/MiniWhisper_0.2.1-nightly-36651331484-beea3ea_darwin_arm64.zip"
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
