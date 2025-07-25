
# Dot Files and Includes

## Usage

Sync new files with vendir

```
apiVersion: vendir.k14s.io/v1alpha1
kind: Config
directories:
  - path: .includes
    contents:
      - path: compose
        git:
          url: git@github.com:cznewt/dotfiles.git
          ref: main
          depth: 1
        includePaths:
          - git-project/.includes/compose/*
        newRootPath: git-project/.includes/compose
      - path: just
        git:
          url: git@github.com:cznewt/dotfiles.git
          ref: main
          depth: 1
        includePaths:
          - git-project/.includes/just/*
        newRootPath: git-project/.includes/just
```
