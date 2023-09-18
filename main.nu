#!/usr/bin/env nu

let components = [
  # "cosmic-applets"
  # "cosmic-applibrary"
  # "cosmic-bg"
  "cosmic-comp"
  "cosmic-launcher"
  # "cosmic-notifications"
  # "cosmic-osd"
  "cosmic-panel"
  "cosmic-session"
  "cosmic-settings"
  # "cosmic-settings-daemon" # doesn't work for some reason?
  # "cosmic-workspaces-epoch" # ?
  "xdg-desktop-portal-cosmic"
]

def "main reset" [] {
  mkdir versions/
  mkdir versions/epoch
  mkdir versions/tip
  rm -rf _work
  mkdir _work/
}

let root = $env.FILE_PWD;

def "main update" [] {
  for component in $components {
    print -e "-------------------------------------"
    print -e $">> update ($component)"
    do {
      cd $"($env.HOME)/code/cosmic-nix/($component)"
      git remote update
      git rebase
      nix flake lock --recreate-lock-file --commit-lock-file
      git push origin HEAD -f
    }
  }

  print -e "-------------------------------------"
  print -e $">> flake update"
  nix flake lock --recreate-lock-file --commit-lock-file

  print -e "-------------------------------------"
  print -e $">> nix build all"
  nix build .#packages.x86_64-linux.all -L --keep-going
  ls -al ./result/
}

def main [] {
  print -e "usage: [update]"
}
