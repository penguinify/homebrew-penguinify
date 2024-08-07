class Mystique < Formula
  desc "listen better daemon on macos"
  homepage "https://penguinify.github.io/mystique/"
  url "https://github.com/penguinify/mystique/releases/download/v0.1.0-alpha/arm64.zip"
  sha256 "ce7e5b9ce152476882dbd2d82d981fa00f2417f3d75de78c25d8c9616efa30e9"

  depends_on "python"

  def install
    # Install the original binary with a different name
    bin.install "mystique" => "mystique_original"
    libexec.install "./ml/classify.py"
    libexec.install "./ml/models/model.pkl"

    # Create a wrapper script
    (bin/"mystique").write <<~EOS
      #!/bin/bash
      export PYTHONPATH=#{libexec}:$PYTHONPATH
      exec "#{bin}/mystique_original" "$@"
    EOS

    # Make the wrapper script executable
    chmod 0755, bin/"mystique"
  end

  test do
    system "#{bin}/mystique", "--version"
  end
end
