if (!i_ex(obj_debug_orangeheartcontroller))
{
    exit;
}
siner++;
battle_timer++;
if (damage_flash)
{
    damage_flash--;
}
if (mode == 0)
{
    if (con == 0)
    {
        orangeheartControlled = false;
        timer++;
        if (didrona == 1)
        {
            hspeed = scr_approach(hspeed, 0, 0.5);
        }
        if (timer == waittime)
        {
            if (orange_dopple != -4 && (!irandom(1) || tag_counter >= 2) && tag_counter)
            {
                tag_in();
            }
            else
            {
                tag_counter++;
            }
            if (!didrona)
            {
                hspeed = 8;
                didrona++;
            }
            if (appearance == 1)
            {
                sprite_index = spr_orange_ready_fight;
            }
            else
            {
                sprite_index = choose(spr_flowery_jump_left, spr_flowery_crouch_left, spr_flowery_punch_windup);
            }
            if (can_kidding)
            {
                if (orange_dopple != -4)
                {
                    if ((jk_counter >= 0 && !irandom(2)) || jk_counter == 3)
                    {
                        just_kidding = true;
                        jk_counter = -99;
                    }
                    else
                    {
                        just_kidding = false;
                        jk_counter++;
                    }
                }
            }
            var ronas;
            if (just_kidding)
            {
                ronas = [[40, round(18)]];
            }
            else if (appearance == 1)
            {
                ronas = [[703, round(18)], [260, round(19.2)]];
            }
            else
            {
                ronas = [[150, round(9)], [752, round(9.6)], [68, round(9.9)], [12, round(10.5)]];
            }
            var thisrona = irandom(array_length(ronas) - 1);
            if (just_kidding)
            {
                snd_play_flowery(ronas[thisrona][0], 0.775, 1);
            }
            else if (appearance == 1)
            {
                snd_play_flowery(ronas[thisrona][0], 0.775, 1);
            }
            else
            {
                snd_play_flowery(ronas[thisrona][0], 0.65, 1);
            }
            ronawait = ronas[thisrona][1];
            fogcol = 16777215;
            fogalf = 0.8;
            with (scr_lerpvar("fogalf", 0.8, 0, 8))
            {
                fogalfcontroller = true;
            }
        }
        if (timer == (waittime + ronawait))
        {
            didrona = 2;
            if (appearance == 1)
            {
                sprite_index = spr_orange_animepunch_finished;
            }
            else if (sprite_index == spr_flowery_punch_windup)
            {
                sprite_index = spr_flowery_puuunch_left;
                image_speed = 0.16666666666666666;
            }
            else if (sprite_index == spr_flowery_crouch_left)
            {
                sprite_index = spr_flowery_fair_left;
            }
            else
            {
                sprite_index = spr_flowery_shrug_downleft;
            }
            if (!just_kidding)
            {
                with (obj_lerpvar)
                {
                    if (variable_instance_exists(id, "fogalfcontroller"))
                    {
                        instance_destroy();
                    }
                }
                fogalf = 0.8;
                fogcol = 10045696;
            }
            con = 1;
            timer = 0;
            var lowtime = 8;
            if (difficulty == 0)
            {
                lowtime = 12;
            }
            if (difficulty >= 2)
            {
                lowtime = 4;
            }
            var hightime = 24;
            waittime = irandom_range(lowtime, hightime);
            if (just_kidding)
            {
                with (instance_create_depth(obj_flowery_enemy.green_marker.x, obj_flowery_enemy.green_marker.y, depth - 1, obj_marker))
                {
                    sprite_index = spr_green_shrug;
                    image_index = 0;
                    image_speed = 0;
                    image_xscale = 2;
                    image_yscale = 2;
                    direction = 180;
                    speed = 3;
                    scr_lerpvar("image_alpha", 1, 0, 20);
                    scr_doom(id, 20);
                }
                kidding_x = x;
                bullet_timer = 0;
                attack_speed_jk = attack_speed + 8;
            }
        }
    }
    var playerhit = false;
    if (con == 1)
    {
        if (just_kidding)
        {
            if (attack_speed_jk != -1)
            {
                x -= attack_speed_jk;
                attack_speed_jk *= 0.725;
                if (attack_speed_jk <= 0.1)
                {
                    scr_lerpvar("x", x, kidding_x, 12, 1, "out");
                    if (appearance == 1)
                    {
                        sprite_index = spr_orange_animepunch_finished_cent;
                        image_speed = 1/3;
                    }
                    else
                    {
                        sprite_index = spr_flowery_idle;
                    }
                    attack_speed_jk = -1;
                }
            }
            if (bullet_timer >= 30)
            {
                bullet_timer = -1;
                con = 0;
            }
        }
        else
        {
            x -= attack_speed;
        }
        if (!just_kidding)
        {
            if (appearance == 1)
            {
                y = lerp(y, obj_orangeheart.y, 0.4);
            }
            else if (sprite_index == spr_flowery_puuunch_left)
            {
                y = lerp(y, obj_orangeheart.y - 40, 0.4);
            }
            else
            {
                y = lerp(y, obj_orangeheart.y - 60, 0.4);
            }
        }
        if (instance_exists(collision_rectangle(bbox.x1, bbox.y1, bbox.x2, bbox.y2, obj_orangeheart, false, false)))
        {
            orangeheartControlled = true;
            if (obj_orangeheart.dashing)
            {
                attack_speed = scr_approach(attack_speed, attack_speed_limit, attack_speed_change);
                x = obj_orangeheart.x + 20;
                if (i_ex(obj_flowery_enemy))
                {
                    scr_tensionheal(12 * obj_flowery_enemy.moar_tension);
                }
                do_hit_event();
                if (abs(obj_debug_orangeheartcontroller.fakecamxspeedadditional) > 13)
                {
                    do_hitstop(8);
                    hittimer = 8;
                }
                else
                {
                    do_hitstop(6);
                    hittimer = 6;
                }
                with (obj_orangeheart)
                {
                    dashstate = 0;
                    dashing = 0;
                    chargecon = 0;
                    heartcooldown = 0;
                    dashtimer = 0;
                    chargetimer = 0;
                }
                remx = x;
                remy = y;
                con = 4;
                timer = 0;
                snd_play(snd_swing);
                if (appearance)
                {
                    sprite_index = spr_orange_mad;
                }
                else
                {
                    sprite_index = spr_flowery_deflected;
                }
            }
            else
            {
                with (obj_orangeheart)
                {
                    hurt(other.id);
                }
                fogalf = 0;
                con = 2;
                playerhit = true;
            }
        }
    }
    if (con >= 1)
    {
        if (playerhit)
        {
            obj_orangeheart.shakeheart = 14;
            snd_play(snd_punchmed, 1, 0.75);
            if (!global.inv)
            {
                scr_shakescreen(32);
            }
            hspeed = 0;
            vspeed = 0;
            timer = -14;
            con = 0;
            var movetime = 18;
            hspeed = 18 + random(1.5);
            if ((y + 70) > scr_get_box(5))
            {
                vspeed = random_range(-5, -1);
            }
            else
            {
                vspeed = random_range(1, 5);
            }
            orangeheartControlled = false;
            friction = 0.65;
            if (appearance == 0)
            {
                if (sprite_index == spr_flowery_shrug_downleft)
                {
                    sprite_index = spr_flowery_shrug_spin;
                    image_speed = 0;
                    scr_lerpvar("image_index", 0, 8, 16, 0, "out");
                }
                else
                {
                    sprite_index = spr_flowery_deflected;
                }
            }
            else
            {
                sprite_index = spr_orange_mad;
                scr_var_delayed("sprite_index", 1704, 12);
            }
            with (obj_orangeheart)
            {
                if (audio_is_playing(loop_sound))
                {
                    snd_stop(loop_sound);
                }
                dashstate = 0;
                dashing = 0;
                chargecon = 0;
                heartcooldown = 0;
                dashtimer = 0;
                chargetimer = 0;
                scr_lerpvar("x", x, x - 80, 6, 1, "out");
                scr_script_delayed(scr_lerpvar, 6, "x", x - 80, x, 12, 1, "in");
                scr_lerpvar("image_angle", 0, 30, 6, 1, "out");
                scr_script_delayed(scr_lerpvar, 6, "image_angle", 30, 0, 12, 1, "in");
                for (var a = 0; a < 6; a++)
                {
                    with (instance_create((x + 10) - 40, y + 10, obj_marker))
                    {
                        sprite_index = spr_whitepixel;
                        image_blend = c_orange;
                        if (irandom(2))
                        {
                            image_yscale = 3;
                            image_xscale = 3;
                        }
                        else
                        {
                            image_yscale = 5;
                            image_xscale = 5;
                        }
                        direction = 135 + random(90);
                        speed = 1 + (3 * a);
                        hspeed *= 0.75;
                        vspeed *= 0.35;
                        image_angle = direction;
                        image_alpha = 0.85;
                        hspeed += 6;
                        my_time = 20 - (1 + (a * 3));
                        if (image_xscale > 2)
                        {
                            scr_lerpvar("image_xscale", image_xscale, 2, my_time - 2);
                        }
                        scr_lerpvar("image_alpha", 0.85, 0, my_time);
                        orangeheartControlled = true;
                        scr_doom(id, my_time);
                    }
                }
            }
        }
    }
    if (playerhit || (con == 4 && (timer + 1) >= hittimer))
    {
        if (battle_timer > 315 && global.turntimer > 5 && mode != 4)
        {
            global.turntimer = 5;
        }
    }
    if (con == 4)
    {
        orangeheartControlled = false;
        timer++;
        x = remx + random_range(-4, 4);
        y = remy + random_range(-4, 4);
        if (timer >= hittimer)
        {
            damage_flash = 8;
            snd_play(snd_punchheavythunder, undefined, 1.2);
            if (abs(obj_debug_orangeheartcontroller.fakecamxspeedadditional) > 13)
            {
                snd_play(snd_parry_fast_nodelay, 1, 1);
                if (i_ex(obj_flowery_enemy))
                {
                    scr_tensionheal(10 * obj_flowery_enemy.moar_tension);
                }
            }
            x = remx;
            y = remy;
            hspeed = 26 + abs(obj_debug_orangeheartcontroller.fakecamxspeedadditional * 0.41) + random(3);
            vspeed = random_range(-5, 5);
            friction = 2;
            timer = 0;
            con = 0;
            fogalf = 0;
            with (obj_debug_orangeheartcontroller)
            {
                fakecamxspeedbase += fakecamxspeedadditional;
                scr_lerpvar("fakecamxspeedbase", fakecamxspeedbase, fakecamxspeedbase - fakecamxspeedadditional, 25);
                fakecamxspeedadditional = 0;
            }
            if (appearance == 1)
            {
                timer = -10;
                var xloc = x + 34;
                var yloc = y;
                var _rand = random_range(-10, 10);
                with (instance_create(xloc, yloc, obj_orangeheart_bullet))
                {
                    graze = 0;
                    grazepoints = 10;
                    timepoints = 10;
                    orangeheartControlled = false;
                    targ_x = obj_orangeheart.x + 10;
                    targ_y = obj_orangeheart.y + 10;
                    curve = 0;
                    scr_lerpvar("curve", 0, pi, 40);
                    timer = 0;
                    sprite_index = spr_fcastle_glovebullet_overworld;
                    image_xscale = -0.75;
                    image_yscale = -0.75;
                    direction = _rand;
                    speed = 32;
                    updateimageangle = true;
                    scr_script_repeat(function()
                    {
                        timer++;
                        if ((timer % 2) == 0)
                        {
                            with (scr_afterimagefast())
                            {
                                fadeSpeed *= 5;
                            }
                        }
                        speed = 4 + (24 * (1 - sin(curve)));
                        direction += scr_anglechange(direction, point_direction(x, y, targ_x, targ_y), 15 * sin(curve));
                        image_angle = direction;
                    }, -1, 1);
                }
                _rand += random_range(5, 15);
                if (_rand >= 10)
                {
                    _rand -= 20;
                }
                with (instance_create(xloc, yloc, obj_orangeheart_bullet))
                {
                    graze = 0;
                    grazepoints = 10;
                    timepoints = 10;
                    orangeheartControlled = false;
                    targ_x = obj_orangeheart.x + 10;
                    targ_y = obj_orangeheart.y + 10 + 60 + irandom(105);
                    if (targ_y >= (scr_get_box(5) + 112.5))
                    {
                        targ_y -= 225;
                    }
                    curve = 0;
                    scr_lerpvar("curve", 0, pi, 40);
                    timer = 0;
                    sprite_index = spr_fcastle_glovebullet_overworld;
                    image_xscale = -0.75;
                    image_yscale = -0.75;
                    direction = _rand;
                    speed = 32;
                    updateimageangle = true;
                    scr_script_repeat(function()
                    {
                        timer++;
                        if ((timer % 2) == 0)
                        {
                            with (scr_afterimagefast())
                            {
                                fadeSpeed *= 5;
                            }
                        }
                        speed = 4 + (24 * (1 - sin(curve)));
                        direction += scr_anglechange(direction, point_direction(x, y, targ_x, targ_y), 15 * sin(curve));
                        image_angle = direction;
                    }, -1, 1);
                }
            }
            if (do_bullets)
            {
                var cnt = 1 + difficulty;
                var _rand = random_range(-4, 4);
                var _which = irandom(2);
                for (var i = 1; i < cnt; i++)
                {
                    var xloc = x + 34;
                    var yloc = y + 60;
                    with (instance_create(xloc, yloc, obj_orangeheart_wall))
                    {
                        orangeheartControlled = false;
                        sprite_index = spr_spinning_petal;
                        image_speed = 1;
                        image_xscale = 1.5;
                        image_yscale = 2;
                        draw_prev = true;
                        hsp = 16 + (i * 3);
                        fakehgrav = -0.75;
                        if (i == _which)
                        {
                            vsp = _rand + (i * 20 * choose(-1, 1));
                        }
                        else
                        {
                            vsp = _rand - (i * 20 * choose(-1, 1));
                        }
                        scr_lerpvar("vsp", vsp * 0.25, 0, 60);
                        inboundsonly = true;
                    }
                }
            }
        }
    }
    if (bullet_timer >= 0)
    {
        bullet_timer++;
        var _timer = global.time;
        var _multiplier = 2;
        if ((bullet_timer % 2) == 0)
        {
            _timer += 0.35;
        }
        else
        {
            _timer -= 0.35;
        }
        var _x = camerax() + 670 + (sin(_timer * 0.2 * _multiplier) * 15);
        var _y = scr_get_box(5) + (cos(_timer * 0.1 * _multiplier) * 120);
        if ((bullet_timer % 2) == 0)
        {
            with (instance_create(_x, _y, obj_orangeheart_bullet))
            {
                graze = 0;
                grazepoints = 10;
                timepoints = 10;
                depth = obj_orangeheart.depth - 1;
                sprite_index = spr_bullet_green_flame;
                image_index = irandom(2);
                image_speed = 0.5;
                scr_size(1.5, 1.5);
                direction = -cos(_timer * 0.4 * _multiplier) * 90;
                speed = 5;
                if ((other.bullet_timer % 4) == 0)
                {
                    scr_size(1.25, 1.25);
                }
                if ((other.bullet_timer % 4) < 2)
                {
                    speed -= 2.5;
                }
                vspeed *= 0.75;
                hspeed *= 0.25;
                hspeed += 1.5;
                gravity_direction = 155;
                gravity = 0.15;
                if (hspeed >= 7.75)
                {
                    instance_destroy();
                }
            }
        }
    }
}
if (!obj_debug_orangeheartcontroller.hitstop)
{
    if (mode == 1)
    {
        if (timer == 2)
        {
            if (difficulty == 0)
            {
                alt_timer = -35;
            }
            x_anchor = x + 24;
        }
        var _collision = -4;
        with (obj_orangeheart_bullet)
        {
            if (deflected)
            {
                var check_x = image_xscale;
                var check_y = image_yscale;
                mask_index = spr_pixel_2x;
                image_xscale = 32;
                image_yscale = 32;
                if (collision_rectangle(other.bbox.x1, other.bbox.y1, other.bbox.x2, other.bbox.y2, id, false, false))
                {
                    mask_index = sprite_index;
                    image_xscale = check_x;
                    image_yscale = check_y;
                    _collision = id;
                    break;
                }
                mask_index = sprite_index;
                image_xscale = check_x;
                image_yscale = check_y;
            }
        }
        if (i_ex(_collision) && con == 0)
        {
            con = 8;
            damage_flash = 12;
            sprite_index = spr_flowery_deflected;
            speed = 13;
            var _ow = snd_play_flowery(244, 0.5);
            audio_sound_set_track_position(_ow, 0.18);
            scr_shakescreen(8);
            snd_play(snd_rudebuster_hit);
            with (instance_create(x, _collision.y, obj_marker))
            {
                sprite_index = spr_explosive_shockwave;
                image_speed = 0;
                image_angle = 90;
                image_index = 2;
                image_xscale = 2.5;
                image_yscale = 0.75;
                scr_lerpvar("image_alpha", 0.85, 0, 6);
                scr_lerpvar("image_index", 2, 5, 6);
                scr_lerpvar("image_xscale", 2.5, 6, 6);
                scr_lerpvar("image_yscale", 0.75, 1.5, 6);
                scr_doom(id, 6);
            }
            for (var a = 0; a < 6; a++)
            {
                with (instance_create(x, _collision.y, obj_marker))
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
                    my_time = 8 + irandom(16);
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
            with (_collision)
            {
                instance_destroy();
            }
        }
        if (con)
        {
            con--;
            if (con == 0)
            {
                alt_timer = 12 + (3 * difficulty);
                scr_lerpvar("x", x, x_anchor, 20, 1, "in");
                image_speed = 0.16666666666666666;
            }
        }
        timer++;
        var _timer = global.time;
        var _multiplier = 1;
        if ((timer % 2) == 0)
        {
            _timer += 0.35;
        }
        else
        {
            _timer -= 0.35;
        }
        var _x = camerax() + 670 + (sin(_timer * 0.2 * _multiplier) * 15);
        var _y = scr_get_box(5) + (cos(_timer * 0.1 * _multiplier) * 120);
        if (timer == 15)
        {
            snd_play_flowery(40);
            fogalf = 0.8;
            with (scr_lerpvar("fogalf", 0.8, 0, 8))
            {
                fogalfcontroller = true;
            }
        }
        if (timer >= 30)
        {
            if (((timer % 2) == 0 && difficulty == 2) || ((timer % 3) == 0 && difficulty == 1) || ((timer % 4) == 0 && difficulty == 0))
            {
                with (instance_create(_x, _y, obj_orangeheart_bullet))
                {
                    depth = obj_orangeheart.depth - 1;
                    sprite_index = spr_bullet_green_flame;
                    image_index = irandom(2);
                    image_speed = 0.5;
                    scr_size(1.5, 1.5);
                    direction = -cos(_timer * 0.4 * _multiplier) * 90;
                    speed = 5;
                    if ((other.timer % 4) == 0)
                    {
                        scr_size(1.25, 1.25);
                    }
                    if ((other.timer % 4) < 2)
                    {
                        speed -= 2.5;
                    }
                    vspeed *= 0.75;
                    hspeed *= 0.25;
                    hspeed += 6;
                    gravity_direction = 155;
                    gravity = 0.15;
                    if (hspeed >= 7.75)
                    {
                        instance_destroy();
                    }
                }
            }
        }
        if (con == 0)
        {
            alt_timer++;
            if (alt_timer == 15)
            {
                sprite_index = spr_flowery_punch_windup;
                image_speed = 1/3;
                image_index = 0;
                speed = 8;
                scr_lerpvar("speed", speed, 0, 15);
                scr_lerpvar("y", y, y - 24, 15);
                with (orange_dopple)
                {
                    speed = 8;
                    scr_lerpvar("speed", speed, 0, 15);
                    scr_lerpvar("y", y, y + 24, 15);
                    sprite_index = spr_orange_ready_fight;
                    image_index = 0;
                    image_speed = 1/3;
                }
                fogalf = 0.8;
                with (scr_lerpvar("fogalf", 0.8, 0, 8))
                {
                    fogalfcontroller = true;
                }
            }
            if (alt_timer >= 30)
            {
                sprite_index = spr_flowery_puuunch_left;
                with (orange_dopple)
                {
                    sprite_index = spr_orange_animepunch_finished;
                }
                scr_lerpvar("x", x, x - 200, 15, 2, "out");
                with (orange_dopple)
                {
                    scr_lerpvar("x", x, x - 200, 15, 2, "out");
                }
                scr_lerpvar("image_alpha", 1, 0, 15);
                with (orange_dopple)
                {
                    scr_lerpvar("image_alpha", 1, 0, 15);
                }
                with (instance_create(camerax() + camerawidth(), scr_get_box(5) - 107, obj_bulletparent))
                {
                    sprite_index = spr_pixel_white;
                    visible = false;
                    image_xscale = 20;
                    image_yscale = 54.25;
                    direction = 180;
                    speed = 80;
                    scr_script_repeat(function()
                    {
                        scr_shakescreen();
                        with (scr_marker_fog(x, y, sprite_index, 16777215, image_xscale, image_yscale, undefined, 0, undefined, depth + 1))
                        {
                            dad = other.id;
                            var lifetime = 5;
                            scr_doom(id, lifetime);
                            scr_lerpvar("image_alpha", 1, 0, lifetime);
                        }
                    }, 20, 1);
                    scr_doom(id, 20);
                }
                scr_script_delayed(function()
                {
                    sprite_index = spr_flowery_idle3;
                    image_speed = 0.16666666666666666;
                    with (orange_dopple)
                    {
                        sprite_index = spr_orange_animepunch_finished_cent;
                        image_speed = 1/3;
                    }
                }, 15);
                alt_timer -= 60000;
            }
        }
    }
}
if (appearance)
{
    bbox.x1 = x;
    bbox.x2 = x + 40;
    bbox.y1 = y - 200;
    bbox.y2 = y + 200;
}
else
{
    bbox.x1 = x;
    bbox.x2 = x + 40;
    bbox.y1 = (y + 40) - 200;
    bbox.y2 = y + 40 + 200;
}
if (!just_kidding)
{
    if (mode == 0 || mode == 4)
    {
        if ((siner % 6) == 0 && con != 1 && timer < (waittime + 2) && mode != 4)
        {
            with (scr_marker_ext(x, y, sprite_index, 2, 2, undefined, 0, undefined, depth + 1))
            {
                dad = other.id;
                hspeed = 8;
                image_speed = 0;
                var lifetime = 12;
                scr_doom(id, lifetime);
                scr_lerpvar("image_alpha", 1, 0, lifetime);
                orangeheartControlled = true;
            }
        }
        if (con == 1)
        {
            with (scr_marker_fog(x, y, sprite_index, merge_color(c_blue, c_teal, 0.5), 2, 2, undefined, 0, undefined, depth + 1))
            {
                dad = other.id;
                hspeed = 8;
                image_speed = 0;
                var lifetime = 12;
                scr_doom(id, lifetime);
                scr_lerpvar("image_alpha", 1, 0, lifetime);
                orangeheartControlled = true;
            }
        }
    }
}
if (mode == 3)
{
    timer++;
    if (timer == 15)
    {
        fist_y = clamp(obj_orangeheart.y + 10, scr_get_box(5) - 70, scr_get_box(5) + 70);
    }
    if (timer == 60)
    {
        timer = -30;
        with (instance_create(camerax() - 40, fist_y, obj_orangeheart_bullet))
        {
            depth += 0.1;
            sprite_index = spr_fcastle_glovebullet_overworld;
            mask_index = spr_omega_glove;
            scr_size(-2, 2);
            i_am_a_glove = true;
            orangeheartControlled = false;
            breakable = true;
            image_blend = merge_color(c_aqua, c_blue, 0.5);
            direction = 0;
            image_angle = direction;
            drawprevious = false;
            speed = 24;
            with (scr_lerpvar("speed", speed, -3, 40))
            {
                controller = other.id;
            }
            snd_play(snd_rocket, 0.5, 1);
            scr_script_repeat(function()
            {
                with (scr_marker_ext(x, y, sprite_index, image_xscale, image_yscale, undefined, 0, undefined, depth + 1))
                {
                    image_angle = other.image_angle;
                    image_blend = other.image_blend;
                    dad = other.id;
                    hspeed = 0;
                    image_speed = 0;
                    var lifetime = 6;
                    scr_doom(id, lifetime);
                    scr_lerpvar("image_alpha", 1, 0, lifetime);
                }
            }, 240, 2);
        }
    }
}
if (mode == 4)
{
    if (con == 0)
    {
        orangeheartControlled = false;
        intro_timer++;
        if (intro_timer == 10)
        {
            fogcol = 16777215;
            scr_lerpvar("fogalf", 0, 0.8, 10);
        }
        if (intro_timer == 25)
        {
            snd_play_flowery(691);
            scr_script_delayed(snd_play_flowery, 10, 691, 0.5);
            scr_script_delayed(snd_play_flowery, 20, 691, 0.25);
            scr_script_delayed(snd_play_flowery, 30, 691, 0.125);
            visible = false;
            decoy_1 = scr_dark_marker_fancy(x, y, spr_flowery_idle3);
            decoy_2 = scr_dark_marker_fancy(x, y, spr_flowery_idle3);
            decoy_3 = scr_dark_marker_fancy(x, y, spr_flowery_idle3);
            decoy_4 = scr_dark_marker_fancy(x, y, spr_flowery_idle3);
            ds_list_add(final_list, decoy_1, decoy_2, decoy_3, decoy_4);
            ds_list_shuffle(final_list);
            var _counter = 0;
            with (obj_marker_fancy)
            {
                if (sprite_index == spr_flowery_idle3)
                {
                    image_speed = 0.16666666666666666;
                    image_blend = c_white;
                    fogcol = 16777215;
                    fogalf = 1;
                    timer = 0;
                    anchor_x = x;
                    anchor_y = y;
                    anchor_angle = _counter * 90;
                    anchor_length = 0;
                    scr_lerpvar("anchor_x", x, x - 40, 40, 1, "in");
                    scr_lerpvar("anchor_length", 0, 100, 20, 2, "in");
                    scr_lerpvar("anchor_angle", anchor_angle, (anchor_angle - 360 - 90 - (90 * _counter)) + (60 * _counter), 40 + (5 * _counter), 2, "out");
                    scr_script_delayed(scr_lerpvar, 30, "fogalf", 1, 0, 20);
                    
                    draw_func = function()
                    {
                        draw_self();
                        gpu_set_fog(true, #004999, 0, 0);
                        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 0.8);
                        gpu_set_blendmode(bm_add);
                        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 0.8);
                        gpu_set_blendmode(bm_normal);
                        gpu_set_fog(false, c_white, 0, 0);
                        if (fogalf > 0)
                        {
                            gpu_set_fog(true, fogcol, 0, 0);
                            draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, fogalf);
                            gpu_set_fog(false, c_white, 0, 0);
                        }
                    };
                    
                    step_func = function()
                    {
                        timer++;
                        if (timer <= 48)
                        {
                            with (scr_marker_fog(x, y, sprite_index, merge_color(#004999, c_white, fogalf), 2, 2, undefined, 0, undefined, depth + 1))
                            {
                                dad = other.id;
                                image_speed = 0;
                                var lifetime = 4;
                                scr_doom(id, lifetime);
                                scr_lerpvar("image_alpha", 1, 0, lifetime);
                            }
                        }
                        if (!i_ex(obj_heart))
                        {
                            instance_destroy();
                        }
                    };
                    
                    scr_script_repeat(function()
                    {
                        x = anchor_x + lengthdir_x(anchor_length, anchor_angle);
                        y = anchor_y + lengthdir_y(anchor_length, anchor_angle);
                    }, 60 + (_counter * 5), 1);
                    _counter++;
                }
            }
        }
        if (intro_timer == 85)
        {
            intro_over = true;
            waittime = 1;
        }
        if (intro_over)
        {
            timer++;
        }
        if (timer == waittime)
        {
            if (ds_list_size(final_list))
            {
                current_decoy = ds_list_find_value(final_list, 0);
                ds_list_delete(final_list, 0);
                if (ds_list_size(final_list))
                {
                    sprite_index = choose(spr_flowery_jump_left, spr_flowery_crouch_left, spr_flowery_punch_windup);
                }
                else
                {
                    sprite_index = choose(spr_flowery_crouch_left, spr_flowery_punch_windup);
                }
                with (current_decoy)
                {
                    sprite_index = other.sprite_index;
                }
                var ronas = [[150, round(9)], [752, round(9.6)], [68, round(9.9)], [12, round(10.5)]];
                var thisrona = irandom(array_length(ronas) - 1);
                snd_play_flowery(ronas[thisrona][0], 0.65, 1);
                ronawait = ronas[thisrona][1];
                with (current_decoy)
                {
                    hspeed = 8;
                    friction = 0.4;
                }
                with (current_decoy)
                {
                    fogcol = 16777215;
                    fogalf = 1;
                    with (scr_lerpvar("fogalf", 1, 0, 8))
                    {
                        fogalfcontroller = true;
                    }
                }
            }
            else
            {
                timer = 0;
            }
        }
        if (timer > waittime && timer < (timer == (waittime + ronawait)))
        {
            friction = scr_approach(friction, 0, 0.05);
        }
        if (timer == (waittime + ronawait))
        {
            x = current_decoy.x;
            y = current_decoy.y;
            current_decoy.visible = false;
            visible = true;
            if (sprite_index == spr_flowery_punch_windup)
            {
                sprite_index = spr_flowery_puuunch_left;
                image_speed = 0.16666666666666666;
            }
            else if (sprite_index == spr_flowery_crouch_left)
            {
                sprite_index = spr_flowery_fair_left;
            }
            else
            {
                sprite_index = spr_flowery_shrug_downleft;
            }
            with (obj_lerpvar)
            {
                if (variable_instance_exists(id, "fogalfcontroller"))
                {
                    instance_destroy();
                }
            }
            fogalf = 0.8;
            fogcol = 10045696;
            con = 1;
            timer = 0;
            waittime = 1;
        }
    }
    var playerhit = false;
    if (con == 1)
    {
        x -= attack_speed;
        if (sprite_index == spr_flowery_puuunch_left)
        {
            y = lerp(y, obj_orangeheart.y - 40, 0.4);
        }
        else
        {
            y = lerp(y, obj_orangeheart.y - 60, 0.4);
        }
        if (instance_exists(collision_rectangle(bbox.x1, bbox.y1, bbox.x2, bbox.y2, obj_orangeheart, false, false)))
        {
            orangeheartControlled = true;
            if (obj_orangeheart.dashing)
            {
                attack_speed = scr_approach(attack_speed, attack_speed_limit, attack_speed_change);
                x = obj_orangeheart.x + 20;
                if (i_ex(obj_flowery_enemy))
                {
                    scr_tensionheal(12 * obj_flowery_enemy.moar_tension);
                }
                if (ds_list_size(final_list))
                {
                    do_hit_event();
                    if (abs(obj_debug_orangeheartcontroller.fakecamxspeedadditional) > 13)
                    {
                        do_hitstop(4);
                        hittimer = 4;
                    }
                    else
                    {
                        do_hitstop(4);
                        hittimer = 4;
                    }
                }
                else
                {
                    fogalf = 0;
                    do_hit_event_for_the_fans();
                    do_hitstop(40);
                    hittimer = 40;
                    snd_play_flowery(124);
                    for_the_fans_bug = true;
                }
                with (obj_orangeheart)
                {
                    dashstate = 0;
                    dashing = 0;
                    chargecon = 0;
                    heartcooldown = 0;
                    dashtimer = 0;
                    chargetimer = 0;
                }
                remx = x;
                remy = y;
                con = 4;
                timer = 0;
                snd_play(snd_swing);
                if (ds_list_size(final_list))
                {
                    sprite_index = spr_flowery_deflected;
                }
            }
            else
            {
                with (obj_orangeheart)
                {
                    hurt(other.id);
                }
                fogalf = 0;
                con = 2;
                playerhit = true;
            }
        }
    }
    if (con >= 1)
    {
        if (playerhit)
        {
            if (ds_list_size(final_list))
            {
                visible = false;
            }
            else
            {
                global.turntimer = 30;
                sprite_index = spr_flowery_deflected;
            }
            obj_orangeheart.shakeheart = 14;
            snd_play(snd_punchmed, 1, 0.75);
            if (!global.inv)
            {
                scr_shakescreen(32);
            }
            hspeed = 0;
            vspeed = 0;
            timer = -14;
            con = 0;
            var movetime = 18;
            hspeed = 18 + random(1.5);
            if (for_the_fans_bug == true)
            {
                hspeed = 25 + random(1.5);
            }
            if ((y + 70) > scr_get_box(5))
            {
                vspeed = random_range(-5, -1);
            }
            else
            {
                vspeed = random_range(1, 5);
            }
            orangeheartControlled = false;
            friction = 0.65;
            if (for_the_fans_bug == true)
            {
                friction = 0.2;
            }
            if (sprite_index == spr_flowery_shrug_downleft)
            {
                sprite_index = spr_flowery_shrug_spin;
                image_speed = 0;
                scr_lerpvar("image_index", 0, 8, 16, 0, "out");
            }
            else
            {
                sprite_index = spr_flowery_deflected;
            }
            with (obj_orangeheart)
            {
                if (audio_is_playing(loop_sound))
                {
                    snd_stop(loop_sound);
                }
                dashstate = 0;
                dashing = 0;
                chargecon = 0;
                heartcooldown = 0;
                dashtimer = 0;
                chargetimer = 0;
                scr_lerpvar("x", x, x - 80, 6, 1, "out");
                scr_script_delayed(scr_lerpvar, 6, "x", x - 80, x, 12, 1, "in");
                scr_lerpvar("image_angle", 0, 30, 6, 1, "out");
                scr_script_delayed(scr_lerpvar, 6, "image_angle", 30, 0, 12, 1, "in");
                for (var a = 0; a < 6; a++)
                {
                    with (instance_create((x + 10) - 40, y + 10, obj_marker))
                    {
                        sprite_index = spr_whitepixel;
                        image_blend = c_orange;
                        if (irandom(2))
                        {
                            image_yscale = 3;
                            image_xscale = 3;
                        }
                        else
                        {
                            image_yscale = 5;
                            image_xscale = 5;
                        }
                        direction = 135 + random(90);
                        speed = 1 + (3 * a);
                        hspeed *= 0.75;
                        vspeed *= 0.35;
                        image_angle = direction;
                        image_alpha = 0.85;
                        hspeed += 6;
                        my_time = 20 - (1 + (a * 3));
                        if (image_xscale > 2)
                        {
                            scr_lerpvar("image_xscale", image_xscale, 2, my_time - 2);
                        }
                        scr_lerpvar("image_alpha", 0.85, 0, my_time);
                        orangeheartControlled = true;
                        scr_doom(id, my_time);
                    }
                }
            }
        }
    }
    if (playerhit || (con == 4 && (timer + 1) >= hittimer))
    {
        if (battle_timer > 315 && global.turntimer > 5 && mode != 4)
        {
            global.turntimer = 5;
        }
    }
    if (con == 4)
    {
        orangeheartControlled = false;
        timer++;
        x = remx + random_range(-4, 4);
        y = remy + random_range(-4, 4);
        if (timer >= hittimer)
        {
            if (ds_list_size(final_list))
            {
                for (var a = 0; a < 6; a++)
                {
                    with (instance_create(x + 35, y + 86, obj_marker))
                    {
                        depth = obj_growtangle.depth - 5;
                        sprite_index = spr_petal_blue;
                        image_index = irandom(3);
                        image_xscale = 1.5;
                        image_yscale = 1.5;
                        image_speed = 0;
                        image_angle = 45 * irandom(7);
                        direction = irandom(360);
                        speed = 16 + random(16);
                        hspeed += 8;
                        hspd = hspeed;
                        vspd = vspeed;
                        indx = 0.5;
                        hspeed = 0;
                        vspeed = 0;
                        orangeheartControlled = true;
                        scr_script_repeat(function()
                        {
                            with (obj_debug_orangeheartcontroller)
                            {
                                if (!hitstop)
                                {
                                    other.x += other.hspd;
                                    other.y += other.vspd;
                                    other.image_index += other.indx;
                                }
                            }
                            hspd *= 0.9;
                            vspd *= 0.9;
                            if (x < (camerax() - 20))
                            {
                                instance_destroy();
                            }
                        }, 240, 1);
                    }
                }
                visible = false;
            }
            else
            {
                sprite_index = spr_flowery_deflected;
            }
            damage_flash = 8;
            snd_play(snd_punchheavythunder, undefined, 1.2);
            snd_play(snd_parry_fast_nodelay, 1, 1);
            if (i_ex(obj_flowery_enemy))
            {
                scr_tensionheal(10 * obj_flowery_enemy.moar_tension);
            }
            x = remx;
            y = remy;
            hspeed = 34;
            vspeed = random_range(-5, 5);
            with (obj_debug_orangeheartcontroller)
            {
                fakecamxspeedbase += fakecamxspeedadditional;
                scr_lerpvar("fakecamxspeedbase", fakecamxspeedbase, fakecamxspeedbase - fakecamxspeedadditional, 25);
                fakecamxspeedadditional = 0;
            }
            if (ds_list_size(final_list))
            {
                friction = 2;
            }
            else
            {
                friction = 1.25;
                do_bullets = true;
                global.turntimer = 90;
            }
            waittime = 1;
            timer = 0;
            con = 0;
            fogalf = 0;
            if (do_bullets)
            {
                var cnt = 7;
                var _rand = random_range(-8, 8);
                var _which = irandom(2);
                for (var i = 1; i < cnt; i++)
                {
                    var xloc = x + 34;
                    var yloc = y + 60;
                    for (var aa = 0; aa < (2 - ((i % 2) == 0)); aa++)
                    {
                        with (instance_create(xloc, yloc, obj_orangeheart_wall))
                        {
                            orangeheartControlled = false;
                            sprite_index = spr_spinning_petal;
                            image_speed = 1;
                            image_xscale = 1.5;
                            image_yscale = 2;
                            draw_prev = true;
                            hsp = 10 + (i * 2.5) + random_range(-0.5, 0.5);
                            fakehgrav = -0.75;
                            if ((aa % 2) == 0)
                            {
                                vsp = _rand + (i * 10);
                            }
                            else
                            {
                                vsp = _rand - (i * 10 * 0.9);
                            }
                            scr_lerpvar("vsp", vsp * 0.25, 0, 24 + (i * 8));
                            inboundsonly = true;
                        }
                    }
                }
            }
        }
    }
}
