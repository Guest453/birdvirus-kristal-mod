var cx = camerax();
var cy = cameray();
var screenspace = 680;
var space = screenspace / 5;
for (var i = 0; i < (screenspace / space); i++)
{
    var _xpos = cx + ((fakecamx + (i * space)) % screenspace) + 640;
    var prog = _xpos / screenspace;
    draw_sprite_ext(spr_pxwhite, 0, _xpos, scr_get_box(1) + 4, 8, 40 + (177 * scale_factor), 0, merge_color(c_black, c_white, clamp(prog, 0.2, 1)), do_lines);
}
if (spotlight != 0)
{
    if (!surface_exists(my_surface))
    {
        my_surface = surface_create(camerawidth(), cameraheight());
    }
    surface_set_target(my_surface);
    d_rectangle_color(0, 0, camerawidth(), cameraheight(), 0, 0, 0, 0, false);
    gpu_set_blendenable(false);
    draw_set_alpha(0);
    d_circle((obj_orangeheart.x + 10) - camerax(), (obj_orangeheart.y + 10) - cameray(), spotlight, false);
    draw_set_alpha(1);
    gpu_set_blendenable(true);
    surface_reset_target();
    draw_surface_ext(my_surface, camerax(), cameray(), 1, 1, 0, c_white, 0.5);
}
