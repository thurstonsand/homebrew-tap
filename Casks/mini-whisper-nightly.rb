# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-40264918618-f9d48aa"
  sha256 "e8dd46adbdb9fb3bc57d8a99d67906f7d5fd60a67ec52dc815d8a82406ce0842"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-40264918618-f9d48aa/MiniWhisper_0.2.1-nightly-40264918618-f9d48aa_darwin_arm64.zip"
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
