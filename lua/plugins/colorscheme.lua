return {
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    styles = {
      -- 背景色を透過に設定した場合、サイドバーなどのUIも透過されます。
      -- これらを不透明にしたい場合は、以下のように設定します。
      sidebars = "dark",
      floats = "dark",
    },
  },
}
