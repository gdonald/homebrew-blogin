class Blogin < Formula
  desc "Fast static blog generator with no runtime dependencies"
  homepage "https://github.com/gdonald/Blogin"
  version "0.9.0"
  license "MIT"

  on_macos do
    # One binary covers Apple silicon and Intel.
    url "https://github.com/gdonald/Blogin/releases/download/v0.9.0/blogin-macos-universal"
    sha256 "0b70181f6da136a23985a862360738fd0984d8697d7fbaab6fb699adbcb18c1e"
  end

  on_linux do
    on_intel do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.0/blogin-linux-x86_64"
      sha256 "62d97dc18daa4d0aafbc3c3178a82c187a84c628d9fc7dc9839354dfe89ae415"
    end

    on_arm do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.0/blogin-linux-arm64"
      sha256 "d074feee8101092dba2e3695c4e8be0211e79432da1d7f69ac239e669c2a1c12"
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
