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
  nextobjectid = 14,
  properties = {
    ["name"] = "Chapter 1 - room_dark3a",
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
          x = 360,
          y = 0,
          width = 40.0,
          height = 240.0,
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
          x = 80,
          y = 200,
          width = 280.0,
          height = 40.0,
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
          x = 80,
          y = 240,
          width = 40.0,
          height = 160.0,
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
          x = 120,
          y = 360,
          width = 440.0,
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
          x = 520,
          y = 0,
          width = 40.0,
          height = 360.0,
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
            ["texture"] = "world/ch1_dark/rooms/room_dark3a"
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
          x = 459,
          y = 316,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "marker_a",
          type = "",
          shape = "point",
          x = 459,
          y = 100,
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
          x = 140,
          y = 10,
          width = 78,
          height = 74,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_wobblything",
            ["frames"] = 4,
            ["animation_speed"] = 0.17,
            ["trigger"] = "near_x",
            ["sound"] = "ch1_dark/wobbler",
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
          x = 350,
          y = 10,
          width = 78,
          height = 74,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_wobblything",
            ["frames"] = 4,
            ["animation_speed"] = 0.17,
            ["trigger"] = "near_x",
            ["sound"] = "ch1_dark/wobbler",
            ["scale_x"] = 2,
            ["scale_y"] = 2,
            ["origin_x"] = 10,
            ["origin_y"] = 5
          }
        },
        {
          id = 5,
          name = "ch1_dustpile",
          type = "",
          shape = "rectangle",
          x = 210,
          y = 10,
          width = 126,
          height = 92,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "ch1_glowshard",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 180,
          width = 40.0,
          height = 60.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 400,
          y = -20,
          width = 120.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_dark3",
            ["marker"] = "marker_b",
            ["facing"] = "up"
          }
        }
      }
    }
  }
}
