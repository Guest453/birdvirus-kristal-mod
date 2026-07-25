if (i_ex(obj_flowery_enemy))
{
    target = obj_flowery_enemy.target;
    damage = obj_flowery_enemy.damage;
}
if (image_blend == c_aqua && obj_heart.dash_h > 2)
{
    event_user(1);
}
else if (active == 1)
{
    if (target != 3)
    {
        scr_damage();
    }
    if (target == 3)
    {
        scr_damage_all();
    }
    if (destroyonhit == 1)
    {
        instance_destroy();
    }
}
