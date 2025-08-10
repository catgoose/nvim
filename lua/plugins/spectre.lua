local m = require("util").lazy_map

local opts = {
  is_insert_mode = false,
}

return {
  "nvim-pack/nvim-spectre",
  opts = opts,
  cmd = "Spectre",
  keys = {
    m("<leader>sr", [[SpectreOpen]]),
    m("<leader>sw", [[SpectreOpenWord]]),
    m("<leader>sc", [[SpectreOpenCwd]]),
  },
}
