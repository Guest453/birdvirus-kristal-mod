event_inherited();
scr_bullet_init();
destroyonhit = false;
battle_timer = 0;
timer = 0;
alt_timer = 0;
siner = 0;
con = 0;
orangeheartControlled = false;
waittime = 30;
x_anchor = x;
fist_y = y;
didrona = false;
stopthat = false;
bullet_timer = -1;
just_kidding = false;
jk_counter = choose(-1, -2);
kidding_x = x;
can_kidding = false;
intro_timer = 0;
intro_over = false;
final_list = ds_list_create();
damage_flash = false;
ronawait = 0;
hittimer = 6;
mode = 0;
difficulty = 0;
do_bullets = false;
attack_speed = 20;
attack_speed_jk = 20;
attack_speed_limit = 36;
attack_speed_change = 3;
for_the_fans_bug = false;
orange_dopple = -4;
appearance = 0;
tag_counter = 0;
current_decoy = -4;
sprite_index = obj_flowery_enemy.thissprite;
image_index = obj_flowery_enemy.siner;
image_speed = obj_flowery_enemy.image_speed;
x = obj_flowery_enemy.x;
y = obj_flowery_enemy.y;
bbox = 
{
    x1: 0,
    x2: 40,
    y1: 40,
    y2: 80
};
fogalf = 0;
fogcol = 16777215;
remx = x;
remy = y;
scr_size(2, 2);
if (i_ex(obj_flowery_enemy))
{
    target = obj_flowery_enemy.target;
    damage = obj_flowery_enemy.damage;
}

tag_in = function()
{
    tag_counter = 1;
    var _x = x;
    var _y = y;
    var _ox = orange_dopple.x;
    var _oy = orange_dopple.y;
    x = _ox;
    y = _oy;
    orange_dopple.x = _x;
    orange_dopple.y = _y;
    if (appearance == 0)
    {
        orange_dopple.sprite_index = spr_flowery_idle;
        appearance = 1;
        bbox.x1 = x;
        bbox.x2 = x + 40;
        bbox.y1 = y - 40;
        bbox.y2 = y + 40;
    }
    else
    {
        orange_dopple.sprite_index = spr_orange_animepunch_finished_cent;
        orange_dopple.image_speed = 1/3;
        appearance = 0;
        bbox.x1 = x;
        bbox.x2 = x + 40;
        bbox.y1 = y + 40;
        bbox.y2 = y + 80;
    }
};

do_hit_event_for_the_fans = function()
{
    last_hit_x = mean(x + 20, obj_orangeheart.x + 10);
    last_hit_y = mean(y + sprite_get_height(sprite_index), obj_orangeheart.y + 10);
    with (instance_create(last_hit_x, last_hit_y, obj_marker))
    {
        sprite_index = spr_thrash_slash;
        image_speed = 0;
        image_angle = choose(5 + random(25), -5 - random(25));
        image_alpha = 0.8;
        image_xscale = 0.65;
        image_yscale = 6;
        image_yscale *= 2;
        image_xscale *= 2;
        scr_script_delayed(scr_lerpvar, 38, "image_yscale", image_yscale, 0, 2);
        scr_doom(id, 40);
    }
    with (instance_create(last_hit_x, last_hit_y, obj_marker))
    {
        sprite_index = spr_explosive_shockwave;
        image_speed = 0;
        image_angle = 0;
        image_alpha = 0.8;
        image_xscale = 2;
        image_yscale = 2;
        scr_script_delayed(scr_lerpvar, 38, "image_xscale", 2, 0, 2);
        scr_script_delayed(scr_lerpvar, 38, "image_yscale", 2, 0, 2);
        scr_doom(id, 40);
    }
    with (scr_afterimage())
    {
        visible = false;
        scr_script_delayed(scr_shakescreen, 40, 10);
        depth = other.depth - 1;
        sprite_index = spr_explosive_shockwave;
        image_index = 2;
        image_xscale = 2.5;
        image_yscale = 0.75;
        image_speed = 0;
        image_angle = choose(90, 270);
        x = mean(x + 20, obj_orangeheart.x + 10);
        y = mean(y + 70, obj_orangeheart.y + 10);
        image_alpha = 0.85;
        fadeSpeed = 0;
        orangeheartControlled = true;
        daddy = other.id;
        scr_script_delayed(scr_lerpvar, 40, "image_alpha", 0.85, 0, 6);
        scr_script_delayed(scr_lerpvar, 40, "image_index", 2, 5, 6);
        scr_script_delayed(scr_lerpvar, 40, "image_xscale", 2.5, 6, 6);
        scr_script_delayed(scr_lerpvar, 40, "image_yscale", 0.75, 1.5, 6);
        scr_var_delayed("visible", true, 40);
    }
    with (scr_afterimage())
    {
        visible = false;
        scr_shakescreen();
        depth = other.depth - 1;
        sprite_index = spr_explosive_shockwave;
        image_index = 2;
        image_xscale = 2.5;
        image_yscale = 0.75;
        image_speed = 0;
        image_angle = choose(90, 270);
        x = mean(x + 20, obj_orangeheart.x + 10);
        y = mean(y + 70, obj_orangeheart.y + 10);
        image_alpha = 0.85;
        fadeSpeed = 0;
        orangeheartControlled = true;
        daddy = other.id;
        scr_script_delayed(scr_lerpvar, 40, "image_alpha", 0.85, 0, 12);
        scr_script_delayed(scr_lerpvar, 40, "image_index", 2, 5, 12);
        scr_script_delayed(scr_lerpvar, 40, "image_xscale", 2.5, 6, 12);
        scr_script_delayed(scr_lerpvar, 40, "image_yscale", 0.75, 1.5, 12);
        scr_var_delayed("hspeed", 12, 40);
        scr_var_delayed("visible", true, 40);
    }
    scr_script_delayed(function()
    {
        for (var a = 0; a < 6; a++)
        {
            with (instance_create(last_hit_x, last_hit_y, obj_marker))
            {
                sprite_index = spr_whitepixel;
                if (irandom(2))
                {
                    image_yscale = 2;
                    image_xscale = 2;
                }
                else
                {
                    image_yscale = 4;
                    image_xscale = 4;
                }
                direction = irandom(360);
                speed = 12 + random(12);
                hspeed *= 0.35;
                image_angle = direction;
                image_alpha = 0.85;
                x += (hspeed * 2);
                y += (vspeed * 2);
                hspeed += 6;
                my_time = 40 + irandom(16);
                if (image_xscale > 2)
                {
                    scr_lerpvar("image_xscale", image_xscale, 2, my_time - 2);
                }
                scr_lerpvar("speed", speed, random(2), my_time - irandom(2), 2, "out");
                scr_lerpvar("image_alpha", 0.85, 0, my_time);
                orangeheartControlled = true;
                scr_doom(id, my_time);
            }
        }
    }, 40);
};
