packer {
  required_plugins {
    tart = {
      version = ">= 1.12.0"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

source "tart-cli" "tart" {
  vm_base_name = "ghcr.io/cirruslabs/macos-sonoma-xcode:15.3"
  vm_name      = "sdk-build-macos"
  cpu_count    = 4
  memory_gb    = 8
  disk_size_gb = 200
  headless     = true
  ssh_password = "admin"
  ssh_username = "admin"
  ssh_timeout  = "120s"
}

build {
  sources = ["source.tart-cli.tart"]

  # Update Homebrew packages
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew --version",
      "brew update",
      "brew upgrade",
    ]
  }

  # Install bash
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install bash",
    ]
  }

  # Install base packages (equivalent to GitHub-hosted runners)
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install cmake jq git-lfs gnu-tar gnupg wget xz",
    ]
  }

  # Install additional packages for SDK build
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install awscli autoconf automake binutils boost ccache coreutils",
      "brew install dos2unix dtc gawk gnu-sed gperf help2man meson ncurses",
      "brew install ninja pkg-config python@3.8 texinfo",
    ]
  }
}
