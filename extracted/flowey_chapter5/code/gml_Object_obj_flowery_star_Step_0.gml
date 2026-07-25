event_inherited();
timer -= 1;
if (i_ex(obj_heart))
{
    x_offset = obj_heart.x_offset;
}
if (phase == 0)
{
    if (x > (camerax() + camerawidth() + abs(x_offset)))
    {
        instance_destroy();
    }
}
