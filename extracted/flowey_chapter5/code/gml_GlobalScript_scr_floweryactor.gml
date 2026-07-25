function scr_floweryactor(arg0 = "flowery_left", arg1 = 
{
    x: 0,
    y: 0
})
{
    actor_count++;
    fl = array_length(global.cinstance) + 1;
    fl_actor = instance_create(arg1.x, arg1.y, obj_actor);
    scr_actor_setup(fl, fl_actor, "flowery");
    with (fl_actor)
    {
        scr_set_facing_sprites(arg0);
    }
    fl_actor.sprite_index = fl_actor.dsprite;
    if (is_struct(arg1))
    {
        if (variable_struct_exists(arg1, "sprite_index"))
        {
            fl_actor.sprite_index = arg1.sprite_index;
        }
    }
    else
    {
        with (arg1)
        {
            visible = false;
            other.fl_actor.sprite_index = sprite_index;
        }
    }
}
