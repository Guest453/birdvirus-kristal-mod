event_inherited();
if (i_ex(obj_heart))
{
    x_offset = obj_heart.x_offset;
}
image_yscale += ((ys - image_yscale) * 0.02);
ys += ((side - ys) * 0.1);
timer += 1;
if (timer == 2)
{
    var a = scr_afterimage_fog(undefined, 12632256, 5);
    with (a)
    {
        depth = other.depth + 1;
        x = other.x + other.x_offset;
    }
    timer = 0;
}
if (phase == 0)
{
    if (x > (camerax() + camerawidth() + abs(x_offset)))
    {
    }
}
