using System;

for (var i = 0; i < Data.Rooms.Count; i++)
{
    var name = Data.Rooms[i].Name.Content;
    if (name == "room_dark1")
    {
        for (var j = i; j < Math.Min(Data.Rooms.Count, i + 35); j++)
            Console.WriteLine($"{j}\t{Data.Rooms[j].Name.Content}");
        break;
    }
}
