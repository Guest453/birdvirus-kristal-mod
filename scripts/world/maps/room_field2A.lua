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
    ["name"] = "Chapter 1 - room_field2A",
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
          id = 6,
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
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 200,
          width = 40.0,
          height = 240.0,
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
          y = 400,
          width = 440.0,
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
          x = 520,
          y = 0,
          width = 40.0,
          height = 400.0,
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
            ["texture"] = "world/ch1_dark/rooms/room_field2A"
          }
        },
        {
          id = 10,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 0,
          width = 120.0,
          height = 240.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 3.0,
            ["rows"] = 6.0,
            ["frames"] = 9
          }
        },
        {
          id = 11,
          name = "ch1_grass",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 240,
          width = 400.0,
          height = 160.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["columns"] = 10.0,
            ["rows"] = 4.0,
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
          x = 299,
          y = 356,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "marker_a",
          type = "",
          shape = "point",
          x = 449,
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
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 400,
          y = -10,
          width = 120.0,
          height = 20.0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["map"] = "room_field2",
            ["marker"] = "marker_b",
            ["facing"] = "up"
          }
        },
        {
          id = 12,
          name = "ch1_prop",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 60,
          width = 140,
          height = 164,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_candytree",
            ["frames"] = 1,
            ["start_frame"] = 0,
            ["animation_speed"] = 0,
            ["scale_x"] = 2,
            ["scale_y"] = 2,
            ["origin_x"] = 0,
            ["origin_y"] = 0,
            ["solid"] = true,
            ["action"] = "candy_tree"
          }
        },
        {
          id = 13,
          name = "ch1_prop",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 200,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["sprite"] = "world/ch1_dark/extracted/spr_npc_sign",
            ["frames"] = 1,
            ["start_frame"] = 0,
            ["animation_speed"] = 0,
            ["scale_x"] = 2,
            ["scale_y"] = 2,
            ["origin_x"] = 0,
            ["origin_y"] = 0,
            ["solid"] = true,
            ["text"] = {"* (These types of trees DON'T contain an item that can heal you.)", "* (Whatever you do,[wait:5] DON'T check the tree and open your menu!)", "* (You got it!?)\n* (SIGNED, LANCER)"}
          }
        }
      }
    }
  }
}
