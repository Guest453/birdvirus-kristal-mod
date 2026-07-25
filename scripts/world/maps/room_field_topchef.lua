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
  nextobjectid = 17,
  properties = {
    ["name"] = "Chapter 1 - room_field_topchef",
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
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 320,
          width = 640.0,
          height = 40.0,
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
          x = 0,
          y = 200,
          width = 160.0,
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
          x = 120,
          y = 120,
          width = 40.0,
          height = 80.0,
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
          x = 120,
          y = 80,
          width = 360.0,
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
          x = 480,
          y = 80,
          width = 40.0,
          height = 160.0,
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
          x = 520,
          y = 200,
          width = 120.0,
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
            ["texture"] = "world/ch1_dark/rooms/room_field_topchef"
          }
        },
        {
          id = 11,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 240,
          width = 640.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 16.0,
            ["rows"] = 2.0,
            ["frames"] = 9
          }
        },
        {
          id = 12,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 120,
          width = 320.0,
          height = 120.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 8.0,
            ["rows"] = 3.0,
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
          x = 100,
          y = 316,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "marker_c",
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
          id = 16,
          name = "marker_b",
          type = "",
          shape = "point",
          x = 540,
          y = 296,
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
          name = "ch1_prop",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 200,
          width = 68,
          height = 60,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_npc_puzzlepiece",
            ["frames"] = 2,
            ["start_frame"] = 0,
            ["animation_speed"] = 0,
            ["scale_x"] = 2,
            ["scale_y"] = 2,
            ["origin_x"] = 0,
            ["origin_y"] = 0,
            ["solid"] = true,
            ["text"] = "* The Darkner looks at you expectantly."
          }
        },
        {
          id = 4,
          name = "ch1_prop",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 120,
          width = 68,
          height = 60,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_npc_puzzlepiece",
            ["frames"] = 2,
            ["start_frame"] = 0,
            ["animation_speed"] = 0,
            ["scale_x"] = 2,
            ["scale_y"] = 2,
            ["origin_x"] = 0,
            ["origin_y"] = 0,
            ["solid"] = true,
            ["text"] = "* The Darkner looks at you expectantly."
          }
        },
        {
          id = 13,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -10,
          y = 240,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field2",
            ["marker"] = "marker_d",
            ["facing"] = "left"
          }
        },
        {
          id = 15,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 630,
          y = 240,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field_puzzle1",
            ["marker"] = "marker_a",
            ["facing"] = "right"
          }
        }
      }
    }
  }
}
