# catgoose neovim

Neovim config for Typescript, Lua plugin development, always WIP

<!--toc:start-->

- [catgoose neovim](#catgoose-neovim)
  - [About](#about)
  - [Screenshot](#screenshot)
  - [Todo](#todo)
  <!--toc:end-->

## About

This is my neovim config I have curated for about two years now. I use it for
Angular, NestJS, and now Vue.

If you have any questions about how something works, don't hesitate to open
an issue or send me a message!

## Screenshot

![image](https://github.com/catgoose/nvim/blob/e0b13d7dd57fe3a957099928e6658c79c2f7398b/neovim1.png)

## Todo

- [ ] Look at [ultimate-autopairs]
      (<https://github.com/altermo/ultimate-autopair.nvim>).
- [ ] Figure out why in the `cmp` setup, lua lsp is complaining about undefined
      fields. I think it has something to do with `null-ls`.
- [ ] After .10 release `OpenTerminal...` scaling user commands by not be
      necessary.
- [ ] Create `cmp` source for `primeflex`
- Diffview
  - [ ] Create function using vim.input or similar to ask for a commit hash
        to pass into `DiffviewOpen {hash}`
  - [ ] Look at keymaps and hooks
