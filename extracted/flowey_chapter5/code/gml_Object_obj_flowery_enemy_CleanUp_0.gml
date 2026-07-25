with (obj_marker)
{
    if (sprite_index == spr_sparestar_anim)
    {
        instance_destroy();
    }
}
with (obj_flowery_marker)
{
    instance_destroy();
}
sprite_set_offset(spr_flowers, 10, 22);
global.flag[1864] = 1;
global.tempflag[65] = 1;
