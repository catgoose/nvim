local config = function()
  local heirline = require("heirline")
  local conditions = require("heirline.conditions")
  local u = require("heirline.utils")
  local kanagawa = require("kanagawa.colors").setup({ theme = "wave" })
  local colors = kanagawa.palette
  heirline.load_colors(colors)
  local fn, api, bo = vim.fn, vim.api, vim.bo

  local winbar_inactive = {
    buftype = {
      "nofile",
      "terminal",
    },
    filetype = {
      "oil",
      "blame",
      "help",
    },
  }
  local ruler_inactive = {
    buftype = {
      "nofile",
      "terminal",
    },
    filetype = {
      "neotest-summary",
      "help",
    },
  }
  local cmdtype_inactive = {
    ":",
    "/",
    "?",
  }

  local Align = { provider = "%=" }
  local Space = { provider = " " }
  local LeftSep = { provider = "" }
  local RightSep = { provider = "" }

  local FileNameBlock = {
    condition = function()
      return #api.nvim_buf_get_name(0) > 0
    end,
    init = function(self)
      self.filename = api.nvim_buf_get_name(0)
      self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
        self.filename,
        fn.fnamemodify(self.filename, ":e"),
        { default = true }
      )
    end,
    hl = {
      bg = colors.sumiInk5,
    },
  }
  local FileIcon = {
    provider = function(self)
      return #self.filename == "" and self.filename or self.icon and (self.icon .. " ")
    end,
    hl = function(self)
      return {
        fg = self.icon_color,
      }
    end,
  }
  local FileName = {
    provider = function(self)
      local filename = fn.fnamemodify(self.filename, ":.")
      if filename == "" then
        return ""
      end
      if not conditions.width_percent_below(#filename, 0.25) then
        filename = fn.pathshorten(filename, 3)
      end
      return filename
    end,
    hl = { fg = colors.oldWhite, bold = true },
  }
  local FileFlags = {
    {
      provider = function()
        if bo.modified then
          return "[+] "
        end
      end,
      hl = { fg = colors.oldWhite, bold = true, italic = true },
    },
    {
      provider = function()
        if not bo.modifiable or bo.readonly then
          return " "
        end
      end,
      hl = { fg = colors.roninYellow, bold = true, italic = true },
    },
  }
  local FileNameModifer = {
    hl = function()
      if bo.modified then
        return { italic = true, force = true }
      end
    end,
  }
  local ActiveSep = {
    hl = function()
      if conditions.is_active() then
        return { fg = colors.sumiInk3 }
      else
        return { fg = colors.sumiInk1 }
      end
    end,
  }
  FileNameBlock = u.insert(
    FileNameBlock,
    u.insert(ActiveSep, LeftSep),
    Space,
    unpack(FileFlags),
    u.insert(FileNameModifer, FileName, Space, FileIcon),
    { provider = "%<" }
  )

  local DiagnosticsBlock = {
    condition = conditions.has_diagnostics,
    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
  }
  local Diagnostics = {
    {
      hl = function()
        if conditions.is_active() then
          return {
            bg = colors.sumiInk3,
          }
        else
          return {
            bg = colors.sumiInk1,
          }
        end
      end,
      Space,
    },
    static = {
      error_icon = fn.sign_getdefined("DiagnosticSignError")[1].text,
      warn_icon = fn.sign_getdefined("DiagnosticSignWarn")[1].text,
      info_icon = fn.sign_getdefined("DiagnosticSignInfo")[1].text,
      hint_icon = fn.sign_getdefined("DiagnosticSignHint")[1].text,
    },
    update = { "DiagnosticChanged", "BufEnter", "WinEnter" },
    {
      RightSep,
      hl = function()
        if conditions.is_active() then
          return {
            fg = colors.sumiInk5,
            bg = colors.sumiInk3,
          }
        else
          return {
            fg = colors.sumiInk5,
            bg = colors.sumiInk1,
          }
        end
      end,
    },
    Space,
    {
      provider = function(self)
        return self.errors > 0 and (self.error_icon .. self.errors .. " ") or ""
      end,
      hl = { fg = colors.samuraiRed },
    },
    {
      provider = function(self)
        return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
      end,
      hl = { fg = colors.roninYellow },
    },
    {
      provider = function(self)
        return self.info > 0 and (self.info_icon .. self.info .. " ")
      end,
      hl = { fg = colors.waveAqua1 },
    },
    {
      provider = function(self)
        return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
      end,
      hl = { fg = colors.dragonBlue },
    },
    hl = { bg = colors.sumiInk5 },
    {
      {
        condition = conditions.is_active,
        RightSep,
      },
      condition = conditions.has_diagnostics,
      hl = function()
        if conditions.is_active() then
          return {
            fg = colors.sumiInk3,
            bg = colors.sumiInk5,
          }
        else
          return {
            fg = colors.sumiInk1,
            bg = colors.sumiInk5,
          }
        end
      end,
    },
  }
  DiagnosticsBlock = u.insert(DiagnosticsBlock, Diagnostics)

  local GitBlock = {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0
        or self.status_dict.removed ~= 0
        or self.status_dict.changed ~= 0
    end,
  }
  local Git = {
    condition = function(self)
      return self.has_changes
    end,
    {
      provider = function(self)
        return "  " .. self.status_dict.head .. " "
      end,
      hl = { fg = colors.springViolet1, bold = true, italic = true },
    },
    {
      provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ("+" .. count .. " ")
      end,
      hl = { fg = colors.autumnGreen, bold = true },
    },
    {
      provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ("-" .. count .. " ")
      end,
      hl = { fg = colors.autumnRed, bold = true },
    },
    {
      provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and ("~" .. count .. " ")
      end,
      hl = { fg = colors.autumnYellow, bold = true },
    },
    {
      LeftSep,
      hl = function()
        if conditions.is_active() then
          return {
            bg = colors.sumiInk3,
            fg = colors.sumiInk5,
          }
        else
          return {
            fg = colors.sumiInk5,
            bg = colors.sumiInk1,
          }
        end
      end,
    },
    hl = { bg = colors.sumiInk5 },
  }
  GitBlock = u.insert(GitBlock, Git)

  local MacroRecordingBlock = {
    condition = conditions.is_active,
    init = function(self)
      self.reg_recording = fn.reg_recording()
      self.status_dict = vim.b.gitsigns_status_dict or { added = 0, removed = 0, changed = 0 }
      self.has_changes = self.status_dict.added ~= 0
        or self.status_dict.removed ~= 0
        or self.status_dict.changed ~= 0
    end,
  }
  local MacroRecording = {
    condition = function(self)
      return self.reg_recording ~= ""
    end,
    {
      condition = function(self)
        return self.has_changes
      end,
      LeftSep,
    },
    {
      provider = "   ",
      hl = { fg = colors.autumnRed },
    },
    {
      provider = function(self)
        return "@" .. self.reg_recording .. " "
      end,
      hl = { italic = false, bold = true },
    },
    {
      LeftSep,
      hl = { bg = colors.sumiInk3, fg = colors.autumnYellow },
    },
    hl = { bg = colors.autumnYellow, fg = colors.sumiInk3 },
    update = { "RecordingEnter", "RecordingLeave" },
  }
  MacroRecordingBlock = u.insert(MacroRecordingBlock, MacroRecording)

  local RulerBlock = {
    condition = function()
      return conditions.is_active() and not conditions.buffer_matches(ruler_inactive)
    end,
  }
  local Ruler = {
    Space,
    {
      provider = "%(%l/%3L%):%c %q",
      hl = {
        fg = colors.springViolet1,
      },
    },
  }
  RulerBlock = u.insert(RulerBlock, Ruler)

  local function get_qf()
    return vim.fn.getqflist({ size = 0, title = 0, nr = 0, items = 0 })
  end
  local QuickFixBlock = {
    init = function(self)
      self.quickfix = get_qf()
      self.filename = vim.fn.expand("%:.")
    end,
    condition = function()
      local quickfix = get_qf()
      return conditions.is_active() and quickfix.title ~= "" and #quickfix.items > 0
    end,
    hl = { fg = colors.springViolet1, italic = true },
  }
  local QuickFix = {
    Space,
    {
      provider = function(self)
        local idx = 1
        local found = false
        for i, item in ipairs(self.quickfix.items) do
          if item.text == self.filename then
            idx = i
            found = true
            break
          end
        end
        if not found then
          return
        end
        return string.format(
          "%s %s: (%s/%s)",
          self.quickfix.nr,
          self.quickfix.title,
          idx,
          self.quickfix.size
        )
      end,
    },
  }
  QuickFixBlock = u.insert(QuickFixBlock, QuickFix)

  local StatusLines = {
    condition = function()
      for _, c in ipairs(cmdtype_inactive) do
        if vim.fn.getcmdtype() == c then
          return false
        end
      end
      return true
    end,
    GitBlock,
    MacroRecordingBlock,
    Align,
    QuickFixBlock,
    DiagnosticsBlock,
    RulerBlock,
    hl = function()
      if conditions.is_active() then
        return { bg = colors.sumiInk3 }
      else
        return { bg = colors.sumiInk1 }
      end
    end,
  }

  local Winbars = {
    condition = function()
      local empty_buffer = function()
        return bo.ft == "" and bo.buftype == ""
      end
      return not empty_buffer()
    end,
    Align,
    FileNameBlock,
  }

  heirline.setup({
    statusline = StatusLines,
    winbar = Winbars,
    opts = {
      disable_winbar_cb = function(args)
        return conditions.buffer_matches(winbar_inactive, args.buf)
      end,
    },
  })
end

return {
  "rebelot/heirline.nvim",
  config = config,
  event = "BufReadPre",
  dependencies = "nvim-tree/nvim-web-devicons",
}
