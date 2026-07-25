if (i_ex(obj_heart))
{
    x_offset = obj_heart.x_offset;
}
while ((x - obj_heart.x) < 160)
{
    x += 1;
}
while ((x - obj_heart.x) > 240 && obj_heart.x > obj_heart.dash_fail_x)
{
    x -= 1;
}
if (action == 0)
{
    var newy = (obj_pathbox.y + 16) - (sprite_height / 2);
    y = scr_approach(y, newy, 4);
    x = scr_approach(x, camerawidth() - 160, 4);
    if (y == newy)
    {
        action = 1;
        xx = x;
        yy = y;
    }
}
if (action == 1)
{
    counter += 0.1;
    x += (((xx + (sin(counter) * 32) + (cos(20 + counter) * 16)) - x) * 0.1);
    y += (((yy + (cos(10 + counter) * 32) + (sin(10 + counter) * 16)) - y) * 0.1);
}
timer += 1;
if (action == 1)
{
    if (timer > 30)
    {
        action = 2;
        timer = 0;
        alpha = 0;
        reload = 0;
        scale = 2;
        sprite_index = spr_flowery_pose_point_cooler;
    }
}
if (action == 2)
{
    alpha += 0.05;
    scale -= 0.1;
    if (alpha >= 1)
    {
        if (timer > 5)
        {
            reload += 1;
            scale = 1;
            var vs = -16;
            for (i = 0; i < 5; i++)
            {
                var o = instance_create(x + spawnx, y + spawny, obj_flowery_bullet);
                o.vspeed = vs;
                o.hspeed = -5;
                vs += 8;
            }
            timer = 0;
        }
        if (reload == 5)
        {
            timer = 0;
            action = 3;
            alpha = 0;
        }
    }
}
if (action == 3)
{
    if (timer == 10)
    {
        sprite_index = spr_flowery_shrug_downleft;
    }
    if (timer > 30)
    {
        timer = 0;
        action = 0;
    }
}
