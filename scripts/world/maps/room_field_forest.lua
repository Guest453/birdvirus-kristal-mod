return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 26,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 11,
  properties = {
    ["name"] = "Chapter 1 - room_field_forest",
    ["border"] = "simple",
    ["music"] = "bird"
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
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 160,
          width = 40.0,
          height = 280.0,
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
          x = 240,
          y = 400,
          width = 800.0,
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
          x = 360,
          y = 160,
          width = 40.0,
          height = 160.0,
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
          y = 280,
          width = 640.0,
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
            ["texture"] = "world/ch1_dark/rooms/room_field_forest"
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
          x = 299,
          y = 236,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "marker_a",
          type = "",
          shape = "point",
          x = 299,
          y = 236,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "marker_b",
          type = "",
          shape = "point",
          x = 940,
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
          id = 8,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 1030,
          y = 280,
          width = 20.0,
          height = 160.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field1",
            ["marker"] = "marker_a",
            ["facing"] = "right"
          }
        },
        {
          id = 10,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 160,
          width = 120.0,
          height = 20.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field_start",
            ["marker"] = "marker_b",
            ["facing"] = "up"
          }
        }
      }
    }
  }
}
