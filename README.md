# catgoose neovim

<a href="https://dotfyle.com/catgoose/nvim"><img src="https://dotfyle.com/catgoose/nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/catgoose/nvim"><img src="https://dotfyle.com/catgoose/nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/catgoose/nvim"><img src="https://dotfyle.com/catgoose/nvim/badges/plugin-manager?style=flat" /></a>

Neovim config for Typescript, Lua plugin development, always WIP

<!--toc:start-->

- [catgoose neovim](#catgoose-neovim)
  - [About](#about)
  - [Current WIP](#current-wip)
  - [Screenshot](#screenshot)
    - [Heirline](#heirline)
    - [Wilder](#wilder)
      - [Search](#search)
      - [Command](#command)
    - [Help grep](#help-grep)
      - [ui.prompt](#uiprompt)
      - [Results in quickfix](#results-in-quickfix)
    - [Hover handler](#hover-handler)
  - [Todo](#todo)
  <!--toc:end-->

## About

I have curated this neovim config for about two years now. I use it for
Angular, NestJS, and now Vue.

If you have any questions about how something works, don't hesitate to open
an issue or send me a message!

## Screenshot

### Heirline

![image](https://github.com/catgoose/nvim/blob/c3d07e870b87590d0acaa89be8f3a17fcf30ec9e/neovim1.png)

### Wilder

#### Search

![image](https://github.com/catgoose/nvim/blob/c3d07e870b87590d0acaa89be8f3a17fcf30ec9e/neovim2.png)

#### Command

![image](https://github.com/catgoose/nvim/blob/c3d07e870b87590d0acaa89be8f3a17fcf30ec9e/neovim3.png)

### Help grep

#### ui.prompt

![image](https://github.com/catgoose/nvim/blob/c3d07e870b87590d0acaa89be8f3a17fcf30ec9e/neovim4.png)

#### Results in quickfix

![image](https://github.com/catgoose/nvim/blob/c3d07e870b87590d0acaa89be8f3a17fcf30ec9e/neovim5.png)

### Hover handler

- Uses `K` to display different hover implementations depending on the content

![image](https://github.com/catgoose/nvim/blob/6159ac96f7a725a79d5ee5767c3d3ec8d1ece0ed/neovim6.png)

```lua
M.hover_handler = function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if winid then
    return
  end
  local ft = bo.filetype
  if tbl_contains({ "vim", "help" }, ft) then
    cmd("silent! h " .. fn.expand("<cword>"))
  elseif M.treesitter_is_css_class_under_cursor() then
    cmd("TWValues")
  elseif tbl_contains({ "man" }, ft) then
    cmd("silent! Man " .. fn.expand("<cword>"))
  elseif is_diag_for_cur_pos() then
    vim.diagnostic.open_float()
  else
    vim.lsp.buf.hover()
  end
end
```

## Extra

### Neovim

My other neovim projects

- [do-the-needful.nvim](https://github.com/catgoose/do-the-needful.nvim)
- [telescope-helpgrep.nvim](https://github.com/catgoose/telescope-helpgrep.nvim)
- [vue-goto-definition](https://github.com/catgoose/vue-goto-definition.nvim)

### Tmux

Tmux theme:

[kanagawa-tmux](https://github.com/catgoose/kanagawa-tmux)
