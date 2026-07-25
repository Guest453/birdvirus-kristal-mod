purple_timer++;
if (purple_timer > 10)
{
    purple_timer = 0;
    flower_particle = instance_create_depth(purple_marker.x + 8 + irandom(50), purple_marker.y + 78, purple_marker.depth + 1, obj_marker);
    flower_particle.sprite_index = spr_sparestar_anim;
    flower_particle.image_index = 3;
    flower_particle.image_speed = choose(1/3, 0.25, 0.2) / 2;
    flower_particle.image_xscale = 2;
    flower_particle.image_yscale = 2;
    flower_particle.vspeed = 2;
    flower_particle.gravity = 0.1;
    flower_particle.gravity_direction = 190;
    flower_particle.image_blend = make_color_rgb(136, 23, 106);
    with (flower_particle)
    {
        scr_script_delayed(scr_lerp_var_instance, (3 / image_speed) - 9, id, "image_alpha", 1, 0, 9);
        scr_script_delayed(instance_destroy, 3 / image_speed);
    }
}
