class Blogin < Formula
  desc "Fast static blog generator with no runtime dependencies"
  homepage "https://github.com/gdonald/Blogin"
  version "0.9.6"
  license "MIT"

  on_macos do
    # One binary covers Apple silicon and Intel.
    url "https://github.com/gdonald/Blogin/releases/download/v0.9.6/blogin-macos-universal"
    sha256 "0b1b9bdd1987e5859f47707e9e6ade37ca5901d5f40035c90d28b4ba9461d885"
  end

  on_linux do
    on_intel do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.6/blogin-linux-x86_64"
      sha256 "96ba52605e92f117ef09a40b99696082cf46366d8e9e8c961dc107c1d84021f9"
    end

    on_arm do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.6/blogin-linux-arm64"
      sha256 "c5ce44ea46c68ce3cdf1ad128fbeea9f766487d5a021a3adf8336e9649bd74ff"
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
