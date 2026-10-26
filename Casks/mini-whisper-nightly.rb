# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-40338027693-9110550"
  sha256 "be1e41d3a2a8afe80514c2df1d4af60102089a924c78ed8c43c7c26acb5f718b"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-40338027693-9110550/MiniWhisper_0.2.1-nightly-40338027693-9110550_darwin_arm64.zip"
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
