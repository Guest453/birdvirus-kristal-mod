type = 132;
btimer = 99;
timermax = 12;
damage = -1;
grazepoints = -1;
timepoints = -1;
inv = -1;
grazed = -1;
grazetimer = -1;
element = "none";
target = -1;
ratio = 1;
if (scr_monsterpop() == 2)
{
    ratio = 1.6;
}
if (scr_monsterpop() == 3)
{
    ratio = 2.3;
}
side = 1;
difficulty = 0;
made = 0;
special = 0;
roundcount = 0;
init = 0;
sameattack = 0;
sameattacker = 0;
miny = 999;
maxy = 999;
maxx = 999;
miny = 999;
creator = 0;
save_kris_hp = global.hp[1];
save_susie_hp = global.hp[2];
save_kralsei_hp = global.hp[3];
if (!variable_global_exists("__debugHide"))
{
    global.__debugHide = 0;
}
hide = 1;
hideamt = global.__debugHide;
