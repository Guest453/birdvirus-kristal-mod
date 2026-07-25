return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 33,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 12,
  properties = {
    ["name"] = "Chapter 1 - room_dark_wobbles",
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
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 400,
          width = 1320.0,
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
          x = 0,
          y = 280,
          width = 1320.0,
          height = 41.02564,
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
            ["texture"] = "world/ch1_dark/rooms/room_dark_wobbles"
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
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "marker_c",
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
          id = 11,
          name = "marker_b",
          type = "",
          shape = "point",
          x = 1220,
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
          name = "ch1_prop",
          type = "",
          shape = "rectangle",
          x = 342,
          y = 90,
          width = 78,
          height = 74,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_wobblything_evil",
            ["frames"] = 4,
            ["start_frame"] = 0,
            ["animation_speed"] = 0.17,
            ["scale_x"] = 2,
            ["scale_y"] = 2,
            ["origin_x"] = 10,
            ["origin_y"] = 5
          }
        },
        {
          id = 4,
          name = "ch1_prop",
          type = "",
          shape = "rectangle",
          x = 738,
          y = 92,
          width = 78,
          height = 74,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_wobblything_evil",
            ["frames"] = 4,
            ["start_frame"] = 0,
            ["animation_speed"] = 0.17,
            ["scale_x"] = 2,
            ["scale_y"] = 2,
            ["origin_x"] = 10,
            ["origin_y"] = 5
          }
        },
        {
          id = 5,
          name = "ch1_prop",
          type = "",
          shape = "rectangle",
          x = 940,
          y = 94,
          width = 78,
          height = 74,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_wobblything_evil",
            ["frames"] = 4,
            ["start_frame"] = 0,
            ["animation_speed"] = 0.17,
            ["scale_x"] = 2,
            ["scale_y"] = 2,
            ["origin_x"] = 10,
            ["origin_y"] = 5
          }
        },
        {
          id = 8,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -10,
          y = 320,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_dark3",
            ["marker"] = "marker_d",
            ["facing"] = "left"
          }
        },
        {
          id = 10,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1310,
          y = 320,
          width = 50.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_dark_eyepuzzle",
            ["marker"] = "marker_a",
            ["facing"] = "right"
          }
        }
      }
    }
  }
}
