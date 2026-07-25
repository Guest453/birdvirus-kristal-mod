if (i_ex(obj_heart))
{
    x_offset = obj_heart.x_offset;
}
if (speed == 0)
{
    instance_destroy();
    exit;
}
create += 1;
var a = scr_afterimage_fog(undefined, choose(65535, 35327), 2);
with (a)
{
    depth = other.depth + 1;
    x = other.x + other.x_offset;
    image_yscale = sign(other.image_yscale) * 2;
}
create = -1;
