class Blogin < Formula
  desc "Fast static blog generator with no runtime dependencies"
  homepage "https://github.com/gdonald/Blogin"
  version "0.9.1"
  license "MIT"

  on_macos do
    # One binary covers Apple silicon and Intel.
    url "https://github.com/gdonald/Blogin/releases/download/v0.9.1/blogin-macos-universal"
    sha256 "16d256220d21765d950d05956a9485be8c8a93de151a0da9823352ee0be1b3ab"
  end

  on_linux do
    on_intel do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.1/blogin-linux-x86_64"
      sha256 "954d148e1dc964825a1ea6ecc91ad820e9b78788aca7b30d27d3e570ff703765"
    end

    on_arm do
      url "https://github.com/gdonald/Blogin/releases/download/v0.9.1/blogin-linux-arm64"
      sha256 "3458a44fbca27e9d74d34b0536f1a1fc9eb2eef8a21cbd6b6d2b42a27e85d093"
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
