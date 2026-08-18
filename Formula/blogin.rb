class Blogin < Formula
  desc "Fast static blog generator with no runtime dependencies"
  homepage "https://github.com/gdonald/Blogin"
  version "0.9.2"
  license "MIT"

  on_macos do
    # One binary covers Apple silicon and Intel.
    url "https://github.com/gdonald/Blogin/releases/download/v0.9.2/blogin-macos-universal"
    sha256 "50b490bbbce563c4467717f7a0795336039b3a2be7a6f1e551c1665ffdf1feab"
  end

  on_linux do
    on_intel do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.2/blogin-linux-x86_64"
      sha256 "5fa176cc0f583454c27286d148a27ae5b309c59eb9337db8d98e81dfc9a0409b"
    end

    on_arm do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.2/blogin-linux-arm64"
      sha256 "a33b1880c17ea6a2f1d1c1c169cba097d78214808b8fc155692507736a1dad49"
    end
  end

  # Building from source needs a compiler and CMake and nothing else, which is
  # what having no third-party dependencies buys.
  head do
    url "https://github.com/gdonald/Blogin.git", branch: "main"

    depends_on "cmake" => :build
    depends_on "ninja" => :build
  end

  def install
    if build.head?
      system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
             "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    else
      bin.install Dir["blogin-*"].first => "blogin"
    end
  end

  test do
    system bin/"blogin", "init", testpath/"site"
    system bin/"blogin", "build", "--src", testpath/"site/content"

    assert_path_exists testpath/"site/public/index.html"
  end
end
