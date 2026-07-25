if (appearance)
{
    tag_in();
}
with (orange_dopple)
{
    sprite_index = spr_enemy_orange_walk_left;
    image_index = 0;
    image_speed = 0;
    if (i_ex(obj_flowery_enemy) && i_ex(obj_flowery_enemy.orange_marker))
    {
        scr_lerpvar("x", x, obj_flowery_enemy.orange_marker.x, 16);
    }
    if (i_ex(obj_flowery_enemy) && i_ex(obj_flowery_enemy.orange_marker))
    {
        scr_lerpvar("y", y, obj_flowery_enemy.orange_marker.y, 16);
    }
    scr_doom(id, 16);
}
with (obj_flowery_enemy)
{
    make_orange_visible_con = 1;
    with (orange_marker)
    {
        visible = false;
    }
    snd_stop(scr_84_get_sound("snd_flowery_voiceclip_jarona1"));
    snd_stop(scr_84_get_sound("snd_flowery_voiceclip_jarona2"));
    snd_stop(scr_84_get_sound("snd_jarona_orange1"));
    snd_stop(scr_84_get_sound("snd_jarona_orange2"));
    snd_stop(scr_84_get_sound("snd_ja_kidding"));
    if (!other.stopthat)
    {
        snd_play(snd_jump, 0.5, 1.5);
        snd_play_flowery(scr_84_get_sound("snd_flowery_voiceclip_huh"), 0.35);
    }
    var _x = x;
    var _y = y;
    _depth = other.depth;
    x = other.x;
    y = other.y;
    var _jump_y = min(_y - 90, y - 120);
    idlesprite = spr_flowery_shrug_spin;
    image_speed = 0;
    siner = 0;
    scr_lerpvar("x", x, _x, 16);
    scr_lerpvar("y", y, _jump_y, 8, 2, "out");
    scr_script_delayed(scr_lerpvar, 9, "y", _jump_y, _y, 8, 2, "in");
    scr_script_delayed(function()
    {
        idlesprite = spr_flowery_idle3;
        image_speed = 0.16666666666666666;
        depth = _depth;
    }, 20);
    visible = true;
}
ds_list_destroy(final_list);
