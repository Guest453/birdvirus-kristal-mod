with (obj_flowery_act_menu_choice)
{
    con = 1;
    image_blend = c_red;
    if (correct_answer == true)
    {
        image_blend = c_lime;
    }
}
other.con = 2;
if (other.correct_answer == true)
{
    snd_play(snd_coin);
    with (obj_flowery_enemy)
    {
        overwrite_correct = 2;
    }
}
else
{
    snd_play(snd_cantselect);
    with (obj_flowery_enemy)
    {
        overwrite_correct = 1;
    }
}
with (obj_flowery_act_menu_controller)
{
    con = 2;
}
