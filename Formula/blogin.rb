class Blogin < Formula
  desc "Fast static blog generator with no runtime dependencies"
  homepage "https://github.com/gdonald/Blogin"
  version "0.9.3"
  license "MIT"

  on_macos do
    # One binary covers Apple silicon and Intel.
    url "https://github.com/gdonald/Blogin/releases/download/v0.9.3/blogin-macos-universal"
    sha256 "28ad87e8b521ac86e58902f43af49b88bfb2019f96fe2b25ca415d7f8e1465a9"
  end

  on_linux do
    on_intel do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.3/blogin-linux-x86_64"
      sha256 "7e7987093b69b2153cfe0bc655888b76d8202003e34aa475fe7f5ad014515f81"
    end

    on_arm do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.3/blogin-linux-arm64"
      sha256 "08129da33b32d4606557e9fb532a80a843c3f13b34e94e4d8f64225037088c86"
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
