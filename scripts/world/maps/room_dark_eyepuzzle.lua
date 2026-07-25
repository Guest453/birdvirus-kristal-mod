return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 34,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 16,
  properties = {
    ["name"] = "Chapter 1 - room_dark_eyepuzzle",
    ["border"] = "simple",
    ["music"] = "creepylandscape"
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
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = -19,
          y = 402,
          width = 1393.0526,
          height = 18.0,
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
          x = -17,
          y = 303,
          width = 1392.0526,
          height = 18.0,
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
            ["texture"] = "world/ch1_dark/rooms/room_dark_eyepuzzle"
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
          x = 219,
          y = 376,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "marker_a",
          type = "",
          shape = "point",
          x = 100,
          y = 376,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "marker_b",
          type = "",
          shape = "point",
          x = 1260,
          y = 376,
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
          x = 200,
          y = 280,
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
          id = 4,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 280,
          width = 20.0,
          height = 140.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_dark_wobbles",
            ["marker"] = "marker_b",
            ["facing"] = "left"
          }
        },
        {
          id = 6,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1340,
          y = 320,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_dark7",
            ["marker"] = "marker_a",
            ["facing"] = "right"
          }
        },
        {
          id = 8,
          name = "ch1_prop",
          type = "",
          shape = "rectangle",
          x = 554,
          y = 180,
          width = 74.0,
          height = 58.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_darkeye",
            ["frames"] = 2,
            ["start_frame"] = 0,
            ["animation_speed"] = 0,
            ["scale_x"] = 1.0,
            ["scale_y"] = 1.0,
            ["origin_x"] = 0,
            ["origin_y"] = 0
          }
        },
        {
          id = 9,
          name = "ch1_eye_switch",
          type = "",
          shape = "rectangle",
          x = 570,
          y = 280,
          width = 80.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["index"] = 1
          }
        },
        {
          id = 10,
          name = "ch1_eye_switch",
          type = "",
          shape = "rectangle",
          x = 680,
          y = 280,
          width = 80.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["index"] = 2
          }
        },
        {
          id = 11,
          name = "ch1_eye_switch",
          type = "",
          shape = "rectangle",
          x = 790,
          y = 280,
          width = 80.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["index"] = 3
          }
        },
        {
          id = 12,
          name = "ch1_readable",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 280,
          width = 40.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["text"] = "* In this land,[wait:5] only eyes blinded by darkness can see the way..."
          }
        },
        {
          id = 15,
          name = "ch1_eye_gate",
          type = "",
          shape = "rectangle",
          x = 960,
          y = 320,
          width = 60,
          height = 80,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
