var floating = true;
with (obj_lerpvar)
{
    if (target == other.id)
    {
        floating = false;
    }
}
if (acting == 101)
{
    d_rectangle_color(camerax() + 240, cameray() + 290, (camerax() + 210 + 210) - (acttimer * 0.9), cameray() + 300, 16776960, 16776960, 16776960, 16776960, 0);
    draw_sprite_ext(spr_poppup_hourglass, 0, camerax() + 240, cameray() + 295, 2, 2, 0, c_white, image_alpha);
    d3d_set_fog(true, c_white, 0, 0);
    if (button1_p() == 1)
    {
        draw_sprite_ext(spr_poppup_hourglass, 0, camerax() + 240, cameray() + 295, 2, 2, 0, c_white, image_alpha);
    }
    d3d_set_fog(false, c_white, 0, 0);
}
if (state == 10)
{
    ashake = 0;
    xoff = 0;
    animsiner += 1;
    if (blown == 1)
    {
        image_xscale = 2;
    }
    if (image_xscale < 2)
    {
        xoff = (originalwidth - sprite_width) / 2;
    }
    blowanimtimer--;
    if (blowanimtimer > 6)
    {
        if (onoff == 2)
        {
            onoff = 0;
        }
        if (onoff == 1.5)
        {
            onoff = 2;
        }
        if (onoff == 0.5)
        {
            onoff = 1;
        }
        if (onoff == 0)
        {
            ashake = -shakeamt;
            onoff = 0.5;
        }
        if (onoff == 1)
        {
            ashake = shakeamt;
            if (shakeamt > 0)
            {
                shakeamt -= 1;
            }
            onoff = 1.5;
        }
    }
    draw_sprite_ext(sprite_index, image_index, x + xoff + ashake, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    if (sprite_index == spr_flowery_wind && image_index > 0)
    {
        image_index += 0.25;
    }
    if (sprite_index == spr_flowery_wind && image_index >= 8)
    {
        image_index = 0;
    }
    if (sprite_index == spr_flowery_condescend && image_index > 5.5)
    {
        state = 0;
        image_index = 0;
    }
    if (sprite_index == spr_flowery_kiss && image_index > 3.5)
    {
        state = 0;
        image_index = 0;
        image_speed = 0;
    }
}
else if ((state == 3 && hurttimer >= 0) || force_hurt_sprite == true || global.monsterhp[myself] <= (global.monstermaxhp[myself] * 0.99))
{
    draw_sprite_ext(hurtsprite, 0, x + shakex + hurtspriteoffx, y + hurtspriteoffy, 2, 2, 0, image_blend, 1);
    if (green_and_orange_enter == 2 && orange_adjust_con == 0)
    {
        orange_marker.y += 14;
        orange_adjust_con = 1;
    }
}
else
{
    if (floating)
    {
        y = ystart + (sin(float_siner * 0.33) * 5);
    }
    scr_enemy_drawidle_generic(image_speed);
}
if (becomeflash == 0)
{
    flash = 0;
}
becomeflash = 0;
xoff = 0;
animsiner += 1;
if (blown == 1)
{
    image_xscale = 2;
}
if (image_xscale < 2)
{
    xoff = (originalwidth - sprite_width) / 2;
}
blowanimtimer--;
if (blowanimtimer > 6)
{
    if (onoff == 2)
    {
        onoff = 0;
    }
    if (onoff == 1.5)
    {
        onoff = 2;
    }
    if (onoff == 0.5)
    {
        onoff = 1;
    }
    if (onoff == 0)
    {
        ashake = -shakeamt;
        onoff = 0.5;
    }
    if (onoff == 1)
    {
        ashake = shakeamt;
        if (shakeamt > 0)
        {
            shakeamt -= 1;
        }
        onoff = 1.5;
    }
}
if (scr_debug())
{
    if (keyboard_check_pressed(vk_end))
    {
        draw_test = !draw_test;
        scr_debug_clear_all();
    }
}
if (draw_test)
{
    if (scr_debug() && !i_ex(obj_debug_orangeheartcontroller))
    {
        draw_set_font(fnt_main);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        draw_text(camerax() + 320, cameray() + 20, "<-ctrl-   " + _category + "  -alt->");
        if (pattern_category)
        {
            for (var a = 0; a < category_size; a++)
            {
                draw_set_color(c_gray);
                if ((pattern_test % 10) == a)
                {
                    draw_set_color(c_white);
                }
                draw_text(camerax() + 240 + (20 * a), cameray() + 40, string(a + 1));
            }
        }
        draw_set_valign(fa_top);
        draw_set_halign(fa_center);
        draw_text(camerax() + (camerawidth() / 2), cameray() + 26, "Phase: " + string(phase));
        draw_text(camerax() + (camerawidth() / 2), cameray() + 39, "P to skip phase");
        draw_set_halign(fa_left);
    }
}
if (floating)
{
    float_siner += 0.25;
}
