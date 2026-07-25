for (var i = 0; i < 3; i += 1)
{
    j = irandom_range(i, 3);
    temp = rand_array[i];
    rand_array[i] = rand_array[j];
    rand_array[j] = temp;
}
if (phase == 2)
{
    global.canact[myself][1] = 1;
    global.actname[myself][1] = stringsetloc("BlowAway", "obj_flowery_enemy_slash_Other_10_gml_21_0");
    global.actactor[myself][1] = 1;
    global.actdesc[myself][1] = stringsetloc("Mash for#Mercy", "obj_flowery_enemy_slash_Other_10_gml_23_0");
    global.actcost[myself][1] = 160;
    global.canact[myself][2] = 1;
    global.actname[myself][2] = stringsetloc("BlowAwayZ", "obj_flowery_enemy_slash_Other_10_gml_27_0");
    global.actdesc[myself][2] = stringsetloc("Mash for#Mercy", "obj_flowery_enemy_slash_Other_10_gml_28_0");
    global.actactor[myself][2] = 4;
    global.actcost[myself][2] = 125;
}
if (phase == 3)
{
    global.canact[myself][1] = 1;
    global.actname[myself][1] = stringsetloc("Spin", "obj_flowery_enemy_slash_Other_10_gml_35_0_b");
    global.actdesc[myself][1] = stringsetloc("5% Mercy", "obj_flowery_enemy_slash_Other_10_gml_36_0_b");
    global.actactor[myself][1] = 0;
    global.actcost[myself][1] = 200;
    global.canact[myself][2] = 1;
    global.actname[myself][2] = stringsetloc("SpinZ", "obj_flowery_enemy_slash_Other_10_gml_41_0_b");
    global.actdesc[myself][2] = stringsetloc("5% Mercy", "obj_flowery_enemy_slash_Other_10_gml_42_0_b");
    global.actactor[myself][2] = 4;
    global.actcost[myself][2] = 160;
}
if (phase == 4)
{
    global.canact[myself][1] = 1;
    global.actname[myself][1] = stringsetloc("Praise", "obj_flowery_enemy_slash_Other_10_gml_49_0");
    global.actdesc[myself][1] = stringsetloc("5% Mercy", "obj_flowery_enemy_slash_Other_10_gml_50_0");
    global.actactor[myself][1] = 0;
    global.actcost[myself][1] = 200;
    global.canact[myself][2] = 1;
    global.actname[myself][2] = stringsetloc("PraiseZ", "obj_flowery_enemy_slash_Other_10_gml_55_0");
    global.actdesc[myself][2] = stringsetloc("5% Mercy", "obj_flowery_enemy_slash_Other_10_gml_56_0");
    global.actactor[myself][2] = 4;
    global.actcost[myself][2] = 160;
}
if (phase == 5)
{
    global.actname[myself][1] = stringsetloc("Justice", "obj_yellow_enemy_slash_Create_0_gml_312_0");
    global.actdesc[myself][1] = stringsetloc("Begin#the trial.", "obj_flowery_enemy_slash_Other_10_gml_143_0");
    global.actcost[myself][1] = 250;
    global.actactor[myself][1] = 0;
    if (global.hp[2] > 0 && global.hp[3] <= 0)
    {
        global.actactor[myself][1] = 2;
    }
    if (global.hp[2] <= 0 && global.hp[3] > 0)
    {
        global.actactor[myself][1] = 3;
    }
    if (global.hp[2] > 0 && global.hp[3] > 0)
    {
        global.actactor[myself][1] = 4;
    }
    global.actname[myself][2] = "";
    global.canact[myself][2] = 0;
    global.actactor[myself][2] = 0;
    global.actname[myself][3] = "";
    global.canact[myself][3] = 0;
    global.actactor[myself][3] = 0;
    global.actname[myself][4] = "";
    global.canact[myself][4] = 0;
    global.actactor[myself][4] = 0;
    global.actname[myself][5] = "";
    global.canact[myself][5] = 0;
    global.actactor[myself][5] = 0;
}
if (phase == 6)
{
    global.actname[myself][1] = stringsetloc("SusiesIdea", "obj_flowery_enemy_slash_Other_10_gml_82_0");
    global.actdesc[myself][1] = stringsetloc("???", "obj_flowery_enemy_slash_Other_10_gml_83_0");
    global.actcost[myself][1] = 120;
    global.actactor[myself][1] = 2;
}
scr_spellmenu_setup();
