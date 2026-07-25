return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 35,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 14,
  properties = {
    ["name"] = "Chapter 1 - room_castle_tutorial",
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
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 400,
          width = 1400.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1000,
          y = 280,
          width = 400.0,
          height = 40.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 80,
          width = 680.0,
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
          x = 1000,
          y = 120,
          width = 40.0,
          height = 164.10256,
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
          width = 400.0,
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
          x = 360,
          y = 120,
          width = 40.0,
          height = 164.10256,
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
            ["texture"] = "world/ch1_dark/rooms/room_castle_tutorial"
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
          x = 109,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "marker_x",
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
          id = 13,
          name = "marker_b",
          type = "",
          shape = "point",
          x = 1300,
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
          id = 9,
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
            ["map"] = "room_castle_town",
            ["marker"] = "marker_x",
            ["facing"] = "left"
          }
        },
        {
          id = 11,
          name = "ch1_trigger",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 0,
          width = 220.0,
          height = 160.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["trigger"] = "tutorial",
            ["flag"] = "ch1_trigger_tutorial",
            ["auto"] = false
          }
        },
        {
          id = 12,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1390,
          y = 320,
          width = 20.0,
          height = 80.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_castle_darkdoor",
            ["marker"] = "marker_a",
            ["facing"] = "right"
          }
        }
      }
    }
  }
}
