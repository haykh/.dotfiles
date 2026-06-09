# Dev shells

Pinned, per-project development environments exposed as flake `devShells` and
activated on demand with [direnv](https://direnv.net) + `nix-direnv`.

## Why this setup

- **Pinned to the flake, not the system.** Each shell is built from the
  `nixpkgs` locked in `flake.lock`, so a `nixos-rebuild` (or `nixupd`) never
  silently changes a shell's packages. They only change when *you* update them.
- **Offline & instant.** `nix-direnv` caches the evaluated shell and pins it as
  a GC root, so re-entering a project needs no network and no rebuild — even
  after `nix-collect-garbage`.
- **One definition, two entry points.** The same `shells/*.nix` files back both
  the old interactive `nix-shell` flow and the new `nix develop` / direnv flow.

## Available shells

Defined in `flake.nix` under `devShells.x86_64-linux`:

| Name        | Contents                                   |
| ----------- | ------------------------------------------ |
| `default`   | bare dev shell (no language packs)         |
| `go`        | go toolchain + gopls + hugo + wails        |
| `cpp`       | clang/cmake toolchain                      |
| `gcc`       | gcc13 + cmake toolchain                    |
| `gl`        | OpenGL / glsl tooling                      |
| `python`    | python + LSP/formatters                    |
| `cuda`      | CUDA toolkit                               |
| `rocm`      | ROCm toolchain                             |
| `asm`       | nasm + asm-lsp                             |
| `rust`      | rustc + cargo + rust-analyzer + clippy + rustfmt |
| `py-cpp`    | python + cpp                               |
| `web`       | web (node, LSPs) + gl + go                 |
| `cuda-cpp`  | cuda + cpp                                 |
| `rocm-cpp`  | rocm + cpp                                 |

The individual language packs live in `shells/envs.nix`; `dev.nix` composes any
comma-separated combination of them.

## Usage

### Per project (recommended)

From inside a project directory:

```sh
nixenv rust      # pins the `rust` shell to ./.envrc and runs `direnv allow`
nixenv           # same, but the `default` shell
nixenv cuda-cpp  # any name from the table above
```

`nixenv` is a zsh helper (defined in `cfg.nix`) that just writes a `.envrc`:

```sh
use flake ~/.dotfiles/nixos#py
```

From then on the environment loads automatically whenever you `cd` into the
directory, and unloads when you leave. The first activation builds the closure
(needs network); every activation after that is cached, offline, and instant.

Commit `.envrc` with the project so the environment is reproducible for anyone
who checks it out.

### Ad-hoc (no direnv)

```sh
nix develop ~/.dotfiles/nixos#py
```

This still drops you into an interactive shell (it `exec`s `$SHELL`), exactly
like the old `nix-shell` flow.

## Updating shells

Shells are pinned to `flake.lock`, so they only move when you update the flake:

```sh
nixupd                 # nix flake update (updates nixpkgs for everything)
direnv reload          # rebuild the shell for the current project
```

To force a rebuild in a project without changing the lock, `direnv reload`.

## One-time setup

direnv + nix-direnv are enabled via home-manager (`home/modules/direnv.nix`,
toggled by `direnv = true` in `hosts/fw16/config.nix`). Apply once with:

```sh
nixbuild
```

After the rebuild, restart your shell (or `exec zsh`) so the direnv hook is
loaded.

## Adding a new shell

1. Add the package set to `shells/envs.nix` (a new `env` branch), or reuse
   existing ones.
2. Add an entry to `devShells.x86_64-linux` in `flake.nix`, e.g.
   `zig = mkDev "zig";` or a standalone `import ./shells/myshell.nix { ... }`.
3. Use it with `nixenv zig`.
