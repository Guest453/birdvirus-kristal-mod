depth = obj_growtangle.depth - 1;
scrolling = true;
do_lines = 0.25;
check_for_failure = false;
do_chase = true;
draw_test = true;
difficulty = 0;
open_chase_difficulty = 0;
wall_tutorial_counter = 0;
wall_counter = 0;
tutorial_clamp = false;
individualism = irandom(100000);
timer_adjust = 0;
cactus_chance = 0;
last_bamboo_y = scr_get_box(5);
last_pad = scr_get_box(5);
attack_speed = 20;
do_bullets = false;
orange_dopple = false;
old_box = -4;
new_box = -4;
if (i_ex(obj_orangeheart))
{
    heart = 1020;
}
else
{
    heart = instance_create((camerax() + (room_width / 2)) - 160, cameray() + (room_height / 2), obj_orangeheart);
}
heart.depth = depth - 10;
fakecamx = 0;
fakecamxspeed = -16;
fakecamxspeedbase = -16;
fakecamxspeedbase_original = -16;
fakecamxspeedadditional = 0;
fakecamxspeeddefault = fakecamxspeed;
hitstop = 0;
scale_factor = 0;
_counter = 0;
scr_lerpvar("scale_factor", 0, 1.1, 12, 1, "out");
scr_script_delayed(scr_lerpvar, 13, "scale_factor", 1.1, 1, 4, 1, "in");
if (i_ex(obj_flowery_enemy) && obj_flowery_enemy.introcon < 3)
{
}
else
{
    with (obj_growtangle)
    {
        scr_lerpvar("image_yscale", image_yscale, 3.3, 12, 1, "out");
        scr_script_delayed(scr_lerpvar, 13, "image_yscale", 3.3, 3, 4, 1, "in");
        scr_lerpvar("maxyscale", maxyscale, 3, 12, 1, "out");
    }
}
boxtop = cameray() + 80;
boxbot = boxtop + 180;
attacktype = 5;
lastpos = 0;

genpillar = function(arg0 = 80, arg1 = 0, arg2 = 1, arg3 = 0)
{
    var defaultwalllength = 40;
    var xpos = camerax() + 640 + arg0;
    var boxmid = (boxtop + boxbot) / 2;
    var bluewall = instance_create(xpos, (boxmid + arg1) - ((arg2 * defaultwalllength) / 2), obj_orangeheart_wall);
    with (bluewall)
    {
        image_yscale = defaultwalllength * arg2;
        breakable = 1;
    }
    var topwall = instance_create(xpos, boxtop, obj_orangeheart_wall);
    with (topwall)
    {
        image_yscale = abs(other.boxtop - bluewall.bbox_top);
    }
    var botwall = instance_create(xpos, bluewall.bbox_bottom, obj_orangeheart_wall);
    with (botwall)
    {
        image_yscale = other.boxbot - bluewall.bbox_bottom;
    }
    if (arg3 == 1)
    {
        with (bluewall)
        {
            instance_destroy();
        }
    }
};

makeBounceBall = function(arg0 = camerax() + 640 + 120, arg1 = (boxtop + boxbot) / 2, arg2 = 60)
{
    with (instance_create(arg0, arg1, obj_orangeheart_ball))
    {
        scr_sizeexact(arg2, arg2);
        bounceable = true;
        breakable = false;
        depth += 100;
    }
};

wall_create = function(arg0, arg1, arg2 = 16, arg3 = 240, arg4 = 0, arg5 = 240, arg6 = false)
{
    if (arg5 == 0 || arg5 == arg3)
    {
        var wall = instance_create(arg0, arg1 - (arg3 * 0.5), obj_orangeheart_wall);
        with (wall)
        {
            bamboo = true;
            do_bullets = arg6;
            if (arg5 == arg3)
            {
                breakable = 1;
            }
            depth = other.depth - 20;
            scr_size(arg2, arg3);
            var b = 0;
            var a = irandom(20);
            while (a < (image_yscale - 20))
            {
                if (!irandom(2))
                {
                    var c = a + irandom(38);
                    if (c < (image_yscale - 20))
                    {
                        leaves[b] = [c, choose(-1, 1)];
                        b++;
                    }
                }
                a += 40;
            }
        }
        return wall;
    }
    var true_midpoint = clamp(arg4, arg5 * 0.5, arg3 - (arg5 * 0.5));
    var a1 = true_midpoint - (arg5 * 0.5);
    var a2 = true_midpoint + (arg5 * 0.5);
    var _l1 = a1;
    var _l2 = a2 - a1;
    var _l3 = arg3 - a2;
    if (_l1 != 0)
    {
        with (instance_create(arg0, arg1 - (arg3 * 0.5), obj_orangeheart_wall))
        {
            bamboo = true;
            depth = other.depth - 20;
            scr_size(arg2, _l1);
            var b = 0;
            var a = irandom(20);
            while (a < image_yscale)
            {
                if (!irandom(2))
                {
                    var c = a + irandom(38);
                    if (c < image_yscale)
                    {
                        leaves[b] = [c, choose(-1, 1)];
                        b++;
                    }
                }
                a += 40;
            }
        }
    }
    with (instance_create(arg0, (arg1 - (arg3 * 0.5)) + a1, obj_orangeheart_wall))
    {
        bamboo = true;
        bamboo_counter = a1;
        depth = other.depth - 20;
        scr_size(arg2, _l2);
        breakable = true;
        do_bullets = arg6;
        var b = 0;
        var a = irandom(20);
        while (a < image_yscale)
        {
            if (!irandom(2))
            {
                var c = a + irandom(38);
                if (c < image_yscale)
                {
                    leaves[b] = [c, choose(-1, 1)];
                    b++;
                }
            }
            a += 40;
        }
    }
    if (_l2 != 0)
    {
        with (instance_create(arg0, (arg1 - (arg3 * 0.5)) + a2, obj_orangeheart_wall))
        {
            bamboo = true;
            bamboo_counter = a2;
            depth = other.depth - 20;
            scr_size(arg2, _l3);
            var b = 0;
            var a = irandom(20);
            while (a < (image_yscale - 20))
            {
                if (!irandom(2))
                {
                    var c = a + irandom(38);
                    if (c < (image_yscale - 20))
                    {
                        leaves[b] = [c, choose(-1, 1)];
                        b++;
                    }
                }
                a += 40;
            }
            return id;
        }
    }
};

timer = 0;
siner = 0;
script_timer = 0;
timer_goal = 30;
if (i_ex(obj_flowery_enemy))
{
    target = obj_flowery_enemy.target;
    damage = obj_flowery_enemy.damage;
}

queue_box = function(arg0, arg1, arg2)
{
    old_box = new_box;
    if (old_box == -4)
    {
        new_box = instance_create(camerax() + 750, arg1, obj_orangeheart_square);
    }
    else
    {
        new_box = instance_create(old_box.x + arg0, arg1, obj_orangeheart_square);
    }
    new_box.orangeheartControlled = true;
    return new_box;
};

my_surface = -1;
spotlight = 0;
