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
  nextobjectid = 20,
  properties = {
    ["name"] = "Chapter 1 - room_field_shop1",
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
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 280,
          width = 40.0,
          height = 200.0,
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
          x = 360,
          y = 280,
          width = 40.0,
          height = 200.0,
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
          x = 400,
          y = 280,
          width = 240.0,
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
          x = 0,
          y = 280,
          width = 205.12820000000002,
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
          x = -10,
          y = 160,
          width = 270.0,
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
          x = 340,
          y = 160,
          width = 307.69228,
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
            ["texture"] = "world/ch1_dark/rooms/room_field_shop1"
          }
        },
        {
          id = 18,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 200,
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
          id = 19,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 280,
          width = 120.0,
          height = 200.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 3.0,
            ["rows"] = 5.0,
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
          x = 499,
          y = 276,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "marker_x",
          type = "",
          shape = "point",
          x = 299,
          y = 256,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "marker_a",
          type = "",
          shape = "point",
          x = 299,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "marker_d",
          type = "",
          shape = "point",
          x = 540,
          y = 256,
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
          x = 100,
          y = 256,
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
          name = "savepoint",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 160,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["text"] = {"* At times,[wait:5] you see it flickering.\n* The light only you can see.", "* By second nature,[wait:5] you reach out,[wait:5] and..."}
          }
        },
        {
          id = 5,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 470,
          width = 120.0,
          height = 20.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field_getsusie",
            ["marker"] = "marker_b",
            ["facing"] = "down"
          }
        },
        {
          id = 13,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 620,
          y = 200,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field3",
            ["marker"] = "marker_c",
            ["facing"] = "right"
          }
        },
        {
          id = 15,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 200,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field_puzzletutorial",
            ["marker"] = "marker_a",
            ["facing"] = "left"
          }
        },
        {
          id = 17,
          name = "ch1_prop",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 210,
          width = 68.0,
          height = 60.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_npc_puzzlepiece",
            ["frames"] = 2,
            ["start_frame"] = 0,
            ["animation_speed"] = 0,
            ["scale_x"] = 2.0,
            ["scale_y"] = 2.0,
            ["origin_x"] = 0,
            ["origin_y"] = 0,
            ["solid"] = true,
            ["text"] = "* The Darkner looks at you expectantly."
          }
        }
      }
    }
  }
}
