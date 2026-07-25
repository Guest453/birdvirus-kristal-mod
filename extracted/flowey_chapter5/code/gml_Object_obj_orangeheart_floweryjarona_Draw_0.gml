draw_self();
if (mode == 3 && timer >= 15 && timer <= 60)
{
    draw_sprite_ext(spr_sneo_bullet_arrow, 0, camerax() + 100 + (sin(global.time * 0.4) * 10), fist_y, 2, 2, 0, c_gray, 1);
}
if (fogalf > 0)
{
    gpu_set_fog(true, fogcol, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, fogalf);
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, fogalf);
    gpu_set_blendmode(bm_normal);
    gpu_set_fog(false, c_white, 0, 0);
    if (mode == 1)
    {
        with (orange_dopple)
        {
            gpu_set_fog(true, other.fogcol, 0, 0);
            draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, other.fogalf);
            gpu_set_blendmode(bm_add);
            draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, other.fogalf);
            gpu_set_blendmode(bm_normal);
            gpu_set_fog(false, c_white, 0, 0);
        }
    }
}
draw_set_color(c_red);
draw_set_color(-1);
