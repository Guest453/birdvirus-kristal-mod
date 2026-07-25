return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 23,
  properties = {
    ["name"] = "Chapter 1 - room_field_puzzle2",
    ["border"] = "simple",
    ["keepmusic"] = true
  },
  tilesets = {},
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 1,
      name = "collision",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 360,
          width = 120.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 400,
          width = 400.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 360,
          width = 120.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 240,
          width = 120.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 120,
          width = 40.0,
          height = 120.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 120,
          width = 400.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 120,
          width = 40.0,
          height = 160.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 240,
          width = 80.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "objects_ground",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "ch1_room_art",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["texture"] = "world/ch1_dark/rooms/room_field_puzzle2"
          }
        },
        {
          id = 22,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 280,
          width = 120.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 3.0,
            ["rows"] = 2.0,
            ["frames"] = 9
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "markers",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 2,
          name = "event_spawn",
          type = "",
          shape = "point",
          x = 199,
          y = 276,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "marker_a",
          type = "",
          shape = "point",
          x = 100,
          y = 336,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "marker_b",
          type = "",
          shape = "point",
          x = 540,
          y = 336,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "enemycollision",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {

      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "objects_party",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {

      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
      name = "objects",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 3,
          name = "ch1_glow_controller",
          type = "",
          shape = "rectangle",
          x = 290,
          y = 80,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_puzzle2",
            ["tile_count"] = 6
          }
        },
        {
          id = 4,
          name = "ch1_glow_tile",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 280,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_puzzle2",
            ["index"] = 101450
          }
        },
        {
          id = 5,
          name = "ch1_glow_tile",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 230,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_puzzle2",
            ["index"] = 101451
          }
        },
        {
          id = 6,
          name = "ch1_glow_tile",
          type = "",
          shape = "rectangle",
          x = 340,
          y = 230,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_puzzle2",
            ["index"] = 101452
          }
        },
        {
          id = 7,
          name = "ch1_glow_tile",
          type = "",
          shape = "rectangle",
          x = 380,
          y = 280,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_puzzle2",
            ["index"] = 101453
          }
        },
        {
          id = 8,
          name = "ch1_glow_tile",
          type = "",
          shape = "rectangle",
          x = 340,
          y = 330,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_puzzle2",
            ["index"] = 101454
          }
        },
        {
          id = 9,
          name = "ch1_glow_tile",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 330,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_puzzle2",
            ["index"] = 101455
          }
        },
        {
          id = 18,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -10,
          y = 280,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field_maze",
            ["marker"] = "marker_b",
            ["facing"] = "left"
          }
        },
        {
          id = 19,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 630,
          y = 280,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field_getsusie",
            ["marker"] = "marker_a",
            ["facing"] = "right"
          }
        }
      }
    }
  }
}
