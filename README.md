# catgoose neovim

<a href="https://dotfyle.com/catgoose/nvim"><img src="https://dotfyle.com/catgoose/nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/catgoose/nvim"><img src="https://dotfyle.com/catgoose/nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/catgoose/nvim"><img src="https://dotfyle.com/catgoose/nvim/badges/plugin-manager?style=flat" /></a>

Neovim config for Go, Typescript, Lua plugin development, always WIP

<!--toc:start-->

- [catgoose neovim](#catgoose-neovim)
  - [About](#about)
  - [Screenshot](#screenshot)
    - [Startup Time](#startup-time)
    - [Heirline](#heirline)
    - [Wilder](#wilder)
      - [Search](#search)
      - [Command](#command)
      - [Results in quickfix](#results-in-quickfix)
    - [Hover handler](#hover-handler)
  - [Extra](#extra)
    - [Neovim](#neovim)
    - [Tmux](#tmux)
  - [Todo](#todo)
  <!--toc:end-->

## About

![image](https://github.com/catgoose/nvim/blob/d28f5304602c0f45fe994b0b61db292cf131383d/dashboard.png)

Welcome to my neovim config that I use for lua, Angular, NestJS, Go/HTMX

## Screenshot

### Startup Time

![image](https://github.com/catgoose/nvim/blob/89fcfad764e622ca9798fee4d5db5c95b2ef38fa/startuptime.png)

### Heirline

![image](https://github.com/catgoose/nvim/blob/c3d07e870b87590d0acaa89be8f3a17fcf30ec9e/neovim1.png)

### Wilder

#### Search

![image](https://github.com/catgoose/nvim/blob/c3d07e870b87590d0acaa89be8f3a17fcf30ec9e/neovim2.png)

#### Command

![image](https://github.com/catgoose/nvim/blob/c3d07e870b87590d0acaa89be8f3a17fcf30ec9e/neovim3.png)

#### Results in quickfix

![image](https://github.com/catgoose/nvim/blob/c3d07e870b87590d0acaa89be8f3a17fcf30ec9e/neovim5.png)

### Hover handler

- Uses `K` to contextually display hover

![image](https://github.com/catgoose/nvim/blob/f79299f39ea9320f61862c0f2199b4acef998acf/image.png)

## Extra

### Neovim

My other neovim projects

- [do-the-needful.nvim](https://github.com/catgoose/do-the-needful.nvim)
- [telescope-helpgrep.nvim](https://github.com/catgoose/telescope-helpgrep.nvim)
- [templ-goto-definition](https://github.com/catgoose/templ-goto-definition.nvim)

### Tmux

Tmux theme:

[kanagawa-tmux](https://github.com/catgoose/kanagawa-tmux)

## Clojure

Baseline Clojure setup combines `clojure-lsp` (diagnostics, navigation,
completion, formatting via Conform's LSP fallback) with `Olical/conjure`
(REPL-driven evaluation over nREPL). Treesitter parser `clojure` is enabled
and `julienvincent/nvim-paredit` provides structural editing. `cmp-conjure`
adds REPL-aware completion to `nvim-cmp` for Lisp filetypes.

### Machine prerequisites

- Java (JDK 11+).
- [Clojure CLI](https://clojure.org/guides/install_clojure) (`clojure` /
  `clj`).
- `clojure-lsp` is installed automatically through Mason (`:Mason` →
  `clojure-lsp`).

### First-run notes

- LSP server name is `clojure_lsp`. Verify with `:checkhealth vim.lsp`.
- `K` still routes through the repo `HoverHandler`; `L` opens direct LSP
  hover. Conjure's `K` doc-word mapping is disabled to preserve this.
- Start an nREPL inside a project (`clj -M:repl/server`, `lein repl`,
  `bb nrepl-server`, or `shadow-cljs server`) and Conjure auto-connects via
  the project's `.nrepl-port`. Manual connect: `:ConjureConnect`.
- Useful commands: `:ConjureSchool` (interactive tutorial), `:ConjureLogVSplit`
  (open eval log), `<localleader>ee` (eval current form),
  `<localleader>er` (eval root form). `<localleader>` is `<Space>`.

### Optional follow-ups

- Parinfer-style editing: try [`parpar.nvim`](https://github.com/dundalek/parpar.nvim)
  or [`gpanders/nvim-parinfer`](https://github.com/gpanders/nvim-parinfer)
  in place of `nvim-paredit` if you prefer indentation-driven structure.
- Per-project `.lsp/config.edn`, `.cljfmt.edn`, `.clj-kondo/config.edn`
  belong in actual Clojure projects, not in dotfiles.
