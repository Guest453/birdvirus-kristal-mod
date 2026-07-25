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
  nextobjectid = 37,
  properties = {
    ["name"] = "Chapter 1 - room_field_boxpuzzle",
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
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 320,
          width = 80.0,
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
          x = 40,
          y = 360,
          width = 40.0,
          height = 120.0,
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
          x = 80,
          y = 440,
          width = 520.0,
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
          x = 560,
          y = 120,
          width = 40.0,
          height = 320.0,
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
          x = 0,
          y = 200,
          width = 80.0,
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
          x = 40,
          y = 160,
          width = 40.0,
          height = 40.0,
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
          x = 40,
          y = 120,
          width = 250.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 350,
          y = 120,
          width = 215.3846,
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
            ["texture"] = "world/ch1_dark/rooms/room_field_boxpuzzle"
          }
        },
        {
          id = 18,
          name = "ch1_block_target",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 200,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_boxpuzzle",
            ["target_id"] = 101569
          }
        },
        {
          id = 19,
          name = "ch1_block_target",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 200,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_boxpuzzle",
            ["target_id"] = 101570
          }
        },
        {
          id = 29,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 240,
          width = 80.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 2.0,
            ["rows"] = 2.0,
            ["frames"] = 9
          }
        },
        {
          id = 30,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 160,
          width = 120.0,
          height = 280.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 3.0,
            ["rows"] = 7.0,
            ["frames"] = 9
          }
        },
        {
          id = 31,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 240,
          width = 40.0,
          height = 200.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 1.0,
            ["rows"] = 5.0,
            ["frames"] = 9
          }
        },
        {
          id = 32,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 360,
          width = 320.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 8.0,
            ["rows"] = 2.0,
            ["frames"] = 9
          }
        },
        {
          id = 33,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 240,
          width = 160.0,
          height = 120.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 4.0,
            ["rows"] = 3.0,
            ["frames"] = 9
          }
        },
        {
          id = 34,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 160,
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
        },
        {
          id = 35,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 160,
          width = 240.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 6.0,
            ["rows"] = 1.0,
            ["frames"] = 9
          }
        },
        {
          id = 36,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 200,
          width = 80.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 2.0,
            ["rows"] = 1.0,
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
          x = 319,
          y = 296,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "marker_a",
          type = "",
          shape = "point",
          x = 100,
          y = 296,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 27,
          name = "marker_b",
          type = "",
          shape = "point",
          x = 319,
          y = 196,
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
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 240,
          width = 40.0,
          height = 160.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 360,
          width = 200.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 240,
          width = 40.0,
          height = 120.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 200,
          width = 40.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 120.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 200,
          width = 40.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 160,
          width = 120.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 200,
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
          name = "ch1_pushblock",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 320,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_boxpuzzle",
            ["block_id"] = 101546
          }
        },
        {
          id = 4,
          name = "ch1_pushblock",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 320,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_boxpuzzle",
            ["block_id"] = 101547
          }
        },
        {
          id = 20,
          name = "ch1_box_gate",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 40,
          width = 100,
          height = 120,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["puzzle"] = "room_field_boxpuzzle"
          }
        },
        {
          id = 24,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 100,
          width = 80.0,
          height = 20.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field4",
            ["marker"] = "marker_a",
            ["facing"] = "up"
          }
        },
        {
          id = 26,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -20,
          y = 240,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field3",
            ["marker"] = "marker_b",
            ["facing"] = "left"
          }
        },
        {
          id = 28,
          name = "ch1_readable",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 120,
          width = 40.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["text"] = "* Suddenly,[wait:5] your body seizes up.\n* What are you looking at?"
          }
        }
      }
    }
  }
}
