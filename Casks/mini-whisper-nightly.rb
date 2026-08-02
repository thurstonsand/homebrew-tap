# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.1.0-dev-30735872456-a044d99"
  sha256 "5b13280926348bb934b2d6c5b18b20c2d508f74fff076495b8a947f4e7c619da"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.1.0-dev-30735872456-a044d99/MiniWhisper_0.1.0-dev-30735872456-a044d99_darwin_arm64.zip"
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
