if (!instance_exists(obj_growtangle))
{
    instance_destroy();
    exit;
}
var cx = camerax();
var cy = cameray();
var screenspace = cx + 680;
var space = screenspace / 5;
if (!hitstop)
{
    if (attacktype == 0)
    {
        timer += abs((fakecamxspeedbase + fakecamxspeedadditional) / 16);
        script_timer++;
        if (do_chase)
        {
            if (!i_ex(obj_orangeheart_chaseattack) && difficulty && difficulty != 7 && difficulty != 8 && difficulty != 9)
            {
                with (instance_create(camerax() - 40, cameray(), obj_orangeheart_chaseattack))
                {
                    if (other.difficulty >= 5)
                    {
                        mymaxspeed = 18;
                    }
                    if (other.difficulty == 1 || other.difficulty == 4)
                    {
                        mymaxspeed += (other.open_chase_difficulty * 0.35);
                    }
                }
            }
        }
        switch (difficulty)
        {
            case 0:
                if (wall_tutorial_counter < 4 && timer >= 40 && !i_ex(obj_orangeheart_wall))
                {
                    wall_create(screenspace + 40, scr_get_box(5), 16, 240, 120, 240);
                }
                if (wall_counter < 3 && wall_tutorial_counter >= 4)
                {
                    if (timer >= (30 - timer_adjust))
                    {
                        wall_create(screenspace - ((timer - (30 - timer_adjust)) * 16), scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 30), 120);
                        wall_counter++;
                        timer_adjust++;
                        if (wall_counter == 3)
                        {
                            timer = -10;
                        }
                        else
                        {
                            timer = 0;
                        }
                    }
                }
                if (wall_counter >= 3)
                {
                    if (timer >= 12)
                    {
                        if (wall_counter >= 11)
                        {
                            if (wall_counter == 15)
                            {
                                wall_create(screenspace - ((timer - 18) * 16), scr_get_box(5), 16, 240, 120, 0);
                                wall_create((screenspace - ((timer - 18) * 16)) + 100, scr_get_box(5), 16, 240, 120, 0);
                                wall_create((screenspace - ((timer - 18) * 16)) + 200, scr_get_box(5), 16, 240, 120, 0);
                            }
                            if (wall_counter == 14)
                            {
                                timer_goal = 40;
                                with (obj_orangeheart)
                                {
                                    height_frames = 32;
                                }
                                instance_create((screenspace - ((timer - 18) * 16)) + 20, scr_get_box(5), obj_orangeheart_jumppad);
                                global.turntimer = 70;
                            }
                            else if (wall_counter < 14)
                            {
                                wall_create(screenspace - ((timer - 18) * 16), scr_get_box(5), 16, 240, 120, 50);
                            }
                        }
                        else
                        {
                            wall_create(screenspace - ((timer - 18) * 16), scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 45), 80);
                        }
                        wall_counter++;
                        if (wall_counter == 15)
                        {
                            timer = -8;
                        }
                        else if (((wall_counter - 3) % 4) == 0)
                        {
                            timer = -14;
                        }
                        else
                        {
                            timer = 8;
                        }
                    }
                }
                break;
            case 1:
                if (timer >= 6)
                {
                    if ((wall_counter % 10) < 5)
                    {
                        with (wall_create(screenspace - ((timer - 6) * 16), scr_get_box(5) + (sin(global.time * 0.24) * 30) + (cos(global.time * 0.035) * 40), 16, 80 - (open_chase_difficulty * 15), 80 - (open_chase_difficulty * 15), 80 - (open_chase_difficulty * 15)))
                        {
                            vase = true;
                        }
                    }
                    else if ((wall_counter % 2) == 0)
                    {
                        with (wall_create(screenspace - ((timer - 6) * 16), scr_get_box(5) - (sin(global.time * 0.24) * 30) - (cos(global.time * 0.035) * 40), 16, 60, 60, 0))
                        {
                            vase = true;
                            cactus = true;
                        }
                    }
                    wall_counter++;
                    timer = 0;
                }
                break;
            case 2:
                if (timer >= 12)
                {
                    var _h = scr_get_box(5) + (sin((global.time * 0.1) + individualism) * 40) + (cos(global.time * 0.0175) * 20);
                    var _l = (scr_get_box(3) - _h) + 45;
                    var _ex = scr_get_box(3) - (_h + (_l * 0.5));
                    wall_create(screenspace - ((timer - 12) * 16), _h + _ex, 16, _l, 45, 55);
                    wall_counter++;
                    if ((wall_counter % 8) == 0)
                    {
                        timer = -18;
                        individualism = random(100);
                    }
                    else
                    {
                        timer = 6;
                    }
                }
                break;
            case 3:
                if (timer >= 12)
                {
                    var _h = scr_get_box(5) + (sin((global.time * 0.1) + individualism) * 40) + (cos(global.time * 0.0175) * 20);
                    var _l = (scr_get_box(3) - _h) + 45;
                    var _ex = scr_get_box(3) - (_h + (_l * 0.5));
                    wall_create(screenspace - ((timer - 12) * 16), _h + _ex, 16, _l, 45, 45);
                    wall_counter++;
                    if ((wall_counter % 6) == 0)
                    {
                        timer = -15;
                        individualism = choose(pi, 1.5707963267948966);
                    }
                    else
                    {
                        timer = 6;
                    }
                }
                break;
            case 4:
                if (timer >= 12 && wall_counter >= 30)
                {
                    var _h = scr_get_box(5) + (sin((global.time * 0.1) + individualism) * 40) + (cos(global.time * 0.0175) * 20);
                    var _l = (scr_get_box(3) - _h) + 45;
                    var _ex = scr_get_box(3) - (_h + (_l * 0.5));
                    wall_create(screenspace - ((timer - 12) * 16), _h + _ex, 16, _l, 45, 55 - (open_chase_difficulty * 8));
                    wall_counter++;
                    timer = 6;
                }
                if (timer >= 5 && wall_counter < 30)
                {
                    if ((cactus_chance >= 3 && !irandom(2)) || cactus_chance == 6)
                    {
                        if (abs((scr_get_box(5) + (sin(global.time * 0.48) * 30) + (sin(global.time * 0.07) * 40)) - last_bamboo_y) < 40)
                        {
                            var extra_time = choose(-9, 9);
                            last_bamboo_y = scr_get_box(5) + (sin((global.time + extra_time) * 0.48) * 30) + (sin((global.time + extra_time) * 0.07) * 40);
                        }
                        else
                        {
                            last_bamboo_y = scr_get_box(5) + (sin(global.time * 0.48) * 30) + (sin(global.time * 0.07) * 40);
                        }
                        cactus_chance -= 2;
                        with (wall_create((screenspace - ((timer - 6) * 16)) + 64, scr_get_box(5) + (sin(global.time * 0.48) * 30) + (sin(global.time * 0.07) * 40), 16, 60, 60, 0))
                        {
                            vase = true;
                            cactus = true;
                        }
                        timer = -8;
                    }
                    else
                    {
                        last_bamboo_y = scr_get_box(5) + (sin(global.time * 0.48) * 30) + (cos(global.time * 0.07) * 40);
                        cactus_chance++;
                        with (wall_create(screenspace - ((timer - 6) * 16), last_bamboo_y, 16, 60 - (open_chase_difficulty * 10), 60 - (open_chase_difficulty * 10), 60 - (open_chase_difficulty * 10)))
                        {
                            vase = true;
                        }
                        timer = 0;
                    }
                    wall_counter++;
                    if (wall_counter == 30)
                    {
                        timer = -18;
                    }
                }
                break;
            case 5:
                if (timer > 6)
                {
                    wall_create(screenspace - ((timer - 6) * 16), scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 40), 160, true);
                    wall_counter++;
                    if (wall_counter == 3)
                    {
                        timer -= 46;
                        wall_counter = 0;
                    }
                    else
                    {
                        timer -= 8;
                    }
                }
                break;
            case 6:
                if (timer >= 5)
                {
                    last_bamboo_y = scr_get_box(5) + (sin(global.time * 0.96 * 4) * 40) + (cos(global.time * 0.14 * 4) * 40);
                    if ((wall_counter % 5) == 0)
                    {
                        with (instance_create(screenspace - ((timer - 6) * 16), last_bamboo_y, obj_orangeheart_wallflower))
                        {
                            bomb_timer = 0;
                            scr_darksize();
                            image_blend = merge_color(c_aqua, c_blue, 0.5);
                            direction = 180;
                            speed = 12;
                            scr_lerpvar("speed", 12, 0.5, 30, 1, "out");
                            trigger = false;
                            scr_script_repeat(function()
                            {
                                image_angle += 4;
                                if (trigger)
                                {
                                    bomb_timer++;
                                }
                                if (speed == 0.5 && !trigger)
                                {
                                    trigger = true;
                                    reticle = true;
                                    snd_play(snd_bombfall);
                                    scr_script_delayed(snd_play, 2, snd_bombfall);
                                    scr_script_delayed(snd_play, 4, snd_bombfall);
                                }
                                if (bomb_timer == 16)
                                {
                                    snd_play(snd_bomb);
                                    snd_play(snd_magicsprinkle, 0.5);
                                    with (instance_create_depth(x, y, depth - 100, obj_yellow_beam))
                                    {
                                        setup(camerax() + 680, scr_get_box(5), x, y, 12, 0, 48, 8, 8);
                                    }
                                    timer = 0;
                                    dir = choose(1, -1);
                                    randir = irandom(360);
                                    visible = false;
                                    scr_script_repeat(function()
                                    {
                                        for (var a = 0; a < 2; a++)
                                        {
                                            with (instance_create(x, y, obj_orangeheart_bullet))
                                            {
                                                timer = 0;
                                                depth -= 100;
                                                speed = 10 + irandom(6);
                                                scr_lerpvar("speed", speed, 3, 20);
                                                mydir = other.dir;
                                                x_accel = 16;
                                                sprite_index = spr_enemy_blue_bullet_butterfly;
                                                image_speed = 0.5;
                                                image_xscale = 1.8;
                                                image_yscale = 1.8;
                                                direction = (other.timer * 45) + other.randir + (a * 180);
                                                other.timer++;
                                                image_angle = 0;
                                                scr_script_repeat(function()
                                                {
                                                    timer++;
                                                    if ((timer % 2) == 0)
                                                    {
                                                        with (scr_afterimagefast())
                                                        {
                                                            image_blend = c_gray;
                                                            fadeSpeed *= 3;
                                                            scr_lerpvar("image_xscale", 1, 0, 4);
                                                            scr_lerpvar("image_yscale", 1, 0, 4);
                                                        }
                                                    }
                                                    x += x_accel;
                                                    x_accel -= 0.375;
                                                    direction += (mydir * 2);
                                                    if (timer >= 120)
                                                    {
                                                        instance_destroy();
                                                    }
                                                }, 160, 1);
                                            }
                                        }
                                        if (timer >= 8)
                                        {
                                            instance_destroy();
                                        }
                                    }, 20, 1);
                                }
                            }, 600, 1);
                        }
                    }
                    with (wall_create(screenspace - ((timer - 6) * 16), scr_get_box(5) + (sin(global.time * 0.25) * 50) + (cos(global.time * 0.015) * 40), 16, 100 - (open_chase_difficulty * 10), 100 - (open_chase_difficulty * 10), 100 - (open_chase_difficulty * 10)))
                    {
                        tensionvalue = 1;
                        vase = true;
                    }
                    wall_counter++;
                    if ((wall_counter % 4) == 0)
                    {
                        timer = -20;
                    }
                    else
                    {
                        timer = -1;
                    }
                }
                break;
            case 7:
                if (script_timer == 1)
                {
                    tutorial_clamp = true;
                    with (obj_flowery_enemy)
                    {
                        msgset_add(stringsetloc("Alright^1, Kris...&If you want to&prove your worth.../%", "obj_debug_orangeheartcontroller_slash_Step_0_gml_362_0"), obj_flowery_enemy.x + 15, obj_flowery_enemy.y - 5, 13, 50);
                        msgset_add(stringsetloc("Charge up your&BRAVELY COLORED&HEART!/%", "obj_debug_orangeheartcontroller_slash_Step_0_gml_363_0"), obj_flowery_enemy.x + 15, obj_flowery_enemy.y - 5, 13, 50, function()
                        {
                            scr_script_delayed(function()
                            {
                                with (obj_writer)
                                {
                                    instance_destroy();
                                }
                            }, 60);
                            scr_speaker("ralsei");
                            if (i_ex(obj_flowery_enemy))
                            {
                                ralsei_tutorial_string_con = -1;
                                global.battlemsg[0] = stringsetsub(obj_flowery_enemy.ralsei_tutorial_string, scr_get_input_name(4));
                            }
                        });
                        msgset_add_func(function()
                        {
                            talked = -1;
                            scr_var_delay("talked", 0, 40);
                            with (obj_debug_orangeheartcontroller)
                            {
                                wall_create(camerax() + 660, scr_get_box(5), 16, 120, 120, 120);
                                wall_create(camerax() + 720, scr_get_box(5), 16, 120, 120, 120);
                                wall_create(camerax() + 780, scr_get_box(5), 16, 120, 120, 120);
                                wall_create(camerax() + 840, scr_get_box(5), 16, 120, 120, 120);
                                scr_lerpvar("fakecamxspeedbase_original", fakecamxspeedbase_original, -0.35, 39);
                            }
                        });
                        msgset_add_func(function()
                        {
                            snd_play(motor_swing_down);
                            with (obj_debug_orangeheartcontroller)
                            {
                                fakecamxspeedbase_original = 0;
                                scr_lerpvar("spotlight", 640, 50, 8, 1, "out");
                                scr_script_delayed(scr_lerpvar, 8, "spotlight", 50, 45, 52);
                            }
                            with (obj_flowery_hero_flower)
                            {
                                timer_on = false;
                            }
                            with (obj_heroparent)
                            {
                                state = 99;
                            }
                            with (obj_marker)
                            {
                                if (sprite_index == spr_sparestar_anim)
                                {
                                    vspeed = 0;
                                    with (obj_script_delayed)
                                    {
                                        if (target == other.id)
                                        {
                                            alarm[0] += 45;
                                        }
                                    }
                                }
                            }
                            with (obj_flowery_enemy)
                            {
                                image_speed = 0;
                            }
                            obj_flowery_towery.halt = true;
                            talked = -1;
                            scr_var_delay("talked", 0, 20);
                        });
                        msgset_add_func(function()
                        {
                            with (obj_orangeheart)
                            {
                                scr_lerpvar("image_angle", -90, 0, 25, -1, "out");
                            }
                            talked = -1;
                            scr_var_delay("talked", 0, 40);
                        });
                        msgset_add_func(function()
                        {
                            with (obj_debug_orangeheartcontroller)
                            {
                                fakecamxspeedbase_original = -0.35;
                                spotlight = 0;
                            }
                            with (obj_flowery_hero_flower)
                            {
                                timer_on = true;
                            }
                            with (obj_marker)
                            {
                                if (sprite_index == spr_sparestar_anim)
                                {
                                    vspeed = 2;
                                }
                            }
                            with (obj_heroparent)
                            {
                                state = 0;
                            }
                            with (obj_flowery_enemy)
                            {
                                image_speed = 0.16666666666666666;
                            }
                            obj_flowery_towery.halt = false;
                            snd_play(snd_great_shine, 1, 0.8);
                            scr_shakescreen(10);
                            with (obj_debug_orangeheartcontroller)
                            {
                                check_for_failure = 1;
                            }
                            with (obj_orangeheart)
                            {
                                cancharge = true;
                                image_blend = c_yellow;
                                with (scr_afterimage_grow())
                                {
                                    sprite_index = spr_orangeheart_centered;
                                    x += 10;
                                    y += 10;
                                    fade *= 0.25;
                                }
                            }
                        });
                        flowery_balloon();
                    }
                }
                if (!scrolling)
                {
                    if (check_for_failure == 1 && instance_number(obj_orangeheart_wall) < 3)
                    {
                        check_for_failure = 2;
                        with (obj_flowery_enemy)
                        {
                            msgset_add(string(stringsetloc("What^1, you can't&even hold and&release {0}!?", "obj_debug_orangeheartcontroller_slash_Step_0_gml_421_0"), scr_get_input_name(4)), obj_flowery_enemy.x + 15, obj_flowery_enemy.y - 5, 13, 50);
                            flowery_balloon();
                        }
                    }
                    if (check_for_failure == 2 && !i_ex(obj_orangeheart_wall))
                    {
                        check_for_failure = 3;
                        with (obj_flowery_enemy)
                        {
                            with (obj_writer)
                            {
                                instance_destroy();
                            }
                            msgset_add_func(function()
                            {
                                talked = -1;
                                scr_var_delay("talked", 0, 30);
                            });
                            msgset_add(string(stringsetloc("Well^1, if that's&the way you&wanna go out.../%", "obj_debug_orangeheartcontroller_slash_Step_0_gml_439_0"), scr_get_input_name(4)), obj_flowery_enemy.x + 15, obj_flowery_enemy.y - 5, 13, 50);
                            msgset_add_func(function()
                            {
                                global.turntimer = 5;
                            });
                            flowery_balloon();
                        }
                        with (obj_orangeheart)
                        {
                            cancharge = false;
                            if (chargecon == 1)
                            {
                                snd_stop(loop_sound);
                            }
                            dashstate = 0;
                            dashing = 0;
                            chargecon = 0;
                            heartcooldown = 0;
                            dashtimer = 0;
                            chargetimer = 0;
                        }
                    }
                }
                if (scrolling == 1)
                {
                    scrolling = 2;
                    timer = 0;
                    wall_counter = 0;
                    scr_script_delayed(scr_lerpvar, 16, "do_lines", 0, 0.25, 30);
                    with (obj_growtangle)
                    {
                        visible = true;
                        image_yscale = 0;
                        scr_lerpvar("image_yscale", 0, 3.3, 12, 1, "out");
                        scr_script_delayed(scr_lerpvar, 13, "image_yscale", 3.3, 3, 4, 1, "in");
                        scr_lerpvar("image_xscale", 0, 10, 12, 1, "out");
                    }
                }
                if (timer >= 30 && scrolling == 2 && wall_counter < 7)
                {
                    wall_counter++;
                    if (wall_counter == 1)
                    {
                        wall_create(camerax() + 660, scr_get_box(5), 16, 240, 240, 240);
                    }
                    if (wall_counter == 2)
                    {
                        wall_create(camerax() + 660, scr_get_box(5), 16, 240, 180, 120);
                    }
                    if (wall_counter == 3)
                    {
                        wall_create(camerax() + 660, scr_get_box(5), 16, 240, 60, 120);
                    }
                    if (wall_counter == 4)
                    {
                        wall_create(camerax() + 660, scr_get_box(5), 16, 240, 120, 80);
                    }
                    if (wall_counter == 5)
                    {
                        wall_create(camerax() + 660, scr_get_box(5), 16, 240, 240, 240);
                        wall_create(camerax() + 740, scr_get_box(5), 16, 240, 240, 240);
                        wall_create(camerax() + 820, scr_get_box(5), 16, 240, 240, 240);
                        wall_create(camerax() + 900, scr_get_box(5), 16, 240, 240, 240);
                    }
                    timer = 0;
                }
                if (!i_ex(obj_orangeheart_wall) && wall_counter == 6)
                {
                    wall_counter = 7;
                    global.turntimer = 15;
                }
                with (obj_flowery_enemy)
                {
                    if (talked != -1)
                    {
                        flowery_balloon_control();
                    }
                }
                break;
            case 8:
                if (timer >= 12 && !wall_counter)
                {
                    _counter = 0;
                    var _add = 640;
                    var _gap = 140;
                    for (var a = 0; a < 9; a++)
                    {
                        wall_create(camerax() + 660 + _counter, scr_get_box(5), 16, 240, 120 + ((((a % 2) == 0) ? 1 : -1) * 60 * (1 - (a * 0.1))) + (sin(a + global.time) * 15), _gap);
                        _counter += _add;
                        _add = scr_approach(_add, 290, 140);
                        _gap = scr_approach(_gap, 36, 30);
                    }
                    wall_counter = 1;
                }
                if (timer >= ((660 + (_counter - 760)) / 16) && wall_counter == 1)
                {
                    wall_counter = 2;
                    with (obj_flowery_enemy)
                    {
                        visible = false;
                    }
                    with (obj_orangeheart_floweryjarona)
                    {
                        x = camerax() + 660;
                        scr_lerpvar("x", x, xstart, 30, 1, "out");
                        visible = true;
                        intro_timer = -20;
                    }
                }
                break;
            case 9:
                if (!wall_counter)
                {
                    wall_counter = 1;
                    for (var aa = 0; aa < 16; aa++)
                    {
                        with (instance_create((camerax() - 30) + (43.75 * aa), scr_get_box(5) - 120, obj_orangeheart_bullet))
                        {
                            destroyonhit = false;
                            left_kill = false;
                            drawprevious = false;
                            image_xscale = 2;
                            image_yscale = 2;
                            direction = 0;
                            speed = -5;
                            sprite_index = spr_enemy_blue_star;
                            image_angle = 22.5 * aa;
                            scr_script_repeat(function()
                            {
                                image_angle += 2;
                                if (x <= (camerax() - 30))
                                {
                                    x += 700;
                                }
                                y = (scr_get_box(5) - 90 - (sin(global.time * 0.05) * 30)) + (sin((0.0022439947525641378 * (x - (camerax() - 30))) + (global.time * 0.05)) * 80);
                            }, -1, 1);
                        }
                        with (instance_create((camerax() - 30) + (43.75 * aa), scr_get_box(5) + 120, obj_orangeheart_bullet))
                        {
                            destroyonhit = false;
                            left_kill = false;
                            drawprevious = false;
                            image_xscale = 2;
                            image_yscale = 2;
                            direction = 0;
                            speed = -5;
                            sprite_index = spr_enemy_blue_star;
                            image_angle = 22.5 * aa;
                            scr_script_repeat(function()
                            {
                                image_angle += 2;
                                if (x <= (camerax() - 30))
                                {
                                    x += 700;
                                }
                                y = scr_get_box(5) + 90 + (sin(global.time * 0.05) * 30) + (sin((0.0022439947525641378 * (x - (camerax() - 30))) + (global.time * 0.05)) * 80);
                            }, -1, 1);
                        }
                    }
                }
                break;
            case 10:
                if (timer > timer_goal)
                {
                    if (wall_counter < 2)
                    {
                        with (instance_create(screenspace - ((timer - timer_goal) * 16), scr_get_box(5), obj_orangeheart_jumppad))
                        {
                            other.last_pad = clamp(y, scr_get_box(5) - 40, scr_get_box(5) + 40);
                        }
                    }
                    else
                    {
                        with (instance_create(screenspace - ((timer - timer_goal) * 16), last_pad + ((30 + irandom(10)) * choose(-1, 1)), obj_orangeheart_jumppad))
                        {
                            other.last_pad = clamp(y, scr_get_box(5) - 40, scr_get_box(5) + 40);
                            vspeed = choose(-1, 1);
                            if (y > (scr_get_box(5) + 60))
                            {
                                vspeed = -1;
                            }
                            if (y < (scr_get_box(5) - 60))
                            {
                                vspeed = 1;
                            }
                        }
                    }
                    if (wall_counter)
                    {
                        for (var a = 0; a < 5; a++)
                        {
                            with (instance_create((screenspace - ((timer - timer_goal) * 16)) + (timer_goal * 8) + 30, (scr_get_box(5) - 187.5) + (75 * a), obj_orangeheart_bullet))
                            {
                                graze = 0;
                                if ((other.wall_counter % 2) == 0)
                                {
                                    vspeed = 5;
                                }
                                else
                                {
                                    vspeed = -5;
                                }
                                sprite_index = spr_attack_knifechain;
                                image_angle = sign(-vspeed) * 90;
                                image_speed = 1;
                                scr_darksize();
                                orangeheartControlled = true;
                                drawprevious = false;
                                scr_script_repeat(function()
                                {
                                    if (y <= (scr_get_box(5) - 150) || y >= (scr_get_box(5) + 150))
                                    {
                                        image_alpha = scr_approach(image_alpha, 0, 0.15);
                                    }
                                    else
                                    {
                                        image_alpha = scr_approach(image_alpha, 1, 0.15);
                                    }
                                    if (y < (scr_get_box(5) - 187.5))
                                    {
                                        y += 375;
                                    }
                                    if (y > (scr_get_box(5) + 187.5))
                                    {
                                        y -= 375;
                                    }
                                }, 999, 1);
                            }
                        }
                        for (var a = 0; a < 5; a++)
                        {
                            with (instance_create(((screenspace - ((timer - timer_goal) * 16)) + (timer_goal * 8)) - 30, (scr_get_box(5) - 187.5) + (75 * a) + 37.5, obj_orangeheart_bullet))
                            {
                                graze = 0;
                                if ((other.wall_counter % 2) == 0)
                                {
                                    vspeed = 5;
                                }
                                else
                                {
                                    vspeed = -5;
                                }
                                sprite_index = spr_attack_knifechain;
                                image_angle = sign(-vspeed) * 90;
                                image_speed = 1;
                                scr_darksize();
                                orangeheartControlled = true;
                                drawprevious = false;
                                scr_script_repeat(function()
                                {
                                    if (y <= (scr_get_box(5) - 150) || y >= (scr_get_box(5) + 150))
                                    {
                                        image_alpha = scr_approach(image_alpha, 0, 0.15);
                                    }
                                    else
                                    {
                                        image_alpha = scr_approach(image_alpha, 1, 0.15);
                                    }
                                    if (y < (scr_get_box(5) - 187.5))
                                    {
                                        y += 375;
                                    }
                                    if (y > (scr_get_box(5) + 187.5))
                                    {
                                        y -= 375;
                                    }
                                }, 999, 1);
                            }
                        }
                    }
                    wall_counter++;
                    timer -= timer_goal;
                }
                break;
            case 11:
                if (timer > timer_goal)
                {
                    if (wall_counter < 4)
                    {
                        wall_create(screenspace - ((timer - timer_goal) * 16), scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 40), 160, true);
                        timer_goal--;
                    }
                    else if (wall_counter < 6)
                    {
                        wall_create(screenspace - ((timer - timer_goal) * 16), scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 40), 160, true);
                        wall_create((screenspace - ((timer - timer_goal) * 16)) + 80, scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 40), 160, true);
                        timer_goal--;
                    }
                    else if (wall_counter == 6)
                    {
                        wall_create(screenspace - ((timer - timer_goal) * 16), scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 40), 160, true);
                        wall_create((screenspace - ((timer - timer_goal) * 16)) + 80, scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 40), 160, true);
                        wall_create((screenspace - ((timer - timer_goal) * 16)) + 160, scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 40), 160, true);
                        timer_goal = 10;
                        timer -= 60;
                    }
                    else if (wall_counter < 12)
                    {
                        wall_create(screenspace - ((timer - timer_goal) * 16), scr_get_box(5), 16, 240, 120 + (sin(global.time * 0.1) * 40), 160, true);
                    }
                    wall_counter++;
                    timer -= timer_goal;
                }
                break;
            case 12:
                if (timer > timer_goal)
                {
                    for (var a = 0; a < 8; a++)
                    {
                        with (instance_create(screenspace - ((timer - timer_goal) * 16), scr_get_box(5), obj_orangeheart_bullet_orbit))
                        {
                            rot_val = 0.7853981633974483 * a;
                            move();
                        }
                    }
                    wall_counter++;
                    timer -= timer_goal;
                }
                break;
        }
    }
}
if (attacktype == 1)
{
    timer++;
    if ((timer % 8) == 0)
    {
        var wall = instance_create((cx + screenspace) - 16, cy + 80 + random(120), obj_orangeheart_wall);
        wall.depth = depth - 20;
        wall.breakable = choose(1, 1, 1, 1, 1, 1, 0);
    }
}
if (attacktype == 3)
{
    var _speed = abs((fakecamxspeedbase + fakecamxspeedadditional) / 10);
    timer += _speed;
    switch (difficulty)
    {
        case 0:
            if (i_ex(new_box))
            {
                if (new_box.x < (camerax() + 640))
                {
                    queue_box(300, scr_get_box(5), 0);
                    var _words1;
                    with (instance_create((new_box.x + 150) - 30, 0, obj_orangeheart_word_manager))
                    {
                        timer_goal = 24;
                        timer = irandom(timer_goal - 1);
                        orangeheartControlled = true;
                        dir = choose(1, -1);
                        y = (cameray() + (cameraheight() * 0.5)) - (((cameraheight() * 0.5) + 30) * dir);
                        _words1 = id;
                    }
                    with (instance_create(new_box.x + 150 + 30, scr_get_box(5) + irandom_range(-50, 50), obj_orangeheart_helpful_flower))
                    {
                        depth = other.depth - 100;
                    }
                    with (_words1)
                    {
                        init();
                    }
                }
            }
            break;
        case 1:
            if (i_ex(new_box))
            {
                if (new_box.x < (camerax() + 640))
                {
                    queue_box(300, scr_get_box(5), 0);
                    var do_dir = choose(-1, 1);
                    var _words1;
                    with (instance_create(new_box.x + 115, 0, obj_orangeheart_word_manager))
                    {
                        b_speed = 7;
                        orangeheartControlled = true;
                        dir = do_dir;
                        y = (cameray() + (cameraheight() * 0.5)) - (((cameraheight() * 0.5) + 30) * dir);
                        _words1 = id;
                    }
                    var _words2;
                    with (instance_create(new_box.x + 185, 0, obj_orangeheart_word_manager))
                    {
                        b_speed = 7;
                        orangeheartControlled = true;
                        dir = do_dir;
                        y = (cameray() + (cameraheight() * 0.5)) - (((cameraheight() * 0.5) + 30) * dir);
                        _words2 = id;
                    }
                    with (instance_create(new_box.x + 150, scr_get_box(5) + irandom_range(-40, 40), obj_orangeheart_helpful_flower))
                    {
                        depth = other.depth - 100;
                    }
                    if (_words1.dir == _words2.dir)
                    {
                        _words1.timer_goal = 20;
                        _words2.timer_goal = 20;
                        var _newtimer = irandom(_words1.timer_goal - 1);
                        _words1.timer = _newtimer;
                        _words2.timer = _newtimer;
                    }
                    else
                    {
                        _words1.timer_goal = 20;
                        _words2.timer_goal = 20;
                    }
                    with (_words1)
                    {
                        init();
                    }
                    with (_words2)
                    {
                        init();
                    }
                }
            }
            break;
    }
}
if (attacktype == 4)
{
    timer++;
    if (timer == 1)
    {
        if (!instance_exists(obj_orangeheart_enemy))
        {
            instance_create(500, ((boxbot + boxtop) / 2) - 59, obj_orangeheart_enemy);
        }
    }
    if (((timer + 3) % 90) == 0)
    {
        makeBounceBall();
    }
}
if (attacktype == 5)
{
    timer++;
    if (timer == 1)
    {
        if (!instance_exists(obj_orangeheart_floweryjarona))
        {
            with (instance_create(cameray() + 500, ((boxbot + boxtop) / 2) - 59, obj_orangeheart_floweryjarona))
            {
                difficulty = other.difficulty;
                attack_speed = other.attack_speed;
                do_bullets = other.do_bullets;
                if (other.orange_dopple)
                {
                    orange_dopple = instance_create(x + 30, y + 110, obj_marker_fancy);
                    with (orange_dopple)
                    {
                        depth = other.depth;
                        sprite_index = spr_orange_animepunch_finished_cent;
                        image_speed = 1/3;
                        scr_darksize();
                    }
                }
            }
        }
        else
        {
            with (obj_orangeheart_floweryjarona)
            {
                difficulty = other.difficulty;
                attack_speed = other.attack_speed;
                do_bullets = other.do_bullets;
                if (other.orange_dopple)
                {
                    orange_dopple = instance_create(x + 30, y + 110, obj_marker_fancy);
                    with (orange_dopple)
                    {
                        depth = other.depth;
                        sprite_index = spr_orange_animepunch_finished_cent;
                        image_speed = 1/3;
                        scr_darksize();
                    }
                }
            }
        }
    }
}
with (obj_battleblcon)
{
    flowery_float = true;
}
