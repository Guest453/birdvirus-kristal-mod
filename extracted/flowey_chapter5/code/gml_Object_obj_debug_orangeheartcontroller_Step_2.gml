if (hitstop <= 0)
{
    fakecamxspeed = fakecamxspeedbase + fakecamxspeedadditional;
    fakecamx += fakecamxspeed;
    var tocheck = [];
    array_push(tocheck, 477, 970, 1174, 216);
    array_push(tocheck, 1238, 1569, 363, 1013);
    array_push(tocheck, 600, 264, 709);
    var par = id;
    for (var i = 0; i < array_length(tocheck); i++)
    {
        with (tocheck[i])
        {
            if (variable_instance_exists(id, "orangeheartControlled") && orangeheartControlled == true)
            {
                x += par.fakecamxspeed;
                if (object_index == obj_afterimage)
                {
                    image_xscale *= 0.95;
                    image_yscale *= 0.95;
                }
            }
            if (object_index == obj_orangeheart_word_manager)
            {
                align_words();
            }
        }
    }
}
else
{
    hitstop--;
}
