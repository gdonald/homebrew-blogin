class Blogin < Formula
  desc "Fast static blog generator with no runtime dependencies"
  homepage "https://github.com/gdonald/Blogin"
  version "0.9.5"
  license "MIT"

  on_macos do
    # One binary covers Apple silicon and Intel.
    url "https://github.com/gdonald/Blogin/releases/download/v0.9.5/blogin-macos-universal"
    sha256 "c5b2aaab3865c73dcef20a368f82f8d82f640bc870a5257dfaa395bf4f8ab97e"
  end

  on_linux do
    on_intel do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.5/blogin-linux-x86_64"
      sha256 "08194e7146d6e76bc21fa0823099d732ddc0d11ffbee1f17e531dc393f9a6109"
    end

    on_arm do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.5/blogin-linux-arm64"
      sha256 "597506500f6d47ca116b8ca9c9b82390b6765a4d73205ba78a454933f41b4345"
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
