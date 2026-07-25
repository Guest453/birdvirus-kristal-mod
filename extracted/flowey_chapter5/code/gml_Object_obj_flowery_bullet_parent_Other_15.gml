if (active == 1)
{
    if (i_ex(obj_flowery_enemy))
    {
        target = obj_flowery_enemy.target;
        damage = obj_flowery_enemy.damage;
    }
    with (obj_aqua_enemy)
    {
        if (fight_type == "solo")
        {
            if (myattackchoice == 0)
            {
                attack_chain_hits++;
            }
            if (myattackchoice == 1)
            {
                attack_fan_hits++;
            }
            if (myattackchoice == 2)
            {
                attack_petal_hits++;
            }
            if (myattackchoice == 3)
            {
                attack_omega_hits++;
            }
        }
        if (fight_type == "seth")
        {
            phasehit = true;
        }
    }
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
