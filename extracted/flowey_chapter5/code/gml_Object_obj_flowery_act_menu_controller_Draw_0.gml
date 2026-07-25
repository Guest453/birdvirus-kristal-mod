if (button2_p() && i_ex(obj_flowery_act_menu_heart) && obj_flowery_act_menu_heart.chargecon == 0 && con != 2)
{
    with (obj_battlecontroller)
    {
        global.bmenucoord[9][global.charturn] = 0;
        global.tensionselect = 0;
        global.bmenuno = 11;
        twobuffer = 1;
        movenoise = 1;
    }
    with (obj_flowery_act_menu_heart)
    {
        instance_destroy();
    }
    with (obj_flowery_act_menu_choice)
    {
        instance_destroy();
    }
    instance_destroy();
}
if (con == 0 && !i_ex(obj_moveheart) && i_ex(obj_flowery_enemy))
{
    act_choice[0] = instance_create(camerax() + 370, (cameray() + 400) - 60, obj_flowery_act_menu_choice);
    act_choice[1] = instance_create(camerax() + 370, (cameray() + 400) - 30, obj_flowery_act_menu_choice);
    act_choice[2] = instance_create(camerax() + 370, cameray() + 400, obj_flowery_act_menu_choice);
    act_choice[3] = instance_create(camerax() + 370, cameray() + 400 + 30, obj_flowery_act_menu_choice);
    act_choice[4] = instance_create(camerax() + 370, cameray() + 400 + 60, obj_flowery_act_menu_choice);
    if (obj_flowery_enemy.phase == 2)
    {
        act_choice[0].act_text = "BlowAwayZ";
        act_choice[0].correct_answer = true;
        act_choice[1].act_text = "BlowAwayF";
        act_choice[2].act_text = "BlowAwayF";
        act_choice[3].act_text = "BlowAwayF";
        act_choice[4].act_text = "BlowAwayF";
    }
    if (obj_flowery_enemy.phase == 3)
    {
        act_choice[0].act_text = "SpinF";
        act_choice[1].act_text = "SpinF";
        act_choice[2].act_text = "SpinZ";
        act_choice[2].correct_answer = true;
        act_choice[3].act_text = "SpinF";
        act_choice[4].act_text = "SpinF";
    }
    if (obj_flowery_enemy.phase == 4)
    {
        act_choice[0].act_text = "PraiseF";
        act_choice[1].act_text = "PraiseF";
        act_choice[2].act_text = "PraiseF";
        act_choice[3].act_text = "PraiseF";
        act_choice[4].act_text = "PraiseZ";
        act_choice[4].correct_answer = true;
    }
    con = 1;
}
if (con == 2)
{
    timer++;
    if (timer == 20)
    {
        with (obj_battlecontroller)
        {
            onebuffer = 2;
            selnoise = 1;
            global.bmenuno = 0;
            global.actingchoice[global.charturn] = 2;
            global.tensionselect = 0;
            scr_actselect(obj_flowery_enemy.myself, 2);
            global.bmenucoord[9][global.charturn] = 0;
            scr_endturn();
        }
        with (obj_flowery_act_menu_heart)
        {
            instance_destroy();
        }
        with (obj_flowery_act_menu_choice)
        {
            instance_destroy();
        }
        instance_destroy();
    }
}
if (!surface_exists(my_surface))
{
    my_surface = surface_create(300, 200);
}
surface_set_target(my_surface);
draw_clear_alpha(c_black, 0);
scr_84_set_draw_font("mainbig");
with (obj_flowery_act_menu_choice)
{
    if (con == 0 || con == 2)
    {
        draw_text_ext_transformed_color(x - camerax() - 190, y - cameray() - 367 - (string_height(act_text) / 4), act_text, 9999, 9999, 1, 1, 0, image_blend, image_blend, image_blend, image_blend, 1);
    }
}
surface_reset_target();
draw_surface(my_surface, camerax() + 190, cameray() + 366);
