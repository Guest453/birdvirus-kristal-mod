scr_84_set_draw_font("mainbig");
image_xscale = string_width(act_text);
image_yscale = string_height(act_text) / 2;
if (con == 0)
{
    y -= 4;
    if (y < (cameray() + 330))
    {
        y += 150;
    }
}
if (con == 2)
{
    timer++;
    if (timer == 1)
    {
        x += 80;
    }
    if (timer > 1)
    {
        x = lerp(x, xstart, 0.3);
    }
}
