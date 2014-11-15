return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 40,
  height = 40,
  tilewidth = 32,
  tileheight = 32,
  properties = {},
  tilesets = {
    {
      name = "terrain",
      firstgid = 1,
      filename = "shared/resources/terrain.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "shared/resources/terrain.png",
      imagewidth = 512,
      imageheight = 928,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {
        {
          name = "Darkdirt",
          tile = 0,
          properties = {}
        },
        {
          name = "Dirt",
          tile = 1,
          properties = {}
        },
        {
          name = "Grass",
          tile = 2,
          properties = {}
        },
        {
          name = "Lavarock",
          tile = 3,
          properties = {}
        },
        {
          name = "Water",
          tile = 4,
          properties = {
            ["block"] = "true"
          }
        },
        {
          name = "Lava",
          tile = 321,
          properties = {
            ["block"] = "true"
          }
        },
        {
          name = "Hole",
          tile = 336,
          properties = {
            ["block"] = "true"
          }
        },
        {
          name = "PlowedSoil",
          tile = 337,
          properties = {}
        },
        {
          name = "Sand",
          tile = 338,
          properties = {}
        }
      },
      tiles = {
        {
          id = 0,
          terrain = { 0, 0, 0, 0 }
        },
        {
          id = 1,
          terrain = { 1, 1, 1, 1 }
        },
        {
          id = 2,
          terrain = { 2, 2, 2, 2 }
        },
        {
          id = 3,
          terrain = { 3, 3, 3, 3 }
        },
        {
          id = 4,
          properties = {
            ["block"] = "true"
          },
          terrain = { 4, 4, 4, 4 }
        },
        {
          id = 5,
          terrain = { 1, 1, 1, 0 }
        },
        {
          id = 6,
          terrain = { 1, 1, 1, 4 }
        },
        {
          id = 7,
          terrain = { 1, 1, 1, 2 }
        },
        {
          id = 8,
          terrain = { 1, 1, 0, 1 }
        },
        {
          id = 9,
          terrain = { 1, 1, 0, 0 }
        },
        {
          id = 10,
          terrain = { 1, 1, 0, 4 }
        },
        {
          id = 11,
          terrain = { 1, 1, 0, 2 }
        },
        {
          id = 12,
          terrain = { 1, 1, 4, 1 }
        },
        {
          id = 13,
          terrain = { 1, 1, 4, 0 }
        },
        {
          id = 14,
          terrain = { 1, 1, 4, 4 }
        },
        {
          id = 15,
          terrain = { 1, 1, 4, 2 }
        },
        {
          id = 16,
          terrain = { 1, 1, 2, 1 }
        },
        {
          id = 17,
          terrain = { 1, 1, 2, 0 }
        },
        {
          id = 18,
          terrain = { 1, 1, 2, 4 }
        },
        {
          id = 19,
          terrain = { 1, 1, 2, 2 }
        },
        {
          id = 20,
          terrain = { 1, 0, 1, 1 }
        },
        {
          id = 21,
          terrain = { 1, 0, 1, 0 }
        },
        {
          id = 22,
          terrain = { 1, 0, 1, 4 }
        },
        {
          id = 23,
          terrain = { 1, 0, 1, 2 }
        },
        {
          id = 24,
          terrain = { 1, 0, 0, 1 }
        },
        {
          id = 25,
          terrain = { 1, 0, 0, 0 }
        },
        {
          id = 26,
          terrain = { 1, 0, 0, 4 }
        },
        {
          id = 27,
          terrain = { 1, 0, 0, 2 }
        },
        {
          id = 28,
          terrain = { 1, 0, 4, 1 }
        },
        {
          id = 29,
          terrain = { 1, 0, 4, 0 }
        },
        {
          id = 30,
          terrain = { 1, 0, 4, 4 }
        },
        {
          id = 31,
          terrain = { 1, 0, 4, 2 }
        },
        {
          id = 32,
          terrain = { 1, 0, 2, 1 }
        },
        {
          id = 33,
          terrain = { 1, 0, 2, 0 }
        },
        {
          id = 34,
          terrain = { 1, 0, 2, 4 }
        },
        {
          id = 35,
          terrain = { 1, 0, 2, 2 }
        },
        {
          id = 36,
          terrain = { 1, 4, 1, 1 }
        },
        {
          id = 37,
          terrain = { 1, 4, 1, 0 }
        },
        {
          id = 38,
          terrain = { 1, 4, 1, 4 }
        },
        {
          id = 39,
          terrain = { 1, 4, 1, 2 }
        },
        {
          id = 40,
          terrain = { 1, 4, 0, 1 }
        },
        {
          id = 41,
          terrain = { 1, 4, 0, 0 }
        },
        {
          id = 42,
          terrain = { 1, 4, 0, 4 }
        },
        {
          id = 43,
          terrain = { 1, 4, 0, 2 }
        },
        {
          id = 44,
          terrain = { 1, 4, 4, 1 }
        },
        {
          id = 45,
          terrain = { 1, 4, 4, 0 }
        },
        {
          id = 46,
          terrain = { 1, 4, 4, 4 }
        },
        {
          id = 47,
          terrain = { 1, 4, 4, 2 }
        },
        {
          id = 48,
          terrain = { 1, 4, 2, 1 }
        },
        {
          id = 49,
          terrain = { 1, 4, 2, 0 }
        },
        {
          id = 50,
          terrain = { 1, 4, 2, 4 }
        },
        {
          id = 51,
          terrain = { 1, 4, 2, 2 }
        },
        {
          id = 52,
          terrain = { 1, 2, 1, 1 }
        },
        {
          id = 53,
          terrain = { 1, 2, 1, 0 }
        },
        {
          id = 54,
          terrain = { 1, 2, 1, 4 }
        },
        {
          id = 55,
          terrain = { 1, 2, 1, 2 }
        },
        {
          id = 56,
          terrain = { 1, 2, 0, 1 }
        },
        {
          id = 57,
          terrain = { 1, 2, 0, 0 }
        },
        {
          id = 58,
          terrain = { 1, 2, 0, 4 }
        },
        {
          id = 59,
          terrain = { 1, 2, 0, 2 }
        },
        {
          id = 60,
          terrain = { 1, 2, 4, 1 }
        },
        {
          id = 61,
          terrain = { 1, 2, 4, 0 }
        },
        {
          id = 62,
          terrain = { 1, 2, 4, 4 }
        },
        {
          id = 63,
          terrain = { 1, 2, 4, 2 }
        },
        {
          id = 64,
          terrain = { 1, 2, 2, 1 }
        },
        {
          id = 65,
          terrain = { 1, 2, 2, 0 }
        },
        {
          id = 66,
          terrain = { 1, 2, 2, 4 }
        },
        {
          id = 67,
          terrain = { 1, 2, 2, 2 }
        },
        {
          id = 68,
          terrain = { 0, 1, 1, 1 }
        },
        {
          id = 69,
          terrain = { 0, 1, 1, 0 }
        },
        {
          id = 70,
          terrain = { 0, 1, 1, 4 }
        },
        {
          id = 71,
          terrain = { 0, 1, 1, 2 }
        },
        {
          id = 72,
          terrain = { 0, 1, 0, 1 }
        },
        {
          id = 73,
          terrain = { 0, 1, 0, 0 }
        },
        {
          id = 74,
          terrain = { 0, 1, 0, 4 }
        },
        {
          id = 75,
          terrain = { 0, 1, 0, 2 }
        },
        {
          id = 76,
          terrain = { 0, 1, 4, 1 }
        },
        {
          id = 77,
          terrain = { 0, 1, 4, 0 }
        },
        {
          id = 78,
          terrain = { 0, 1, 4, 4 }
        },
        {
          id = 79,
          terrain = { 0, 1, 4, 2 }
        },
        {
          id = 80,
          terrain = { 0, 1, 2, 1 }
        },
        {
          id = 81,
          terrain = { 0, 1, 2, 0 }
        },
        {
          id = 82,
          terrain = { 0, 1, 2, 4 }
        },
        {
          id = 83,
          terrain = { 0, 1, 2, 2 }
        },
        {
          id = 84,
          terrain = { 0, 0, 1, 1 }
        },
        {
          id = 85,
          terrain = { 0, 0, 1, 0 }
        },
        {
          id = 86,
          terrain = { 0, 0, 1, 4 }
        },
        {
          id = 87,
          terrain = { 0, 0, 1, 2 }
        },
        {
          id = 88,
          terrain = { 0, 0, 0, 1 }
        },
        {
          id = 89,
          terrain = { 0, 0, 0, 4 }
        },
        {
          id = 90,
          terrain = { 0, 0, 0, 2 }
        },
        {
          id = 91,
          terrain = { 0, 0, 4, 1 }
        },
        {
          id = 92,
          terrain = { 0, 0, 4, 0 }
        },
        {
          id = 93,
          terrain = { 0, 0, 4, 4 }
        },
        {
          id = 94,
          terrain = { 0, 0, 4, 2 }
        },
        {
          id = 95,
          terrain = { 0, 0, 2, 1 }
        },
        {
          id = 96,
          terrain = { 0, 0, 2, 0 }
        },
        {
          id = 97,
          terrain = { 0, 0, 2, 4 }
        },
        {
          id = 98,
          terrain = { 0, 0, 2, 2 }
        },
        {
          id = 99,
          terrain = { 0, 4, 1, 1 }
        },
        {
          id = 100,
          terrain = { 0, 4, 1, 0 }
        },
        {
          id = 101,
          terrain = { 0, 4, 1, 4 }
        },
        {
          id = 102,
          terrain = { 0, 4, 1, 2 }
        },
        {
          id = 103,
          terrain = { 0, 4, 0, 1 }
        },
        {
          id = 104,
          terrain = { 0, 4, 0, 0 }
        },
        {
          id = 105,
          terrain = { 0, 4, 0, 4 }
        },
        {
          id = 106,
          terrain = { 0, 4, 0, 2 }
        },
        {
          id = 107,
          terrain = { 0, 4, 4, 1 }
        },
        {
          id = 108,
          terrain = { 0, 4, 4, 0 }
        },
        {
          id = 109,
          terrain = { 0, 4, 4, 4 }
        },
        {
          id = 110,
          terrain = { 0, 4, 4, 2 }
        },
        {
          id = 111,
          terrain = { 0, 4, 2, 1 }
        },
        {
          id = 112,
          terrain = { 0, 4, 2, 0 }
        },
        {
          id = 113,
          terrain = { 0, 4, 2, 4 }
        },
        {
          id = 114,
          terrain = { 0, 4, 2, 2 }
        },
        {
          id = 115,
          terrain = { 0, 2, 1, 1 }
        },
        {
          id = 116,
          terrain = { 0, 2, 1, 0 }
        },
        {
          id = 117,
          terrain = { 0, 2, 1, 4 }
        },
        {
          id = 118,
          terrain = { 0, 2, 1, 2 }
        },
        {
          id = 119,
          terrain = { 0, 2, 0, 1 }
        },
        {
          id = 120,
          terrain = { 0, 2, 0, 0 }
        },
        {
          id = 121,
          terrain = { 0, 2, 0, 4 }
        },
        {
          id = 122,
          terrain = { 0, 2, 0, 2 }
        },
        {
          id = 123,
          terrain = { 0, 2, 4, 1 }
        },
        {
          id = 124,
          terrain = { 0, 2, 4, 0 }
        },
        {
          id = 125,
          terrain = { 0, 2, 4, 4 }
        },
        {
          id = 126,
          terrain = { 0, 2, 4, 2 }
        },
        {
          id = 127,
          terrain = { 0, 2, 2, 1 }
        },
        {
          id = 128,
          terrain = { 0, 2, 2, 0 }
        },
        {
          id = 129,
          terrain = { 0, 2, 2, 4 }
        },
        {
          id = 130,
          terrain = { 0, 2, 2, 2 }
        },
        {
          id = 131,
          terrain = { 4, 1, 1, 1 }
        },
        {
          id = 132,
          terrain = { 4, 1, 1, 0 }
        },
        {
          id = 133,
          terrain = { 4, 1, 1, 4 }
        },
        {
          id = 134,
          terrain = { 4, 1, 1, 2 }
        },
        {
          id = 135,
          terrain = { 4, 1, 0, 1 }
        },
        {
          id = 136,
          terrain = { 4, 1, 0, 0 }
        },
        {
          id = 137,
          terrain = { 4, 1, 0, 4 }
        },
        {
          id = 138,
          terrain = { 4, 1, 0, 2 }
        },
        {
          id = 139,
          terrain = { 4, 1, 4, 1 }
        },
        {
          id = 140,
          terrain = { 4, 1, 4, 0 }
        },
        {
          id = 141,
          terrain = { 4, 1, 4, 4 }
        },
        {
          id = 142,
          terrain = { 4, 1, 4, 2 }
        },
        {
          id = 143,
          terrain = { 4, 1, 2, 1 }
        },
        {
          id = 144,
          terrain = { 4, 1, 2, 0 }
        },
        {
          id = 145,
          terrain = { 4, 1, 2, 4 }
        },
        {
          id = 146,
          terrain = { 4, 1, 2, 2 }
        },
        {
          id = 147,
          terrain = { 4, 0, 1, 1 }
        },
        {
          id = 148,
          terrain = { 4, 0, 1, 0 }
        },
        {
          id = 149,
          terrain = { 4, 0, 1, 4 }
        },
        {
          id = 150,
          terrain = { 4, 0, 1, 2 }
        },
        {
          id = 151,
          terrain = { 4, 0, 0, 1 }
        },
        {
          id = 152,
          terrain = { 4, 0, 0, 0 }
        },
        {
          id = 153,
          terrain = { 4, 0, 0, 4 }
        },
        {
          id = 154,
          terrain = { 4, 0, 0, 2 }
        },
        {
          id = 155,
          terrain = { 4, 0, 4, 1 }
        },
        {
          id = 156,
          terrain = { 4, 0, 4, 0 }
        },
        {
          id = 157,
          terrain = { 4, 0, 4, 4 }
        },
        {
          id = 158,
          terrain = { 4, 0, 4, 2 }
        },
        {
          id = 159,
          terrain = { 4, 0, 2, 1 }
        },
        {
          id = 160,
          terrain = { 4, 0, 2, 0 }
        },
        {
          id = 161,
          terrain = { 4, 0, 2, 4 }
        },
        {
          id = 162,
          terrain = { 4, 0, 2, 2 }
        },
        {
          id = 163,
          terrain = { 4, 4, 1, 1 }
        },
        {
          id = 164,
          terrain = { 4, 4, 1, 0 }
        },
        {
          id = 165,
          terrain = { 4, 4, 1, 4 }
        },
        {
          id = 166,
          terrain = { 4, 4, 1, 2 }
        },
        {
          id = 167,
          terrain = { 4, 4, 0, 1 }
        },
        {
          id = 168,
          terrain = { 4, 4, 0, 0 }
        },
        {
          id = 169,
          terrain = { 4, 4, 0, 4 }
        },
        {
          id = 170,
          terrain = { 4, 4, 0, 2 }
        },
        {
          id = 171,
          terrain = { 4, 4, 4, 1 }
        },
        {
          id = 172,
          terrain = { 4, 4, 4, 0 }
        },
        {
          id = 173,
          terrain = { 4, 4, 4, 2 }
        },
        {
          id = 174,
          terrain = { 4, 4, 2, 1 }
        },
        {
          id = 175,
          terrain = { 4, 4, 2, 0 }
        },
        {
          id = 176,
          terrain = { 4, 4, 2, 4 }
        },
        {
          id = 177,
          terrain = { 4, 4, 2, 2 }
        },
        {
          id = 178,
          terrain = { 4, 2, 1, 1 }
        },
        {
          id = 179,
          terrain = { 4, 2, 1, 0 }
        },
        {
          id = 180,
          terrain = { 4, 2, 1, 4 }
        },
        {
          id = 181,
          terrain = { 4, 2, 1, 2 }
        },
        {
          id = 182,
          terrain = { 4, 2, 0, 1 }
        },
        {
          id = 183,
          terrain = { 4, 2, 0, 0 }
        },
        {
          id = 184,
          terrain = { 4, 2, 0, 4 }
        },
        {
          id = 185,
          terrain = { 4, 2, 0, 2 }
        },
        {
          id = 186,
          terrain = { 4, 2, 4, 1 }
        },
        {
          id = 187,
          terrain = { 4, 2, 4, 0 }
        },
        {
          id = 188,
          terrain = { 4, 2, 4, 4 }
        },
        {
          id = 189,
          terrain = { 4, 2, 4, 2 }
        },
        {
          id = 190,
          terrain = { 4, 2, 2, 1 }
        },
        {
          id = 191,
          terrain = { 4, 2, 2, 0 }
        },
        {
          id = 192,
          terrain = { 4, 2, 2, 4 }
        },
        {
          id = 193,
          terrain = { 4, 2, 2, 2 }
        },
        {
          id = 194,
          terrain = { 2, 1, 1, 1 }
        },
        {
          id = 195,
          terrain = { 2, 1, 1, 0 }
        },
        {
          id = 196,
          terrain = { 2, 1, 1, 4 }
        },
        {
          id = 197,
          terrain = { 2, 1, 1, 2 }
        },
        {
          id = 198,
          terrain = { 2, 1, 0, 1 }
        },
        {
          id = 199,
          terrain = { 2, 1, 0, 0 }
        },
        {
          id = 200,
          terrain = { 2, 1, 0, 4 }
        },
        {
          id = 201,
          terrain = { 2, 1, 0, 2 }
        },
        {
          id = 202,
          terrain = { 2, 1, 4, 1 }
        },
        {
          id = 203,
          terrain = { 2, 1, 4, 0 }
        },
        {
          id = 204,
          terrain = { 2, 1, 4, 4 }
        },
        {
          id = 205,
          terrain = { 2, 1, 4, 2 }
        },
        {
          id = 206,
          terrain = { 2, 1, 2, 1 }
        },
        {
          id = 207,
          terrain = { 2, 1, 2, 0 }
        },
        {
          id = 208,
          terrain = { 2, 1, 2, 4 }
        },
        {
          id = 209,
          terrain = { 2, 1, 2, 2 }
        },
        {
          id = 210,
          terrain = { 2, 0, 1, 1 }
        },
        {
          id = 211,
          terrain = { 2, 0, 1, 0 }
        },
        {
          id = 212,
          terrain = { 2, 0, 1, 4 }
        },
        {
          id = 213,
          terrain = { 2, 0, 1, 2 }
        },
        {
          id = 214,
          terrain = { 2, 0, 0, 1 }
        },
        {
          id = 215,
          terrain = { 2, 0, 0, 0 }
        },
        {
          id = 216,
          terrain = { 2, 0, 0, 4 }
        },
        {
          id = 217,
          terrain = { 2, 0, 0, 2 }
        },
        {
          id = 218,
          terrain = { 2, 0, 4, 1 }
        },
        {
          id = 219,
          terrain = { 2, 0, 4, 0 }
        },
        {
          id = 220,
          terrain = { 2, 0, 4, 4 }
        },
        {
          id = 221,
          terrain = { 2, 0, 4, 2 }
        },
        {
          id = 222,
          terrain = { 2, 0, 2, 1 }
        },
        {
          id = 223,
          terrain = { 2, 0, 2, 0 }
        },
        {
          id = 224,
          terrain = { 2, 0, 2, 4 }
        },
        {
          id = 225,
          terrain = { 2, 0, 2, 2 }
        },
        {
          id = 226,
          terrain = { 2, 4, 1, 1 }
        },
        {
          id = 227,
          terrain = { 2, 4, 1, 0 }
        },
        {
          id = 228,
          terrain = { 2, 4, 1, 4 }
        },
        {
          id = 229,
          terrain = { 2, 4, 1, 2 }
        },
        {
          id = 230,
          terrain = { 2, 4, 0, 1 }
        },
        {
          id = 231,
          terrain = { 2, 4, 0, 0 }
        },
        {
          id = 232,
          terrain = { 2, 4, 0, 4 }
        },
        {
          id = 233,
          terrain = { 2, 4, 0, 2 }
        },
        {
          id = 234,
          terrain = { 2, 4, 4, 1 }
        },
        {
          id = 235,
          terrain = { 2, 4, 4, 0 }
        },
        {
          id = 236,
          terrain = { 2, 4, 4, 4 }
        },
        {
          id = 237,
          terrain = { 2, 4, 4, 2 }
        },
        {
          id = 238,
          terrain = { 2, 4, 2, 1 }
        },
        {
          id = 239,
          terrain = { 2, 4, 2, 0 }
        },
        {
          id = 240,
          terrain = { 2, 4, 2, 4 }
        },
        {
          id = 241,
          terrain = { 2, 4, 2, 2 }
        },
        {
          id = 242,
          terrain = { 2, 2, 1, 1 }
        },
        {
          id = 243,
          terrain = { 2, 2, 1, 0 }
        },
        {
          id = 244,
          terrain = { 2, 2, 1, 4 }
        },
        {
          id = 245,
          terrain = { 2, 2, 1, 2 }
        },
        {
          id = 246,
          terrain = { 2, 2, 0, 1 }
        },
        {
          id = 247,
          terrain = { 2, 2, 0, 0 }
        },
        {
          id = 248,
          terrain = { 2, 2, 0, 4 }
        },
        {
          id = 249,
          terrain = { 2, 2, 0, 2 }
        },
        {
          id = 250,
          terrain = { 2, 2, 4, 1 }
        },
        {
          id = 251,
          terrain = { 2, 2, 4, 0 }
        },
        {
          id = 252,
          terrain = { 2, 2, 4, 4 }
        },
        {
          id = 253,
          terrain = { 2, 2, 4, 2 }
        },
        {
          id = 254,
          terrain = { 2, 2, 2, 1 }
        },
        {
          id = 255,
          terrain = { 2, 2, 2, 0 }
        },
        {
          id = 256,
          terrain = { 2, 2, 2, 4 }
        },
        {
          id = 257,
          terrain = { 0, 0, 0, 3 }
        },
        {
          id = 258,
          terrain = { 0, 0, 2, 3 }
        },
        {
          id = 259,
          terrain = { 0, 0, 3, 0 }
        },
        {
          id = 260,
          terrain = { 0, 0, 3, 2 }
        },
        {
          id = 261,
          terrain = { 0, 0, 3, 3 }
        },
        {
          id = 262,
          terrain = { 0, 2, 0, 3 }
        },
        {
          id = 263,
          terrain = { 0, 2, 2, 3 }
        },
        {
          id = 264,
          terrain = { 0, 2, 3, 0 }
        },
        {
          id = 265,
          terrain = { 0, 2, 3, 2 }
        },
        {
          id = 266,
          terrain = { 0, 2, 3, 3 }
        },
        {
          id = 267,
          terrain = { 0, 3, 0, 0 }
        },
        {
          id = 268,
          terrain = { 0, 3, 0, 2 }
        },
        {
          id = 269,
          terrain = { 0, 3, 0, 3 }
        },
        {
          id = 270,
          terrain = { 0, 3, 2, 0 }
        },
        {
          id = 271,
          terrain = { 0, 3, 2, 2 }
        },
        {
          id = 272,
          terrain = { 0, 3, 2, 3 }
        },
        {
          id = 273,
          terrain = { 0, 3, 3, 0 }
        },
        {
          id = 274,
          terrain = { 0, 3, 3, 2 }
        },
        {
          id = 275,
          terrain = { 0, 3, 3, 3 }
        },
        {
          id = 276,
          terrain = { 2, 0, 0, 3 }
        },
        {
          id = 277,
          terrain = { 2, 0, 2, 3 }
        },
        {
          id = 278,
          terrain = { 2, 0, 3, 0 }
        },
        {
          id = 279,
          terrain = { 2, 0, 3, 2 }
        },
        {
          id = 280,
          terrain = { 2, 0, 3, 3 }
        },
        {
          id = 281,
          terrain = { 2, 2, 0, 3 }
        },
        {
          id = 282,
          terrain = { 2, 2, 2, 3 }
        },
        {
          id = 283,
          terrain = { 2, 2, 3, 0 }
        },
        {
          id = 284,
          terrain = { 2, 2, 3, 2 }
        },
        {
          id = 285,
          terrain = { 2, 2, 3, 3 }
        },
        {
          id = 286,
          terrain = { 2, 3, 0, 0 }
        },
        {
          id = 287,
          terrain = { 2, 3, 0, 2 }
        },
        {
          id = 288,
          terrain = { 2, 3, 0, 3 }
        },
        {
          id = 289,
          terrain = { 2, 3, 2, 0 }
        },
        {
          id = 290,
          terrain = { 2, 3, 2, 2 }
        },
        {
          id = 291,
          terrain = { 2, 3, 2, 3 }
        },
        {
          id = 292,
          terrain = { 2, 3, 3, 0 }
        },
        {
          id = 293,
          terrain = { 2, 3, 3, 2 }
        },
        {
          id = 294,
          terrain = { 2, 3, 3, 3 }
        },
        {
          id = 295,
          terrain = { 3, 0, 0, 0 }
        },
        {
          id = 296,
          terrain = { 3, 0, 0, 2 }
        },
        {
          id = 297,
          terrain = { 3, 0, 0, 3 }
        },
        {
          id = 298,
          terrain = { 3, 0, 2, 0 }
        },
        {
          id = 299,
          terrain = { 3, 0, 2, 2 }
        },
        {
          id = 300,
          terrain = { 3, 0, 2, 3 }
        },
        {
          id = 301,
          terrain = { 3, 0, 3, 0 }
        },
        {
          id = 302,
          terrain = { 3, 0, 3, 2 }
        },
        {
          id = 303,
          terrain = { 3, 0, 3, 3 }
        },
        {
          id = 304,
          terrain = { 3, 2, 0, 0 }
        },
        {
          id = 305,
          terrain = { 3, 2, 0, 2 }
        },
        {
          id = 306,
          terrain = { 3, 2, 0, 3 }
        },
        {
          id = 307,
          terrain = { 3, 2, 2, 0 }
        },
        {
          id = 308,
          terrain = { 3, 2, 2, 2 }
        },
        {
          id = 309,
          terrain = { 3, 2, 2, 3 }
        },
        {
          id = 310,
          terrain = { 3, 2, 3, 0 }
        },
        {
          id = 311,
          terrain = { 3, 2, 3, 2 }
        },
        {
          id = 312,
          terrain = { 3, 2, 3, 3 }
        },
        {
          id = 313,
          terrain = { 3, 3, 0, 0 }
        },
        {
          id = 314,
          terrain = { 3, 3, 0, 2 }
        },
        {
          id = 315,
          terrain = { 3, 3, 0, 3 }
        },
        {
          id = 316,
          terrain = { 3, 3, 2, 0 }
        },
        {
          id = 317,
          terrain = { 3, 3, 2, 2 }
        },
        {
          id = 318,
          terrain = { 3, 3, 2, 3 }
        },
        {
          id = 319,
          terrain = { 3, 3, 3, 0 }
        },
        {
          id = 320,
          terrain = { 3, 3, 3, 2 }
        },
        {
          id = 321,
          terrain = { 5, 5, 5, 5 }
        },
        {
          id = 322,
          terrain = { 5, 5, 5, 3 }
        },
        {
          id = 323,
          terrain = { 5, 5, 3, 5 }
        },
        {
          id = 324,
          terrain = { 5, 5, 3, 3 }
        },
        {
          id = 325,
          terrain = { 5, 3, 5, 5 }
        },
        {
          id = 326,
          terrain = { 5, 3, 5, 3 }
        },
        {
          id = 327,
          terrain = { 5, 3, 3, 5 }
        },
        {
          id = 328,
          terrain = { 5, 3, 3, 3 }
        },
        {
          id = 329,
          terrain = { 3, 5, 5, 5 }
        },
        {
          id = 330,
          terrain = { 3, 5, 5, 3 }
        },
        {
          id = 331,
          terrain = { 3, 5, 3, 5 }
        },
        {
          id = 332,
          terrain = { 3, 5, 3, 3 }
        },
        {
          id = 333,
          terrain = { 3, 3, 5, 5 }
        },
        {
          id = 334,
          terrain = { 3, 3, 5, 3 }
        },
        {
          id = 335,
          terrain = { 3, 3, 3, 5 }
        },
        {
          id = 336,
          terrain = { 6, 6, 6, 6 }
        },
        {
          id = 337,
          terrain = { 7, 7, 7, 7 }
        },
        {
          id = 338,
          terrain = { 8, 8, 8, 8 }
        },
        {
          id = 339,
          terrain = { 7, 7, 7, 2 }
        },
        {
          id = 340,
          terrain = { 7, 7, 2, 7 }
        },
        {
          id = 341,
          terrain = { 7, 7, 2, 2 }
        },
        {
          id = 342,
          terrain = { 7, 2, 7, 7 }
        },
        {
          id = 343,
          terrain = { 7, 2, 7, 2 }
        },
        {
          id = 344,
          terrain = { 7, 2, 2, 7 }
        },
        {
          id = 345,
          terrain = { 7, 2, 2, 2 }
        },
        {
          id = 346,
          terrain = { 2, 7, 7, 7 }
        },
        {
          id = 347,
          terrain = { 2, 7, 7, 2 }
        },
        {
          id = 348,
          terrain = { 2, 7, 2, 7 }
        },
        {
          id = 349,
          terrain = { 2, 7, 2, 2 }
        },
        {
          id = 350,
          terrain = { 2, 2, 7, 7 }
        },
        {
          id = 351,
          terrain = { 2, 2, 7, 2 }
        },
        {
          id = 352,
          terrain = { 2, 2, 2, 7 }
        },
        {
          id = 353,
          terrain = { 1, 1, 1, 6 }
        },
        {
          id = 354,
          terrain = { 1, 1, 6, 1 }
        },
        {
          id = 355,
          terrain = { 1, 1, 6, 6 }
        },
        {
          id = 356,
          terrain = { 1, 1, 6, 2 }
        },
        {
          id = 357,
          terrain = { 1, 1, 2, 6 }
        },
        {
          id = 358,
          terrain = { 1, 6, 1, 1 }
        },
        {
          id = 359,
          terrain = { 1, 6, 1, 6 }
        },
        {
          id = 360,
          terrain = { 1, 6, 1, 2 }
        },
        {
          id = 361,
          terrain = { 1, 6, 6, 1 }
        },
        {
          id = 362,
          terrain = { 1, 6, 6, 6 }
        },
        {
          id = 363,
          terrain = { 1, 6, 6, 2 }
        },
        {
          id = 364,
          terrain = { 1, 6, 2, 1 }
        },
        {
          id = 365,
          terrain = { 1, 6, 2, 6 }
        },
        {
          id = 366,
          terrain = { 1, 6, 2, 2 }
        },
        {
          id = 367,
          terrain = { 1, 2, 1, 6 }
        },
        {
          id = 368,
          terrain = { 1, 2, 6, 1 }
        },
        {
          id = 369,
          terrain = { 1, 2, 6, 6 }
        },
        {
          id = 370,
          terrain = { 1, 2, 6, 2 }
        },
        {
          id = 371,
          terrain = { 1, 2, 2, 6 }
        },
        {
          id = 372,
          terrain = { 6, 1, 1, 1 }
        },
        {
          id = 373,
          terrain = { 6, 1, 1, 6 }
        },
        {
          id = 374,
          terrain = { 6, 1, 1, 2 }
        },
        {
          id = 375,
          terrain = { 6, 1, 6, 1 }
        },
        {
          id = 376,
          terrain = { 6, 1, 6, 6 }
        },
        {
          id = 377,
          terrain = { 6, 1, 6, 2 }
        },
        {
          id = 378,
          terrain = { 6, 1, 2, 1 }
        },
        {
          id = 379,
          terrain = { 6, 1, 2, 6 }
        },
        {
          id = 380,
          terrain = { 6, 1, 2, 2 }
        },
        {
          id = 381,
          terrain = { 6, 6, 1, 1 }
        },
        {
          id = 382,
          terrain = { 6, 6, 1, 6 }
        },
        {
          id = 383,
          terrain = { 6, 6, 1, 2 }
        },
        {
          id = 384,
          terrain = { 6, 6, 6, 1 }
        },
        {
          id = 385,
          terrain = { 6, 6, 6, 2 }
        },
        {
          id = 386,
          terrain = { 6, 6, 2, 1 }
        },
        {
          id = 387,
          terrain = { 6, 6, 2, 6 }
        },
        {
          id = 388,
          terrain = { 6, 6, 2, 2 }
        },
        {
          id = 389,
          terrain = { 6, 2, 1, 1 }
        },
        {
          id = 390,
          terrain = { 6, 2, 1, 6 }
        },
        {
          id = 391,
          terrain = { 6, 2, 1, 2 }
        },
        {
          id = 392,
          terrain = { 6, 2, 6, 1 }
        },
        {
          id = 393,
          terrain = { 6, 2, 6, 6 }
        },
        {
          id = 394,
          terrain = { 6, 2, 6, 2 }
        },
        {
          id = 395,
          terrain = { 6, 2, 2, 1 }
        },
        {
          id = 396,
          terrain = { 6, 2, 2, 6 }
        },
        {
          id = 397,
          terrain = { 6, 2, 2, 2 }
        },
        {
          id = 398,
          terrain = { 2, 1, 1, 6 }
        },
        {
          id = 399,
          terrain = { 2, 1, 6, 1 }
        },
        {
          id = 400,
          terrain = { 2, 1, 6, 6 }
        },
        {
          id = 401,
          terrain = { 2, 1, 6, 2 }
        },
        {
          id = 402,
          terrain = { 2, 1, 2, 6 }
        },
        {
          id = 403,
          terrain = { 2, 6, 1, 1 }
        },
        {
          id = 404,
          terrain = { 2, 6, 1, 6 }
        },
        {
          id = 405,
          terrain = { 2, 6, 1, 2 }
        },
        {
          id = 406,
          terrain = { 2, 6, 6, 1 }
        },
        {
          id = 407,
          terrain = { 2, 6, 6, 6 }
        },
        {
          id = 408,
          terrain = { 2, 6, 6, 2 }
        },
        {
          id = 409,
          terrain = { 2, 6, 2, 1 }
        },
        {
          id = 410,
          terrain = { 2, 6, 2, 6 }
        },
        {
          id = 411,
          terrain = { 2, 6, 2, 2 }
        },
        {
          id = 412,
          terrain = { 2, 2, 1, 6 }
        },
        {
          id = 413,
          terrain = { 2, 2, 6, 1 }
        },
        {
          id = 414,
          terrain = { 2, 2, 6, 6 }
        },
        {
          id = 415,
          terrain = { 2, 2, 6, 2 }
        },
        {
          id = 416,
          terrain = { 2, 2, 2, 6 }
        },
        {
          id = 417,
          terrain = { 8, 8, 8, 4 }
        },
        {
          id = 418,
          terrain = { 8, 8, 4, 8 }
        },
        {
          id = 419,
          terrain = { 8, 8, 4, 4 }
        },
        {
          id = 420,
          terrain = { 8, 4, 8, 8 }
        },
        {
          id = 421,
          terrain = { 8, 4, 8, 4 }
        },
        {
          id = 422,
          terrain = { 8, 4, 4, 8 }
        },
        {
          id = 423,
          terrain = { 8, 4, 4, 4 }
        },
        {
          id = 424,
          terrain = { 4, 8, 8, 8 }
        },
        {
          id = 425,
          terrain = { 4, 8, 8, 4 }
        },
        {
          id = 426,
          terrain = { 4, 8, 4, 8 }
        },
        {
          id = 427,
          terrain = { 4, 8, 4, 4 }
        },
        {
          id = 428,
          terrain = { 4, 4, 8, 8 }
        },
        {
          id = 429,
          terrain = { 4, 4, 8, 4 }
        },
        {
          id = 430,
          terrain = { 4, 4, 4, 8 }
        },
        {
          id = 431,
          terrain = { 0, 0, 0, 0 },
          probability = 0.25
        },
        {
          id = 432,
          terrain = { 0, 0, 0, 0 },
          probability = 5
        },
        {
          id = 433,
          terrain = { 0, 0, 0, 0 },
          probability = 5
        },
        {
          id = 434,
          terrain = { 1, 1, 1, 1 },
          probability = 5
        },
        {
          id = 435,
          terrain = { 1, 1, 1, 1 },
          probability = 5
        },
        {
          id = 436,
          terrain = { 2, 2, 2, 2 },
          probability = 5
        },
        {
          id = 437,
          terrain = { 2, 2, 2, 2 },
          probability = 5
        },
        {
          id = 438,
          terrain = { 2, 2, 2, 2 },
          probability = 5
        },
        {
          id = 439,
          terrain = { 3, 3, 3, 3 },
          probability = 0.25
        },
        {
          id = 440,
          terrain = { 3, 3, 3, 3 },
          probability = 5
        },
        {
          id = 441,
          terrain = { 3, 3, 3, 3 },
          probability = 5
        },
        {
          id = 442,
          properties = {
            ["block"] = "true"
          },
          terrain = { 4, 4, 4, 4 },
          probability = 3
        },
        {
          id = 443,
          properties = {
            ["block"] = "true"
          },
          terrain = { 4, 4, 4, 4 },
          probability = 3
        },
        {
          id = 444,
          properties = {
            ["block"] = "true"
          },
          terrain = { 4, 4, 4, 4 },
          probability = 3
        },
        {
          id = 445,
          terrain = { 7, 7, 7, 7 },
          probability = 0
        },
        {
          id = 446,
          terrain = { 7, 7, 7, 7 },
          probability = 0
        },
        {
          id = 447,
          terrain = { 1, 1, 1, 1 },
          probability = 0.25
        },
        {
          id = 448,
          terrain = { 8, 8, 8, 8 },
          probability = 5
        },
        {
          id = 449,
          terrain = { 8, 8, 8, 8 },
          probability = 5
        },
        {
          id = 450,
          terrain = { 8, 8, 8, 8 },
          probability = 5
        },
        {
          id = 451,
          terrain = { 7, 7, 7, 7 },
          probability = 0
        },
        {
          id = 452,
          terrain = { 5, 5, 5, 5 },
          probability = 5
        },
        {
          id = 453,
          terrain = { 5, 5, 5, 5 },
          probability = 5
        },
        {
          id = 454,
          terrain = { 5, 5, 5, 5 },
          probability = 5
        },
        {
          id = 455,
          terrain = { 3, 3, 3, 3 },
          probability = 0
        },
        {
          id = 456,
          terrain = { 3, 3, 3, 3 },
          probability = 0
        },
        {
          id = 457,
          terrain = { 4, 4, 4, 4 },
          probability = 0
        },
        {
          id = 458,
          terrain = { 4, 4, 4, 4 },
          probability = 0
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 40,
      height = 40,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        444, 5, 5, 445, 5, 5, 5, 5, 5, 5, 5, 5, 5, 173, 169, 169, 170, 5, 5, 5, 5, 5, 5, 445, 5, 5, 158, 94, 94, 93, 1, 1, 1, 1, 1, 106, 5, 5, 5, 5,
        5, 5, 5, 5, 5, 172, 164, 164, 164, 164, 164, 165, 168, 149, 1, 1, 105, 169, 168, 164, 164, 164, 164, 164, 166, 5, 5, 5, 5, 158, 94, 93, 1, 1, 1, 105, 170, 5, 5, 5,
        5, 5, 5, 5, 172, 132, 2, 2, 6, 10, 10, 26, 74, 26, 1, 1, 1, 1, 74, 10, 10, 10, 10, 9, 37, 164, 164, 164, 166, 444, 5, 158, 94, 93, 1, 1, 106, 5, 5, 5,
        5, 5, 5, 172, 132, 2, 2, 2, 22, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 74, 10, 9, 2, 2, 37, 166, 5, 5, 5, 157, 1, 1, 106, 5, 444, 5,
        5, 5, 172, 132, 2, 6, 9, 6, 26, 1, 1, 1, 1, 1, 1, 1, 1, 1, 91, 97, 1, 1, 1, 1, 1, 74, 9, 2, 2, 39, 5, 5, 5, 158, 93, 1, 105, 170, 5, 5,
        443, 5, 140, 2, 2, 21, 69, 22, 1, 91, 99, 97, 1, 1, 91, 99, 99, 99, 131, 226, 97, 1, 1, 1, 1, 1, 74, 10, 11, 47, 173, 169, 170, 5, 157, 1, 1, 106, 5, 5,
        5, 172, 132, 2, 2, 2, 6, 26, 91, 131, 257, 221, 94, 94, 126, 253, 254, 3, 3, 3, 224, 1, 1, 1, 1, 1, 1, 1, 106, 5, 158, 94, 110, 5, 158, 93, 1, 105, 170, 5,
        5, 140, 435, 6, 9, 6, 26, 1, 122, 253, 237, 5, 5, 5, 5, 5, 190, 438, 256, 248, 216, 1, 1, 1, 1, 1, 90, 94, 110, 5, 173, 169, 170, 5, 5, 157, 1, 1, 106, 445,
        5, 140, 2, 22, 74, 26, 1, 90, 110, 5, 5, 5, 174, 178, 178, 178, 194, 256, 216, 1, 1, 1, 1, 1, 1, 90, 110, 5, 173, 169, 153, 1, 105, 170, 5, 158, 93, 1, 106, 5,
        5, 140, 2, 22, 1, 1, 90, 110, 5, 5, 174, 178, 194, 3, 437, 3, 256, 216, 1, 1, 1, 1, 1, 1, 90, 110, 5, 173, 153, 1, 1, 1, 1, 106, 5, 5, 157, 1, 106, 5,
        443, 140, 2, 21, 86, 90, 110, 5, 5, 174, 194, 3, 3, 3, 3, 3, 224, 1, 1, 1, 1, 90, 94, 94, 110, 5, 173, 153, 1, 1, 1, 1, 1, 105, 170, 5, 158, 93, 106, 5,
        445, 140, 6, 10, 26, 106, 445, 445, 174, 194, 3, 3, 3, 3, 3, 3, 226, 97, 1, 1, 1, 106, 5, 173, 169, 169, 153, 1, 1, 1, 1, 1, 1, 1, 106, 5, 5, 158, 110, 5,
        443, 140, 22, 1, 1, 106, 5, 174, 194, 3, 3, 3, 3, 3, 3, 3, 438, 224, 1, 1, 90, 110, 173, 153, 1, 1, 1, 1, 1, 1, 1, 1, 90, 93, 105, 170, 445, 5, 443, 5,
        5, 140, 21, 86, 1, 106, 444, 188, 250, 438, 3, 3, 438, 3, 438, 3, 3, 226, 97, 1, 105, 169, 153, 1, 1, 1, 1, 1, 1, 1, 1, 1, 106, 157, 1, 105, 170, 5, 5, 5,
        172, 132, 2, 22, 1, 106, 5, 157, 123, 3, 3, 3, 3, 3, 439, 3, 438, 3, 224, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 90, 110, 157, 1, 1, 106, 5, 5, 5,
        142, 13, 2, 22, 1, 106, 5, 158, 126, 254, 3, 438, 3, 3, 3, 3, 3, 3, 224, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 106, 5, 157, 1, 1, 105, 170, 5, 173,
        5, 140, 436, 22, 1, 106, 5, 5, 444, 189, 253, 254, 3, 3, 3, 3, 3, 256, 216, 434, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 106, 443, 158, 93, 1, 1, 106, 5, 157,
        444, 140, 6, 26, 1, 105, 169, 170, 5, 5, 5, 189, 254, 3, 439, 3, 256, 216, 1, 434, 1, 91, 99, 97, 1, 1, 1, 1, 1, 90, 94, 110, 5, 5, 157, 1, 1, 106, 443, 158,
        5, 140, 22, 1, 1, 1, 1, 105, 169, 170, 5, 5, 190, 3, 3, 3, 224, 1, 1, 1, 91, 131, 3, 226, 97, 1, 1, 1, 1, 105, 170, 443, 5, 173, 153, 1, 1, 106, 5, 5,
        443, 140, 22, 1, 1, 1, 1, 1, 1, 105, 169, 169, 186, 3, 3, 438, 226, 97, 1, 1, 123, 3, 437, 3, 226, 99, 99, 97, 1, 1, 106, 5, 5, 158, 93, 1, 90, 110, 5, 5,
        168, 132, 22, 1, 1, 1, 1, 1, 1, 1, 1, 1, 121, 248, 250, 256, 250, 224, 1, 1, 121, 250, 3, 3, 3, 3, 3, 226, 97, 1, 105, 170, 443, 5, 157, 90, 110, 5, 5, 173,
        77, 6, 26, 1, 1, 1, 89, 85, 85, 85, 86, 1, 1, 1, 121, 216, 121, 216, 1, 1, 1, 121, 250, 3, 3, 3, 3, 3, 226, 99, 97, 105, 170, 173, 154, 110, 5, 5, 173, 153,
        142, 29, 86, 1, 1, 89, 69, 7, 13, 2, 22, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 123, 3, 3, 439, 3, 3, 3, 256, 216, 1, 106, 157, 106, 5, 5, 173, 154, 94,
        5, 140, 22, 1, 1, 73, 7, 45, 132, 6, 26, 1, 89, 85, 85, 86, 1, 1, 1, 1, 1, 1, 121, 250, 3, 3, 3, 3, 3, 226, 97, 1, 106, 158, 110, 5, 173, 153, 106, 5,
        5, 140, 22, 1, 89, 69, 39, 141, 9, 22, 89, 85, 69, 7, 13, 21, 85, 85, 85, 86, 1, 91, 99, 131, 3, 3, 3, 256, 248, 248, 216, 1, 105, 169, 170, 444, 157, 1, 106, 5,
        5, 140, 22, 1, 73, 7, 47, 158, 77, 21, 69, 7, 15, 47, 142, 15, 15, 15, 13, 21, 86, 123, 3, 438, 3, 3, 256, 216, 1, 1, 90, 94, 94, 94, 110, 5, 157, 1, 106, 5,
        5, 140, 22, 89, 69, 39, 5, 172, 132, 2, 2, 39, 5, 5, 172, 166, 5, 5, 142, 13, 22, 121, 250, 3, 3, 256, 216, 1, 90, 94, 110, 5, 5, 5, 5, 173, 153, 1, 106, 5,
        5, 140, 21, 69, 7, 47, 172, 132, 2, 2, 2, 39, 5, 172, 132, 39, 5, 5, 5, 140, 22, 1, 123, 3, 256, 216, 1, 90, 110, 445, 5, 5, 173, 169, 169, 153, 1, 1, 106, 5,
        5, 142, 15, 15, 47, 5, 140, 2, 436, 2, 7, 47, 5, 140, 7, 47, 5, 173, 168, 133, 26, 1, 121, 248, 216, 1, 1, 106, 5, 5, 173, 169, 153, 1, 1, 1, 1, 1, 106, 5,
        5, 5, 5, 5, 5, 5, 140, 2, 2, 7, 47, 5, 5, 142, 47, 5, 5, 156, 69, 22, 89, 85, 86, 1, 1, 1, 1, 106, 5, 5, 157, 1, 1, 1, 1, 1, 1, 1, 106, 5,
        5, 5, 5, 5, 5, 5, 142, 15, 15, 47, 5, 5, 173, 170, 5, 5, 173, 136, 6, 26, 73, 2, 21, 85, 86, 1, 1, 106, 5, 5, 158, 93, 1, 1, 1, 1, 1, 1, 106, 5,
        5, 5, 173, 170, 5, 5, 5, 5, 5, 5, 173, 169, 154, 110, 172, 164, 148, 69, 21, 85, 69, 2, 7, 15, 30, 1, 1, 105, 170, 5, 5, 158, 94, 93, 1, 1, 1, 1, 106, 5,
        445, 5, 157, 105, 170, 5, 5, 173, 169, 169, 153, 1, 106, 5, 140, 6, 9, 2, 2, 7, 15, 15, 47, 173, 153, 1, 1, 1, 105, 169, 170, 5, 5, 158, 93, 1, 1, 1, 106, 5,
        5, 5, 158, 94, 109, 169, 169, 153, 1, 1, 1, 90, 110, 5, 140, 21, 69, 7, 15, 47, 5, 5, 5, 158, 94, 94, 94, 94, 93, 1, 105, 170, 5, 5, 157, 1, 1, 1, 106, 445,
        5, 5, 5, 5, 157, 90, 94, 94, 93, 1, 1, 106, 5, 173, 138, 15, 15, 47, 5, 5, 5, 173, 170, 5, 5, 5, 5, 5, 157, 1, 1, 106, 5, 5, 157, 1, 1, 1, 106, 5,
        5, 5, 5, 5, 158, 110, 5, 5, 157, 1, 90, 110, 5, 158, 110, 5, 5, 5, 5, 5, 5, 158, 110, 5, 5, 5, 444, 5, 158, 94, 94, 110, 5, 5, 157, 1, 1, 1, 106, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 157, 1, 106, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 173, 153, 1, 1, 1, 106, 5,
        5, 5, 5, 5, 443, 5, 5, 444, 158, 93, 105, 169, 169, 170, 5, 5, 5, 173, 169, 169, 169, 169, 169, 169, 169, 170, 5, 5, 5, 5, 5, 5, 173, 153, 1, 1, 1, 90, 110, 5,
        5, 5, 445, 5, 5, 5, 5, 445, 5, 158, 94, 94, 94, 110, 5, 5, 173, 153, 1, 1, 90, 94, 94, 94, 94, 110, 5, 5, 5, 5, 5, 5, 158, 94, 94, 94, 94, 110, 5, 5,
        5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 157, 1, 1, 1, 106, 5, 443, 5, 5, 5, 173, 169, 169, 169, 170, 445, 5, 5, 5, 5, 5, 5, 5, 5
      }
    }
  }
}
