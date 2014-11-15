return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 10,
  height = 10,
  tilewidth = 32,
  tileheight = 32,
  properties = {},
  tilesets = {
    {
      name = "wpc#blu#1",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "images/minion/frost/walk.png",
      imagewidth = 192,
      imageheight = 64,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        7, 7, 7, 7, 8, 7, 8, 7, 9, 9,
        9, 7, 8, 8, 7, 8, 7, 8, 8, 9,
        7, 5, 5, 5, 5, 5, 5, 6, 9, 8,
        7, 6, 6, 6, 6, 7, 7, 7, 9, 9,
        9, 7, 7, 8, 8, 8, 8, 8, 9, 8,
        7, 9, 9, 9, 9, 9, 9, 9, 9, 9,
        8, 10, 10, 10, 10, 10, 10, 10, 8, 9,
        7, 9, 9, 9, 7, 7, 9, 9, 9, 7,
        9, 9, 9, 9, 9, 9, 9, 7, 7, 9,
        9, 9, 8, 7, 7, 7, 7, 8, 8, 9
      }
    }
  }
}
