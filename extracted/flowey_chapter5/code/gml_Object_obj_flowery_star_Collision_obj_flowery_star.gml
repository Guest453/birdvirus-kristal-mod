if ((vspeed > 0 && other.vspeed < 0) || (vspeed < 0 && other.vspeed > 0))
{
    motion_add(point_direction(x, other.y, x, y), 0.5);
}
