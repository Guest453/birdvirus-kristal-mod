siner++;
image_blend = c_orange;
for (var a = 9; a >= 0; a--)
{
    if (a > 0)
    {
        if (!(abs(prev_coord[a][0] - prev_coord[a - 1][0]) < 1))
        {
            draw_sprite_ext(sprite_index, image_index, prev_coord[a][0], prev_coord[a][1], image_xscale, image_yscale, image_angle, image_blend, 0.55 - (a * 0.05));
        }
    }
    else
    {
        draw_sprite_ext(sprite_index, image_index, prev_coord[a][0], prev_coord[a][1], image_xscale, image_yscale, image_angle, image_blend, 0.55 - (a * 0.05));
    }
}
if (dashstate == 1 && chargetimer < 16)
{
    var z_charge = (chargetimer * 2) % 35;
    for (var i = 0; i < 4; i += 1)
    {
        var alf = (chargetimer / 10) - 0.2;
        var rotx = (i * 90) + (z_charge * 5);
        var xx = sin(degtorad(rotx)) * (35 - z_charge);
        var yy = cos(degtorad(rotx)) * (35 - z_charge);
        draw_sprite_ext(spr_yheart_charge, 0, (x + 9) - xx, (y + 10) - yy, 4 - ((z_charge * 2) / 35), 4 - ((z_charge * 2) / 35), 0, c_white, alf);
    }
}
if (shakeheart)
{
    shakeheart--;
}
draw_sprite_ext(sprite_index, image_index, x + (choose(-1, 0, 1) * sign(shakeheart)), y + (choose(-1, 0, 1) * sign(shakeheart)), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
if (dashstate == 1 && chargetimer == 16)
{
    glowtimer += 0.5;
    draw_sprite_ext(spr_orangeheart_white, 0, x, y, image_xscale, image_yscale, image_angle, c_white, 0.5 + (sin(glowtimer) * 0.5));
}
if (dashstate == 2)
{
    draw_sprite_ext(spr_orangeheart_dash, global.time, x - 2, y, (image_xscale * 1.25) - (0.45 + (sin(global.time * 1.5) * 0.2)), image_yscale, image_angle, image_blend, 0.45 + (sin(global.time * 1.5) * 0.2));
    gpu_set_fog(true, c_yellow, 0, 0);
    draw_sprite_ext(spr_orangeheart_dash, global.time, x - 2, y, (image_xscale * 1.25) - (0.225 + (sin(global.time * 1.5) * 0.1)), image_yscale, image_angle, image_blend, 0.225 + (sin(global.time * 1.5) * 0.1));
    draw_sprite_ext(spr_orangeheart_white, 0, x, y, image_xscale, image_yscale, image_angle, c_white, 0.45 + (sin(global.time * 1.5) * 0.2));
    gpu_set_fog(false, c_white, 0, 0);
}
