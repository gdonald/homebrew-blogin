class Blogin < Formula
  desc "Fast static blog generator with no runtime dependencies"
  homepage "https://github.com/gdonald/Blogin"
  version "0.9.4"
  license "MIT"

  on_macos do
    # One binary covers Apple silicon and Intel.
    url "https://github.com/gdonald/Blogin/releases/download/v0.9.4/blogin-macos-universal"
    sha256 "6fc595dcd8ba0c3ecd1f8ccbc4a02c1fdcd19bb3d3cd44c2b03a8f05ce525193"
  end

  on_linux do
    on_intel do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.4/blogin-linux-x86_64"
      sha256 "ee68dbc1a04a9c972e0ebca5c28dca228fa3b4da074f15064a75c6a50989fc4a"
    end

    on_arm do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.4/blogin-linux-arm64"
      sha256 "44c9efb59c8506ecff80e8c76d81cc4807da1564f8f3625c56780fee7895de67"
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
