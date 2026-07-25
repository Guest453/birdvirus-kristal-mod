if (init == 0)
{
    sameattack = scr_monsterattacknamecount(global.monsterattackname[creator]);
    if (sameattack > 1)
    {
        if (creator == 2)
        {
            sameattacker = sameattack - 1;
        }
        else if (creator == 1)
        {
            sameattacker = (sameattack == 3) ? creator : (global.monsterattackname[0] == global.monsterattackname[1]);
        }
    }
    if (instance_exists(obj_growtangle))
    {
        miny = obj_growtangle.y - (obj_growtangle.sprite_height / 2);
        maxy = obj_growtangle.y + (obj_growtangle.sprite_height / 2);
        minx = obj_growtangle.x - (obj_growtangle.sprite_width / 2);
        maxx = obj_growtangle.x + (obj_growtangle.sprite_width / 2);
    }
    init = 1;
}
btimer += 1;
if (type == 0)
{
    if (btimer >= (timermax * ratio))
    {
        btimer = 0;
        var dir = 30 + random(120);
        radius = 140 + random(80);
        var xx = lengthdir_x(radius, dir);
        var yy = lengthdir_y(radius, dir);
        bm = instance_create(obj_heart.x + 8 + xx, obj_heart.y + 8 + yy, obj_dbullet_maker);
        bm.grazepoints = grazepoints;
        if (bm.y < (__view_get(e__VW.YView, 0) + 40))
        {
            bm.y = __view_get(e__VW.YView, 0) + 40;
        }
        bm.damage = damage;
        bm.target = target;
    }
}
if (type == 1)
{
    if (btimer >= (9 * ratio))
    {
        btimer = 0;
        radius = 140 + random(40);
        var yy = radius * side;
        var xx = -100 + random(200);
        var num = choose(0, 1, 2, 3);
        if (num == 3)
        {
            xx = -10 + random(20);
        }
        var d = instance_create(obj_heart.x + 8 + xx, obj_heart.y + 8 + yy, obj_dbullet_vert);
        d.damage = damage;
        d.target = target;
    }
}
if (type == 30.1)
{
    bmax = 34;
    if (special == 0 || btimer >= bmax)
    {
        special = 10 + irandom(20);
    }
    if (btimer >= bmax)
    {
        rab = instance_create(obj_growtangle.x + obj_growtangle.sprite_width + 10, obj_growtangle.y, obj_rabbitbullet);
        rab.hspeed = choose(3 + random(1), 3 + random(1), 6) * -1;
        if (rab.hspeed == -6)
        {
            rab.x += 50 + random(30);
        }
        scr_bullet_inherit(rab);
        btimer = 0;
    }
    if (btimer == special && i_ex(obj_netskie_enemy))
    {
        rab = instance_create(obj_growtangle.x + obj_growtangle.sprite_width + 10, obj_growtangle.y, obj_rabbitbullet);
        scr_bullet_inherit(rab);
        if (obj_netskie_enemy.netskie_count < 7)
        {
            rab.sprite_index = spr_rabbitbullet_netskie;
            rab.speed = choose(3 + random(1), 3 + random(1), 6);
            if (rab.speed == 6)
            {
                rab.x += 50 + random(30);
            }
        }
        obj_netskie_enemy.netskie_count++;
    }
}
if (type == 3)
{
    if (made == 0)
    {
        if (i_ex(creatorid))
        {
            with (creatorid)
            {
                image_alpha = 0;
            }
            var slasher = instance_create(creatorid.x, creatorid.y, obj_dknight_slasher);
            scr_bullet_inherit(slasher);
            slasher.timepoints = 2;
            slasher.grazepoints = 6;
        }
        made = 1;
    }
}
else if (type == 4 && (sameattack < 3 || creator < 2))
{
    if (btimer > 7)
    {
        btimer = 0;
        var xx = x - (made * 30);
        var yy = maxy;
        var d = instance_create(xx, yy, obj_chainbullet);
        d.damage = damage;
        d.grazepoints = 4;
        d.direction = 90;
        d.childSpeed = 7;
        d.childgravity = 0.25;
        d.firingSpeed = 2;
        d.target = target;
        d.sprite_index = spr_diamondbullet_vert;
        made++;
    }
}
else if (type == 30)
{
    if (btimer >= (20 * ratio))
    {
        var xx = __view_get(e__VW.XView, 0) - 20;
        if (side == 1)
        {
            xx = __view_get(e__VW.XView, 0) + 660;
        }
        var yy = miny + random(maxy - miny);
        bul = instance_create(xx, yy, obj_clubsbullet);
        bul.speed = 12;
        bul.damage = damage;
        bul.target = target;
        bul.grazepoints = 4;
        if (side == 1)
        {
            bul.direction = 180;
            bul.image_angle = 180;
        }
        btimer = 0;
    }
}
else if (type == 31)
{
    if (btimer >= (30 * ratio))
    {
        btimer = 0;
        var dir;
        if (side == -1)
        {
            dir = 225;
        }
        if (side == 1)
        {
            dir = 315;
        }
        radius = 400;
        var xx = lengthdir_x(radius, dir);
        var yy = lengthdir_y(radius, dir);
        var d = instance_create(obj_heart.x + 8 + xx, obj_heart.y + 8 + yy, obj_clubsbullet_dark);
        d.damage = damage;
        d.target = target;
        d.grazepoints = 4;
        d.direction = dir + 180;
        d.speed = 20;
        d.friction = 1;
        with (d)
        {
            image_angle = direction;
        }
        if (side == 1)
        {
            side = -1;
        }
        else
        {
            side = 1;
        }
    }
}
else if (type == 32)
{
    if (init == 1)
    {
        dd = 0;
        dd2 = 0;
        phase = 0;
        strikes = 0;
        if (special == 1)
        {
            global.turntimer = 5400;
        }
        var xx = obj_growtangle.x;
        var yy = obj_growtangle.y;
        var d = instance_create(xx + 1, yy, obj_bulletparent);
        d.sprite_index = spr_tm_grid;
        d.image_angle = 45;
        d.image_blend = c_gray;
        d.element = 6;
        d.depth = obj_growtangle.depth - 1;
        for (var i = 0; i < 4; i++)
        {
            xx = obj_growtangle.x;
            yy = obj_growtangle.y;
            if (i == 0 || i == 3)
            {
                yy += ((i == 0) ? -50 : 50);
            }
            else
            {
                xx += ((i == 1) ? -50 : 50);
            }
            d = instance_create(xx, yy, obj_bulletparent);
            d.sprite_index = spr_tm_letters;
            d.image_speed = 0;
            d.image_index = i;
            d.element = 6;
            d.image_blend = c_gray;
            d.depth = obj_growtangle.depth - 1;
        }
        obj_growtangle.target_angle = 45;
        obj_growtangle.image_angle = 45;
        d = scr_bullet_create(x - 22, y - 6, obj_tm_quizzler);
        made++;
        d.depth = global.monsterinstance[creator].depth;
        d.controller = self;
        d.element = 6;
        d.dojo = special < -2;
        d.creator = creator;
        global.monsterinstance[creator].lastQuizLetter = -1;
        d.difficulty = difficulty;
        init = 2;
        global.turntimer += 120;
        btimer = 0;
    }
    var attacktimer = 90;
    if (difficulty > 0)
    {
        attacktimer = (difficulty == 3) ? 40 : 60;
    }
    var quizReady = !instance_exists(obj_tm_quizzler);
    if ((made == 4 || special < -2) && quizReady && btimer >= 0)
    {
        if (special == 1)
        {
            special = -2;
            btimer = -20;
        }
        else if (special == -2)
        {
            special = -1;
            difficulty++;
            dd = scr_dark_marker_animated(x + 80, y + 4, spr_tm_pleased_effect, 1);
            dd2 = scr_dark_marker(x + 74, y + 66, spr_cutscene_26_tasquemanager);
            var _maru = instance_create(x + (phase * 40), y + 175, obj_bulletparent);
            _maru.sprite_index = spr_tm_maru;
            _maru.image_xscale = 2;
            _maru.image_yscale = 2;
            _maru = instance_create(obj_growtangle.x, obj_growtangle.y, obj_tm_quiz_result);
            _maru.sprite_index = spr_tm_maru_big;
            _maru.image_xscale = 3;
            _maru.image_yscale = 3;
            _maru.depth = obj_heart.depth - 15;
            _maru.max_time = 45;
            dd.depth = dd2.depth - 1;
            with (obj_tasque_manager_enemy)
            {
                visible = 0;
            }
            snd_play(snd_coin);
            btimer = -45;
            phase++;
        }
        else if (special == -1)
        {
            if (i_ex(dd))
            {
                instance_destroy(dd);
            }
            if (i_ex(dd2))
            {
                instance_destroy(dd2);
            }
            made = 0;
            with (obj_tasque_manager_enemy)
            {
                visible = 1;
            }
            if (strikes == 3)
            {
                global.flag[36] = 1;
                global.flag[39] = 1;
                global.turntimer = 10;
                btimer = -40;
                obj_tasque_manager_enemy.hspeed = 10;
                exit;
            }
            if (phase == 3)
            {
                special = -5;
                global.flag[39] = 1;
                global.turntimer = 10;
                btimer = -40;
                obj_tasque_manager_enemy.hspeed = 10;
            }
            else
            {
                special = 1;
                btimer = attacktimer - 10;
            }
        }
        else if (special == -4 && global.encounterno == 89)
        {
            special = -3;
            btimer = -20;
        }
        else if (special == -3)
        {
            special = -1;
            made = 4;
            dd2 = scr_dark_marker(x, y, spr_tm_hurt);
            with (obj_tasque_manager_enemy)
            {
                visible = 0;
            }
            snd_play(snd_error);
            if (global.encounterno == 89)
            {
                var _batsu = instance_create(x + (strikes * 40), y + 215, obj_bulletparent);
                _batsu.sprite_index = spr_tm_batsu;
                _batsu.image_xscale = 2;
                _batsu.image_yscale = 2;
                _batsu.element = 6;
                strikes++;
                btimer = -45;
                _batsu = instance_create(obj_growtangle.x, obj_growtangle.y, obj_tm_quiz_result);
                _batsu.sprite_index = spr_tm_batsu_big;
                _batsu.image_xscale = 3;
                _batsu.image_yscale = 3;
                _batsu.depth = obj_heart.depth - 15;
                _batsu.max_time = 45;
            }
        }
    }
    else if (quizReady && btimer > attacktimer && special >= 0 && made < 4)
    {
        if (special == 1)
        {
            made++;
        }
        var d = scr_bullet_create(x - 22, y - 6, obj_tm_quizzler);
        d.element = 6;
        d.creator = creator;
        d.controller = self;
        d.difficulty = difficulty;
        d.turnlength = 90;
        btimer = 0;
        if (special == 1)
        {
            d.dojo = true;
        }
    }
}
else if (type == 33)
{
    if (made == 0)
    {
        made = 1;
        tail = instance_create(obj_clubsenemy.x + 144, obj_clubsenemy.y + 125, obj_clovertail_intro);
        tail.damage = damage;
        tail.target = target;
    }
}
else if (type == 34)
{
    if (btimer >= (14 * (difficulty + 1)))
    {
        if (init == 1 || side == 1)
        {
            side = irandom(2);
            init = 2;
        }
        else
        {
            side = (side + irandom(1)) % 3;
        }
        snd_play_x(snd_spearappear, 1, 1.2);
        var d = instance_create(x, y, obj_werewerewire_laserbullet);
        d.grazepoints = 4;
        d.damage = damage;
        d.target = target;
        d.attackdirection = side;
        btimer = 0;
    }
}
else if (type == 35)
{
    if (init == 1)
    {
        global.turntimer = 3600;
        difficulty = 0;
        var xx = obj_growtangle.x;
        var yy = obj_growtangle.y;
        var d = instance_create(xx + 1, yy, obj_bulletparent);
        d.sprite_index = spr_tm_grid;
        d.image_angle = 45;
        d.image_blend = c_gray;
        d.depth = obj_growtangle.depth - 1;
        for (var i = 0; i < 4; i++)
        {
            xx = obj_growtangle.x;
            yy = obj_growtangle.y;
            if (i == 0 || i == 3)
            {
                yy += ((i == 0) ? -50 : 50);
            }
            else
            {
                xx += ((i == 1) ? -50 : 50);
            }
            d = instance_create(xx, yy, obj_bulletparent);
            d.sprite_index = spr_tm_letters;
            d.image_speed = 0;
            d.image_index = i;
            d.image_blend = c_gray;
            d.depth = obj_growtangle.depth - 1;
        }
        obj_growtangle.target_angle = 45;
        obj_growtangle.image_angle = 45;
        d = scr_bullet_create(x, y, obj_tm_quizzler);
        d.depth = global.monsterinstance[creator].depth;
        d.creator = creator;
        d.difficulty = difficulty;
        d.dojo = true;
        init = 2;
        global.turntimer += 120;
        btimer = 0;
    }
}
else if (type == 48)
{
    if (btimer >= 135 && !i_ex(obj_ch2_dojo_puzzlebullet_maker))
    {
        var xmod = 0;
        if (roundcount == 1)
        {
            xmod = irandom(20) * choose(-1, 1);
        }
        if (roundcount == 2)
        {
            xmod = irandom(30) * choose(-1, 1);
        }
        if (roundcount == 3)
        {
            xmod = irandom(40) * choose(-1, 1);
        }
        if (roundcount == 4)
        {
            xmod = irandom(60) * choose(-1, 1);
        }
        if (roundcount > 4)
        {
            xmod = irandom(80) * choose(-1, 1);
        }
        bm = instance_create(320 + xmod, 40, obj_ch2_dojo_puzzlebullet_maker);
        bm.grazepoints = grazepoints;
        bm.damage = 1;
        bm.target = target;
        switch (roundcount)
        {
            case 0:
                bm.times = 7;
                bm.timetarg = 18;
                bm.bulletspeed = 6;
                break;
            case 1:
                bm.times = 7;
                bm.timetarg = 15;
                bm.bulletspeed = 6;
                break;
            case 2:
                bm.times = 7;
                bm.timetarg = 13;
                bm.bulletspeed = 6;
                break;
            case 3:
                bm.times = 7;
                bm.timetarg = 11;
                bm.bulletspeed = 6;
                break;
            default:
                bm.times = 7;
                bm.timetarg = 10;
                bm.bulletspeed = 6;
                break;
        }
        btimer = 0;
        roundcount++;
    }
}
if (type == 49)
{
    if (btimer >= (timermax * ratio))
    {
        btimer = 0;
        var dir = 30 + random(120);
        radius = 140 + random(80);
        var xx = lengthdir_x(radius, dir);
        var yy = lengthdir_y(radius, dir);
        bm = instance_create(obj_heart.x + 8 + xx, obj_heart.y + 8 + yy, obj_dbullet_maker);
        bm.grazepoints = grazepoints;
        if (bm.y < (__view_get(e__VW.YView, 0) + 40))
        {
            bm.y = __view_get(e__VW.YView, 0) + 40;
        }
        bm.damage = damage;
        bm.target = target;
    }
}
if (type == 62)
{
    if (!made)
    {
        if (i_ex(creatorid))
        {
            creatorid.image_alpha = 0;
            var shadowman_tommygun_manager = instance_create(creatorid.x, creatorid.y - 10, obj_shadowman_tommygun);
            scr_bullet_inherit(shadowman_tommygun_manager);
            shadowman_tommygun_manager.dir = sameattacker;
            shadowman_tommygun_manager.sameattacker = sameattacker;
            shadowman_tommygun_manager.sameattack = sameattack;
            shadowman_tommygun_manager.creatorid = creatorid;
            shadowman_tommygun_manager.depth = creatorid.depth;
        }
        made = true;
    }
}
if (type == 140)
{
    if ((btimer - 90) >= ((10 * ratio) + (sameattacker * sameattack)))
    {
        btimer -= ((8 * ratio) + 3);
        var dir = 30 + random(120);
        radius = 140 + random(80);
        var xx = lengthdir_x(radius, dir);
        var yy = lengthdir_y(radius, dir);
        bm = instance_create(obj_heart.x + 8 + xx, obj_heart.y + 8 + yy, obj_dbullet_maker);
        bm.grazepoints = grazepoints;
        if (bm.y < (__view_get(e__VW.YView, 0) + 40))
        {
            bm.y = __view_get(e__VW.YView, 0) + 40;
        }
        bm.damage = damage;
        bm.target = target;
        if (special == 1)
        {
            bm.netskie = true;
        }
    }
}
if (type == 141)
{
    if (!made)
    {
        btimer = 0;
        made = true;
    }
    if ((btimer % ceil(31 * power(ratio, 1.28))) == (25 * sameattacker) && global.turntimer > 60)
    {
        with (creatorid)
        {
            maneanimcon = 1;
        }
        special = 10;
    }
    special--;
    if (special == 1)
    {
        snd_play_x(snd_board_throw, 0.7, 1);
        with (creatorid)
        {
            maneanimcon = 1;
        }
        var triangle_count = 12;
        with (instance_create(creatorid.x + 32, creatorid.y + 32, obj_mane))
        {
            alarm[0] = 45;
            targx = obj_growtangle.x + ((45 + random(40)) * choose(1, -1));
            targy = obj_growtangle.y + ((45 + random(40)) * choose(1, -1));
            hspeed = (targx - x) / alarm[0];
            vspeed = (targy - y) / alarm[0];
            gravity = 0.35;
            vspeed -= ((gravity * alarm[0]) / 2);
            for (var tempnum = 0; tempnum < (triangle_count / 2); tempnum++)
            {
                var _flip = -1 + (triangle_count % 2 && tempnum == 0);
                while (_flip <= 1)
                {
                    with (instance_create_depth(x, y, -10 - (tempnum % 2), obj_regularbullet))
                    {
                        damage = 92;
                        target = 4;
                        sprite_index = spr_triangle;
                        ds_list_add(other.triangles, id);
                        offset = 24 - (6 * (tempnum % 2));
                        image_angle = 90 + (_flip * 360 * ((tempnum + 0.5) / triangle_count));
                        x = other.x + lengthdir_x(offset, image_angle);
                        y = other.y + lengthdir_y(offset, image_angle);
                        destroyonhit = false;
                        active = false;
                        image_blend = merge_color(c_black, c_yellow, 0.3);
                    }
                    _flip += 2;
                }
            }
        }
    }
}
if (type == 142)
{
    if (!made)
    {
        target = -4;
        made = true;
        btimer = ceil(24 * ratio) - 1;
    }
    if ((btimer % ceil(24 * ratio)) == (4 * sameattacker) && i_ex(obj_growtangle))
    {
        randir = random(360);
        randist = random(25) + 65;
        target = instance_create(obj_growtangle.x + lengthdir_x(randist, randir), obj_growtangle.y + lengthdir_y(randist, randir), obj_bulletparent);
        target.num = 14 - (2 * ceil(power(ratio, 1.5)));
        target.basenum = target.num;
        target.basedir = random(360);
        target.flip = choose(1, -1);
        target.damage = 92;
        target.target = 4;
        with (target)
        {
            funct = function()
            {
                var petaldir = basedir + ((360 / basenum) * num);
                with (instance_create(x + lengthdir_x(7, petaldir), y + lengthdir_y(7, petaldir), obj_regularbullet))
                {
                    snd_stop(snd_noise);
                    snd_play_x(snd_noise, 0.25, 1.5);
                    grazepoints = 3;
                    flip = other.flip;
                    image_xscale = 2;
                    image_yscale = 2;
                    image_angle = petaldir;
                    active = false;
                    image_blend = c_gray;
                    sprite_index = spr_leafling_petal;
                    damage = 92;
                    target = 4;
                    
                    funct = function()
                    {
                        direction = image_angle;
                        scr_lerpvar("speed", 0, 4, 20);
                        spin = 1;
                        spinspeed = flip * 2.5;
                        anglechange = flip * 2.5;
                        active = true;
                        image_blend = c_white;
                        scr_lerpvar("anglechange", anglechange, 0, 50);
                        scr_lerpvar("spinspeed", spinspeed, 0, 50);
                        snd_stop(snd_explosion_firework);
                        snd_play(snd_explosion_firework, 1, 1);
                    };
                    
                    scr_script_delayed(scr_use_funct, other.num + 8);
                }
                if (num > 0)
                {
                    scr_script_delayed(scr_use_funct, 1);
                }
                num--;
            };
        }
        with (target)
        {
            scr_script_delayed(scr_use_funct, 1);
        }
    }
}
if (type == 143)
{
    if (!made)
    {
        made = true;
        if (!instance_exists(obj_windybox))
        {
            instance_create_depth(obj_growtangle.x - 100, obj_growtangle.y - 100, 3, obj_windybox);
        }
    }
    if ((btimer % (6 * ceil(ratio))) == 0 && i_ex(obj_growtangle))
    {
        with (scr_fire_bullet(obj_growtangle.x + 60, (obj_growtangle.y - 75) + random(150), obj_regularbullet, 20, 3, spr_leafling_petal))
        {
            updateimageangle = 1;
            gravity = speed / 25;
            speed += random(1);
            gravity_direction = direction + 180;
            depth = obj_growtangle.depth + 1;
            vspeed -= (0.8 - random(1));
            active = false;
            image_xscale = -1;
            image_yscale = 2;
            damage = 92;
            target = 4;
            grazepoints = 2.5;
            scr_lerpvar("image_xscale", 1, 0.5, 15);
            scr_script_delayed(scr_lerpvar_instance, 15, id, "image_xscale", 0.5, 3, 45);
            scr_script_delayed(scr_var, 30, "depth", 0);
            scr_script_delayed(scr_var, 30, "active", 1);
        }
    }
}
if (type == 144)
{
    if (!made)
    {
        made = true;
        if (sameattacker == 2 || sameattack == 1)
        {
            side = choose(0, 1);
        }
        else
        {
            side = sameattacker;
        }
    }
    if ((btimer % ceil(27 * ratio)) == (20 * sameattacker))
    {
        if (sameattacker == 2)
        {
            side = choose(0, 1);
        }
        var _angle = 180 * side;
        _angle = scr_approach(_angle, 90, random(75));
        var _dist = 160 + random(30);
        var choosey = obj_growtangle.y + 75 + lengthdir_y(_dist, _angle);
        var choosex = obj_growtangle.x + lengthdir_x(_dist, _angle);
        var shuriken = instance_create(choosex, choosey, obj_regularbullet);
        with (shuriken)
        {
            sprite_index = spr_shuriken;
            image_angle = choose(45, 0);
            damage = 92;
            target = 4;
            if (other.sameattacker == 2 || (other.sameattack == 1 && !irandom(2)) || (other.sameattack == 2 && !irandom(3)))
            {
                xtarg = obj_heart.x + 10;
                ytarg = obj_heart.y + 10;
            }
            else
            {
                xtarg = lerp((obj_growtangle.x - 70) + random(140), x, 0.2);
                ytarg = lerp((obj_growtangle.y - 70) + random(140), y, 0.2);
            }
            var _lifetime = ceil(clamp(power(point_distance(x, y, xtarg, ytarg), 0.85), 21, 52));
            with (scr_script_repeat(scr_var_add, _lifetime - 7, 0.5, "image_angle", 45))
            {
                scr_lerpvar("rate", rate, 10, _lifetime, 1, "out");
            }
            image_alpha = 0;
            scr_lerpvar("image_alpha", 0, 1, 10);
            hspeed = (2 * (xtarg - x)) / _lifetime;
            vspeed = (2 * (ytarg - y)) / _lifetime;
            destroyonhit = false;
            friction = speed / _lifetime;
            for (m = image_angle; m < 360; m += 90)
            {
                scr_script_delayed(scr_fire_bullet, _lifetime, xtarg + lengthdir_x(16, m), ytarg + lengthdir_y(16, m), 1427, m, 5 - sqrt(other.ratio), 4965, true, true);
            }
            scr_doom(id, _lifetime);
        }
    }
}
if (type == 144.5)
{
    if (!made && btimer > 103)
    {
        made = true;
        bullet = instance_create(obj_growtangle.x, obj_growtangle.y + 72, obj_dancing_beetle);
        bullet.sprite_index = spr_beetle_dancing;
        bullet.image_index = 0;
        bullet.image_speed = 0.16666666666666666;
        bullet.image_xscale = 1;
        bullet.image_yscale = 1;
        bullet.destroyonhit = 0;
        bullet.damage = 92;
        bullet.target = 4;
    }
}
if (type == 145)
{
    if (!made)
    {
        if (ratio == 1)
        {
            flip = choose(1, -1);
        }
        else
        {
            flip = sign(0.5 - (sameattacker % 2));
        }
        made = true;
        my_timer = -10;
    }
    my_timer++;
    if (i_ex(obj_seth_shi_controller))
    {
        ratio = 2.3;
    }
    if ((my_timer % ceil(10 + (40 * ratio))) == (24 * sameattacker) && global.turntimer > 110)
    {
        var delay = 15;
        var _ratio = ratio;
        flip *= -1;
        snd_stop(snd_petrify);
        snd_stop(snd_sneo_overpower);
        snd_play_x(snd_sneo_overpower, 0.7, 1);
        var _x, _y;
        if (sameattack == 1 && scr_monsterpop() > 1)
        {
            var _dir = point_direction(obj_heart.x, obj_heart.y, obj_growtangle.x, obj_growtangle.y);
            var _dist = 75 + random(10);
            _x = obj_heart.x + lengthdir_x(_dist, _dir);
            _y = obj_heart.y + lengthdir_y(_dist, _dir);
        }
        else if (irandom(3))
        {
            _x = (obj_growtangle.x + random(130)) - 65;
            _y = (obj_growtangle.y + random(130)) - 65;
        }
        else
        {
            _x = obj_heart.x + 10;
            _y = obj_heart.y + 10;
        }
        with (instance_create_depth(_x, _y, 3, obj_regularbullet))
        {
            sprite_index = spr_crosshair;
            image_blend = c_gray;
            active = false;
            damage = 92;
            target = 4;
            image_xscale = 2;
            image_yscale = 2;
            with (scr_doom(id, 40))
            {
                respects_platmode = false;
            }
        }
        with (creatorid)
        {
            state = 11;
            state10timer = 0;
        }
        with (instance_create(x + 26, y + 54, obj_regularbullet))
        {
            sprite_index = spr_scythebomb;
            image_xscale = 0;
            image_yscale = 0;
            image_blend = c_gray;
            active = false;
            damage = 92;
            target = 4;
            if (i_ex(obj_seth_shi_controller) && i_ex(obj_seth_shi_controller.aqua_marker))
            {
                depth = obj_seth_shi_controller.aqua_marker.depth - 999999;
            }
            scr_lerpvar("image_xscale", 0, 1, 7);
            scr_lerpvar("image_yscale", 0, 1, 7);
            image_speed = 1;
            destroyonhit = false;
            ratio = _ratio;
            flip = other.flip;
            spin = 1;
            spinspeed = 0;
            scr_script_delayed(scr_lerpvar, delay, "x", x, _x, 15, 1, "out");
            scr_script_delayed(scr_lerpvar, delay, "y", y, _y, 15, 1, "out");
            snd_play_delayed(496, delay, 0.8, 1.7);
            scr_script_delayed(scr_lerpvar, delay, "image_xscale", 1, 1.5, 8);
            scr_script_delayed(scr_lerpvar, delay, "image_yscale", 1, 1.5, 8);
            scr_script_delayed(scr_lerpvar, delay, "image_xscale", 2, 0.5, 18);
            scr_script_delayed(scr_lerpvar, delay, "image_yscale", 2, 0.5, 18);
            scr_script_delayed(scr_lerpvar, delay, "spinspeed", 15 * flip, flip, 30);
            lifetime = 90;
            scr_script_delayed(scr_use_funct, 40);
            
            funct = function()
            {
                active = true;
                image_blend = c_white;
                var _scythedir = scr_at_player() + (180 * flip);
                for (var dir = 45; dir < 360; dir += 90)
                {
                    with (instance_create_depth(x, y, depth + 1, obj_regularbullet))
                    {
                        snd_stop(snd_explosion_mmx);
                        snd_play_x(snd_explosion_mmx, 0.8, 0.7);
                        sprite_index = spr_scythe;
                        mydir = dir + _scythedir;
                        dist = 0;
                        image_xscale = 2;
                        image_yscale = 2;
                        destroyonhit = false;
                        flip = other.flip;
                        image_angle = dir;
                        grazepoints = 6;
                        damage = 92;
                        target = 4;
                        lifetime = 99;
                        life = lifetime;
                        range = 105;
                        scr_script_delayed(scr_use_funct, 1);
                        
                        funct = function()
                        {
                            mydir -= ((110 / lifetime) * power(2 - power(sin(max(0, life / lifetime) * pi), 1), 2) * (2 - (life / lifetime)) * flip);
                            dist = power(sin(max(0, life / lifetime) * pi), 1 - sin(max(0, life / lifetime) * pi)) * range;
                            life--;
                            image_angle = mydir * 7;
                            x = xstart + lengthdir_x(dist, mydir);
                            y = ystart + lengthdir_y(dist, mydir);
                            if (life == -5)
                            {
                                instance_destroy();
                            }
                            else
                            {
                                scr_script_delayed(scr_use_funct, 1);
                            }
                            if (life == 20)
                            {
                                scr_lerpvar("image_xscale", 1, 0, 24, 0, "in");
                                scr_lerpvar("image_yscale", 1, 0, 24, 0, "in");
                                scr_lerpvar("image_alpha", 1, 0, 18, 0, "in");
                                active = false;
                            }
                        };
                    }
                }
                scr_lerpvar("image_xscale", 3, 1.5, 12);
                scr_lerpvar("image_yscale", 3, 1.5, 12);
                scr_lerpvar("image_xscale", 0.75, 2.2, 7);
                scr_lerpvar("image_yscale", 0.75, 2.2, 7);
                scr_lerpvar("spinspeed", -15 * flip, 0, 20);
                scr_script_delayed(scr_lerpvar, 30, "image_xscale", 1.5, 0, lifetime - 40);
                scr_script_delayed(scr_lerpvar, 30, "image_yscale", 1.5, 0, lifetime - 40);
                scr_doom(id, lifetime);
            };
        }
    }
}
if (type == 146)
{
    if (i_ex(obj_growtangle))
    {
        if (((btimer - 12) % ceil(25 * ratio)) == (17 * sameattacker) || !made)
        {
            made = true;
            fails = 0;
            var test, _side;
            do
            {
                test = false;
                _side = 90 * irandom(3);
                with (obj_bullet_jumproach)
                {
                    if (_side == direction)
                    {
                        test = true;
                    }
                }
                fails++;
            }
            until (test == false || fails > 10);
            var _x = obj_growtangle.x + lengthdir_x(50, _side) + lengthdir_y(random(100) - 50, _side);
            var _y = obj_growtangle.y + lengthdir_y(50, _side) + lengthdir_x(random(100) - 50, _side);
            with (instance_create(_x, _y, obj_bullet_jumproach))
            {
                sound_play(snd_wing);
                direction = _side;
                speed = 17;
                image_angle = direction;
                shotspd = 8;
                if (other.sameattack <= 1)
                {
                    randomized = random(24) - 12;
                }
            }
        }
    }
}
if (type == 146.5)
{
    if (btimer > 99)
    {
        btimer -= 6;
        instance_create(minx - 6, (obj_growtangle.y - 30) + irandom(60), obj_roachbullet);
        instance_create(maxx + 6, (obj_growtangle.y - 30) + irandom(60), obj_roachbullet);
    }
}
if (type == 147)
{
    if (!made)
    {
        global.turntimer = 275;
        btimer = irandom(1500);
        made = true;
        rate = 0.4 - (0.1 * (sameattacker < scr_monsterpop()));
    }
    if ((btimer % ((3 + ceil(18 * ratio)) - (5 * (ratio == 1)))) == (3 * sameattacker))
    {
        with (instance_create(obj_growtangle.x - ((75 - (((9.7 * power(btimer, 1.1)) + (15 * sameattacker)) % 150)) * (sameattack > 0)), obj_growtangle.y - 140, obj_bullet_featherfall))
        {
            swing = (pi * power(other.btimer, 1.17)) / 69;
            rate = other.rate;
            arc -= (21 * (other.ratio == 1));
            self.dist += (16 * (other.ratio == 1));
        }
    }
}
if (type == 148 && i_ex(obj_growtangle))
{
    if (!made)
    {
        btimer = irandom(150);
        made = true;
        btimer = -10;
        var angle = 50;
        var dist = (180 / (1 + sameattack)) * (sameattacker + 1);
        var _x = obj_growtangle.x + 50 + (10 * sameattack) + lengthdir_x(dist, angle);
        var _y = obj_growtangle.y + 120 + (5 * sameattack) + lengthdir_y(dist, angle);
        with (creatorid)
        {
            angle = 50;
            dist = (180 / (1 + other.sameattack)) * (other.sameattacker + 1);
            _x = obj_growtangle.x + 50 + (10 * other.sameattack) + lengthdir_x(dist, angle);
            _y = obj_growtangle.y + 120 + (5 * other.sameattack) + lengthdir_y(dist, angle);
            scr_move_to_point_over_time(_x, _y, 4);
        }
        kawkaw = instance_create(_x, _y, obj_kawkaw_shooter);
        kawkaw.creatorid = creatorid;
        with (kawkaw)
        {
            visible = false;
        }
    }
    if (btimer == -6)
    {
        with (creatorid)
        {
            visible = false;
        }
        with (kawkaw)
        {
            visible = true;
        }
    }
    if ((btimer % ceil(59 * ratio)) == (30 * sameattacker))
    {
        with (kawkaw)
        {
            image_speed = 0.25;
        }
    }
    with (kawkaw)
    {
        if (image_index == 2)
        {
            snd_stop(snd_bird_licking_1);
            snd_stop(snd_bird_licking_2);
            snd_stop(snd_bird_licking_3);
            var a = choose(0, 1, 2);
            if (a == 0)
            {
                snd_play(snd_bird_licking_1);
            }
            if (a == 1)
            {
                snd_play(snd_bird_licking_2);
            }
            if (a == 2)
            {
                snd_play(snd_bird_licking_3);
            }
            tongue = 0.05;
            var _dir = clamp(scr_at_player(), 120, 150);
            var _max = 23 / sqrt(1 + other.ratio);
            var sinfact = 0.7853981633974483;
            var sinebase = random(pi);
            var _spread = 36;
            for (var iii = 0; iii < _max; iii++)
            {
                with (scr_fire_bullet(x, y, obj_bullet_kawkaw_sparkle, _dir + (_spread * sin(sinebase + (sinfact * iii)) * sqrt(abs(sin(sinebase + (sinfact * iii))))), 2.5 + (2 * random(iii / _max)) + (6 * (iii / _max)), spr_kawkaw_sparkle, false, true))
                {
                    alarm[0] = 180 + irandom(15);
                    spinspeed = -3 - random(3);
                    min_speed = speed / 6;
                    vspeed -= 2;
                    gravity = 0.1;
                    image_speed = 0.25;
                    image_index = instance_number(object_index) / 4;
                    damage = 92;
                    target = 4;
                    grazepoints = 5;
                }
            }
            repeat (12 / other.ratio)
            {
                with (instance_create_depth(x, y, 1, obj_kawkaw_streamer))
                {
                    var __dir = (135 + random(80)) - 40;
                    var _spd = 3 + sqrt(random(20));
                    _h = lengthdir_x(_spd, __dir);
                    _v = lengthdir_y(_spd, __dir);
                }
            }
        }
    }
}
if (type == 149)
{
    if (!made)
    {
        var dir = random(360);
        var dist = 160;
        with (scr_bullet_create(obj_growtangle.x + lengthdir_x(dist, dir), obj_growtangle.y + lengthdir_y(dist, dir), obj_bullet_foxtrot))
        {
            sameattacker = other.sameattacker;
            sameattack = other.sameattack;
            ratio = other.ratio;
            timer += ((cycle() / sameattack) * sameattacker);
            damage = 92;
            target = 4;
        }
        made = true;
    }
}
if (type == 150)
{
    if (!made)
    {
        controller = instance_create(x, y, obj_terracota_pots_controller);
        controller.difficulty = special;
        made = true;
    }
}
if (type >= 151 && type <= 153)
{
    sameattack = 0;
    for (var _sameattacki = 0; _sameattacki < 3; _sameattacki++)
    {
        if (global.monsterattackname[_sameattacki] == "scissor attack 1" && global.monster[_sameattacki] == 1)
        {
            sameattack++;
        }
    }
    if (!made && !i_ex(obj_sheary_smashcut_attack) && !i_ex(obj_sheary_smashcutter))
    {
        var _smashcut = instance_create(x - 20, mean(obj_growtangle.y, y), obj_sheary_smashcutter);
        scr_bullet_inherit(_smashcut);
        _smashcut.type = type - 150;
        _smashcut.do_flip = false;
        _smashcut.difficulty = sameattack - 1;
        made = true;
    }
}
if (type == 154)
{
    if (!made)
    {
        var _y = 1;
        if (sameattacker != 1)
        {
            _y *= -1;
        }
        made = true;
        with (instance_create((obj_growtangle.x - 10) + random(20), obj_growtangle.y + 1 + (68 * _y), obj_bullet_scarecrow1))
        {
            image_yscale = _y * 1.5;
        }
    }
}
if (type == 155 && sameattacker == 0)
{
    if (!made)
    {
        difficulty = 2;
        made = true;
        var spring = instance_create(obj_growtangle.x + 90, obj_growtangle.y + 82, obj_bullet_wheelspring);
        spring.difficult = difficulty;
        var scarecrow1 = instance_create(obj_growtangle.x + 90, obj_growtangle.y + 70, obj_bullet_scarecrow2);
        scarecrow1.high = 1;
        scarecrow1.parent = spring;
        var scarecrow2;
        if (sameattack > 1)
        {
            scarecrow2 = instance_create(obj_growtangle.x + 90, obj_growtangle.y + 70, obj_bullet_scarecrow2);
            scarecrow2.parent = scarecrow1;
            scarecrow2.high = 2;
        }
        if (sameattack > 2)
        {
            var scarecrow3 = instance_create(obj_growtangle.x + 90, obj_growtangle.y + 70, obj_bullet_scarecrow2);
            scarecrow3.parent = scarecrow2;
            scarecrow3.high = 3;
        }
    }
}
if (type == 400)
{
    if (!made)
    {
        with (obj_heart)
        {
            color = 2;
            sprite_index = spr_orangeheart;
            cam_x = 5;
        }
        with (obj_grazebox)
        {
            sprite_index = spr_grazeappear_yellow;
        }
        with (obj_growtangle)
        {
            var o = instance_create_depth(x, y, 10, obj_pathbox);
            o.alpha = -2.5;
            o.wait = 0;
            o.fade = 1;
            y -= 1000;
        }
        made = true;
        instance_create_depth(0, 0, 10, obj_fallboxdrawmanager);
        instance_create(0, 0, obj_heromover);
        var offset_last = 0;
        var bx = camerawidth() + 160;
        var by = obj_pathbox.y;
        var off = 10;
        var last_blue = 1;
        for (var i = 0; i < 10; i++)
        {
            var bullet_offset = irandom_range(-off, off);
            if (i == 0)
            {
                bullet_offset = 0;
            }
            else
            {
                while (abs(bullet_offset - offset_last) < (off / 2))
                {
                    bullet_offset = irandom_range(-off, off);
                }
                offset_last = bullet_offset;
            }
            var num = choose(1, 2);
            if (i > 5)
            {
                num = irandom_range(4, 7);
            }
            var blue = irandom_range(1, 3);
            while (blue == last_blue)
            {
                blue = irandom_range(1, 3);
            }
            last_blue = blue;
            for (ii = 0; ii < 5; ii++)
            {
                for (var iii = 0; iii < num; iii++)
                {
                    var o = instance_create_depth(bx + (iii * 15), (by + bullet_offset + (ii * 36)) - 72, obj_heart.depth + 1, obj_bullet_dashbar);
                    o.hspeed = -6;
                    o.image_xscale = 3;
                    if (ii == blue)
                    {
                        o.image_blend = c_aqua;
                    }
                }
            }
            if (i < 6)
            {
                bx += (100 + (num * 30) + (i * 10));
            }
            else
            {
                bx += (50 + (num * 30) + (i * 5));
            }
        }
        global.turntimer = ceil(bx / 8);
    }
}
if (type == 401)
{
    if (!made)
    {
        with (obj_heart)
        {
            color = 2;
            sprite_index = spr_orangeheart;
            cam_x = 2;
        }
        with (obj_grazebox)
        {
            sprite_index = spr_grazeappear_yellow;
        }
        with (obj_growtangle)
        {
            var o = instance_create_depth(x, y, 10, obj_pathbox);
            o.alpha = -2.5;
            o.wait = 0;
            o.fade = 1;
            o.flowers = 2;
            y -= 1000;
        }
        instance_create_depth(0, 0, 10, obj_fallboxdrawmanager);
        instance_create(0, 0, obj_heromover);
        instance_create(obj_heart.x - 600, 208, obj_attack_jarona);
        global.turntimer = 600;
        made = true;
    }
}
if (type == 402)
{
    if (!made)
    {
        with (obj_heart)
        {
            color = 2;
            sprite_index = spr_orangeheart;
        }
        with (obj_grazebox)
        {
            sprite_index = spr_grazeappear_yellow;
        }
        with (obj_growtangle)
        {
            var o = instance_create_depth(x, y, 10, obj_pathbox);
            o.alpha = -2.5;
            o.wait = 0;
            o.fade = 1;
            o.flowers = 2;
            y -= 1000;
        }
        instance_create_depth(0, 0, 10, obj_fallboxdrawmanager);
        instance_create(0, 0, obj_heromover);
        if (i_ex(creatorid))
        {
            with (creatorid)
            {
                image_alpha = 0;
            }
            var shooter = instance_create(creatorid.x, creatorid.y, obj_flowery_shooter);
            scr_bullet_inherit(shooter);
        }
        global.turntimer = 450;
        made = true;
    }
}
if (type == 403)
{
    if (!made)
    {
        with (obj_heart)
        {
            color = 2;
            sprite_index = spr_orangeheart;
        }
        with (obj_grazebox)
        {
            sprite_index = spr_grazeappear_yellow;
        }
        with (obj_growtangle)
        {
            var o = instance_create_depth(x, y, 10, obj_fallingbox);
            o._xs = 75;
            o._ys = 75;
            o.alpha = 0;
            o.wait = 15;
            o.fade = 1;
            y -= 1000;
        }
        for (var i = 0; i < 15; i++)
        {
            var o = instance_create(100 + irandom_range(-5, 5), (i * 12.5) + irandom_range(-5, 5), obj_flower_wall);
            o.timer = i * 5;
            o = instance_create(100 + irandom_range(-5, 5), (320 - (i * 12.5)) + irandom_range(-5, 5), obj_flower_wall);
            o.timer = i * 5;
        }
        made = true;
        instance_create_depth(0, 0, 10, obj_fallboxdrawmanager);
        instance_create(0, 0, obj_heromover);
        if (scr_debug())
        {
            global.turntimer = 9999999;
        }
    }
    if ((btimer % 40) == 20)
    {
        var o = instance_create(room_width + max(0, abs(obj_heart.x_offset)) + 120, 150 + (50 * sin(btimer / 50)), obj_fallingbox);
        o._xs = irandom_range(20, 70);
        o._ys = irandom_range(40, 80);
    }
}
if (type == 410)
{
    if (!made)
    {
        with (obj_heart)
        {
            color = 2;
            sprite_index = spr_orangeheart;
        }
        with (obj_grazebox)
        {
            sprite_index = spr_grazeappear_yellow;
        }
        with (obj_growtangle)
        {
            var o = instance_create(x, y, obj_fallingbox);
            o._xs = 75;
            o._ys = 75;
            o.alpha = 0;
            o.wait = 15;
            o.fade = 1;
            y -= 1000;
        }
        for (var i = 0; i < 15; i++)
        {
            var o = instance_create(100 + irandom_range(-5, 5), (i * 12.5) + irandom_range(-5, 5), obj_flower_wall);
            o.timer = i * 5;
            o = instance_create(100 + irandom_range(-5, 5), (320 - (i * 12.5)) + irandom_range(-5, 5), obj_flower_wall);
            o.timer = i * 5;
        }
        made = true;
        instance_create_depth(0, 0, 10, obj_fallboxdrawmanager);
        instance_create(0, 0, obj_heromover);
        if (scr_debug())
        {
            global.turntimer = 9999999;
        }
    }
    if ((btimer % 40) == 20)
    {
        with (instance_create(room_width + 120, 150, obj_fallingbox))
        {
            mytime = other.btimer;
            move = true;
            maxspd = 4;
        }
    }
}
if (type == 125)
{
    if (!made)
    {
        var ___x = 540;
        var ___y = 180;
        knifechain1 = instance_create(___x, ___y, obj_attack_knifechain_manager);
        knifechain1.side = 0;
        knifechain1.rotatespeed = 16 + irandom(3);
        knifechain2 = instance_create(___x, ___y, obj_attack_knifechain_manager);
        knifechain2.side = 1;
        knifechain2.rotatespeed = 16 + irandom(3);
        made = 1;
    }
}
if (type == 126)
{
    if (!made)
    {
        var ___x = 540;
        var ___y = 180;
        knifefan = instance_create(___x, ___y, obj_attack_knifefan);
        made = 1;
    }
}
if (type == 127)
{
    if (!made)
    {
        made = true;
        var d = instance_create(x, y, obj_attack_orange_simplesin);
    }
}
if (type == 128)
{
    if (!made)
    {
        made = true;
        var d = instance_create(x, y, obj_attack_orange_dragonpunch);
    }
}
if (type == 129)
{
    if (!made)
    {
        made = true;
        var d = instance_create(x, y, obj_attack_blue_ponddancing);
        d.type = 2;
    }
}
if (type == 130)
{
    if (!made)
    {
        made = true;
        var d = instance_create(x, y, obj_attack_blue_ponddancing);
        d.type = 1;
    }
}
if (type == 131)
{
    if (!made)
    {
        with (obj_green_enemy)
        {
            visible = false;
        }
        instance_create(x, y, obj_attack_green_cookingtime);
        made = true;
    }
}
if (type == 199)
{
    if (made == 0)
    {
        made = 1;
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        with (obj_growtangle)
        {
            if (!i_ex(obj_purplecontrols))
            {
                instance_create_depth(x, y, 4, obj_purplecontrols);
            }
            obj_purplecontrols.mode = 1;
        }
    }
}
if (type == 132)
{
    if (!made)
    {
        global.turntimer = 615;
        made = true;
        var d = instance_create_depth(x, y, -1, obj_attack_orange_superattack);
    }
}
if (type == 200)
{
    var _bullet_speed_modifier = 4/3;
    var _bullet_interval_modifier = 1.25;
    var _heart_tension_value = 1;
    if (made == 0)
    {
        made = 1;
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        with (obj_grazebox)
        {
            grazetimefactor = 0;
        }
        with (obj_growtangle)
        {
            if (!i_ex(obj_purplecontrols))
            {
                instance_create_depth(x, y, 4, obj_purplecontrols);
            }
            obj_purplecontrols.mode = 1;
            with (instance_create_depth(x + 200, y, depth - 5, obj_pink_battlemovement))
            {
                mode = 1;
                air_time = 1;
                sprite_index = spr_pink_ball;
                image_speed = 1;
                dest_x = other.x;
                dest_y = other.y - 118;
            }
        }
        btimer_start = btimer;
        tension_value = 1;
        if (i_ex(obj_pink_enemy))
        {
            difficulty = obj_pink_enemy.difficulty;
        }
        switch (difficulty)
        {
            case 0:
                tension_value = 1;
                var _d_mild = 1.1;
                var _s_mild = 0.75;
                var _d_medium = 1;
                var _s_medium = 0.9;
                var _d_spicy = 0.95;
                var _s_spicy = 4/3;
                ds_list_add(obj_purplecontrols.ds_bullet_list, 0, 1, _d_mild, _s_mild, 2, 1, _d_mild, _s_mild, 1, 1, _d_mild, _s_mild, 0, 1, _d_mild, _s_mild, 2, 1, 3.75, _s_mild, 7, -1, _d_mild * 0.75, _s_mild * 0.9, 6, -1, _d_mild * 0.75, _s_mild * 0.9, 7, -1, _d_mild * 0.75, _s_mild * 0.9, 8, -1, _d_mild * 0.75, _s_mild * 0.9, 7, -1, _d_mild * 0.75, _s_mild * 0.9, 8, -1, _d_mild * 0.75, _s_mild * 0.9, 7, -1, 4.5, _s_mild * 0.9, 2.1, 1, _d_medium, _s_medium, 1.1, 1, _d_medium, _s_medium, 0.1, 1, _d_medium, _s_medium, 1.1, 1, _d_medium, _s_medium, 2.1, 1, _d_medium, _s_medium, 0.1, 1, _d_medium, _s_medium, 1.1, 1, _d_medium, _s_medium, 2.1, 1, _d_medium, _s_medium, 1.1, 1, 4, _s_medium, 7, -1, 0, _s_spicy, 0, -1, 0, _s_spicy, 2, -1, _d_spicy, _s_spicy, 8, -1, 0, _s_spicy, 1, -1, 0, _s_spicy, 0, -1, _d_spicy, _s_spicy, 7, -1, 0, _s_spicy, 2, -1, 0, _s_spicy, 0, -1, _d_spicy, _s_spicy, 6, -1, 0, _s_spicy, 1, -1, 0, _s_spicy, 2, -1, _d_spicy, _s_spicy, 7, -1, 0, _s_spicy, 0, -1, 0, _s_spicy, 2, -1, _d_spicy, _s_spicy, 6, -1, 0, _s_spicy, 2, -1, 0, _s_spicy, 1, -1, _d_spicy, _s_spicy, 7, -1, 0, _s_spicy, 0, -1, 0, _s_spicy, 2, -1, _d_spicy, _s_spicy, 8, -1, 0, _s_spicy, 1, -1, 0, _s_spicy, 0, -1, _d_spicy, _s_spicy, 7, -1, 0, _s_spicy, 2, -1, 0, _s_spicy, 0, -1, _d_spicy, _s_spicy, 8, -1, 0, _s_spicy, 0, -1, 0, _s_spicy, 1, -1, _d_spicy, _s_spicy, 7, -1, 0, _s_spicy, 0, -1, 0, _s_spicy, 2, -1, _d_spicy, _s_spicy, 6, -1, 0, _s_spicy, 2, -1, 0, _s_spicy, 1, -1, 0.01, _s_spicy);
                break;
            case 1:
                tension_value = 1;
                var _d_beat = 0.95;
                ds_list_add(obj_purplecontrols.ds_bullet_list, 7, 1, 0, 0.9, 0, 1, 0, 0.9, 2, 1, _d_beat, 0.9, 8, -1, 0, 0.9, 0, -1, 0, 0.9, 1, -1, _d_beat, 0.9, 7, 1, 0, 0.9, 0, 1, 0, 0.9, 2, 1, _d_beat, 0.9, 6, -1, 0, 0.9, 1, -1, 0, 0.9, 2, -1, _d_beat, 0.9, 7, 1, 0, 0.9, 0, 1, 0, 0.9, 2, 1, _d_beat, 0.9, 8, -1, 0, 0.9, 0, -1, 0, 0.9, 1, -1, _d_beat, 0.9, 7, 1, 0, 0.9, 0, 1, 0, 0.9, 2, 1, _d_beat, 0.9, 6, -1, 0, 0.9, 1, -1, 0, 0.9, 2, -1, 3, 0.9, 2, 1, 0, 0.9, 0.1, -1, 0.5, 0.9, 2, 1, 0, 0.9, 0, -1, 1, 0.9, 0, 1, 0, 0.9, 1.1, -1, 0.5, 0.9, 0, 1, 0, 0.9, 1, -1, 1, 0.9, 2.1, 1, 0, 0.9, 0, -1, 0.5, 0.9, 2, 1, 0, 0.9, 0, -1, 1, 0.9, 1.1, 1, 0, 0.9, 2, -1, 0.5, 0.9, 1, 1, 0, 0.9, 2, -1, 1, 0.9, 0.1, 1, 0, 0.9, 0, -1, 0.5, 0.9, 0, 1, 0, 0.9, 0, -1, 1, 0.9, 2, 1, 0, 0.9, 1.1, -1, 0.5, 0.9, 2, 1, 0, 0.9, 1, -1, 1, 0.9, 1, 1, 0, 0.9, 2.1, -1, 0.5, 0.9, 1, 1, 0, 0.9, 2, -1, 1, 0.9, 2, 1, 0, 0.9, 0.1, -1, 0.5, 0.9, 2, 1, 0, 0.9, 0, -1, 1, 0.9, 1, 1, 0, 0.9, 1.1, -1, 0.5, 0.9, 1, 1, 0, 0.9, 1, -1, 3, 0.9, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 3, 1, 0, 1, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 0.05, 1.5, 0, 1, 0.05, 1.5, 2, -1, 5, 1.5);
                break;
            case 2:
                tension_value = 1;
                var _d_conga = 0.667;
                var _s_conga = 1.1;
                i = 0;
                repeat (3)
                {
                    var _d_conga_last;
                    if (i < 2)
                    {
                        _d_conga_last = _d_conga * (4/3);
                    }
                    else
                    {
                        _d_conga_last = 0.01;
                    }
                    ds_list_add(obj_purplecontrols.ds_bullet_list, 1, 1, _d_conga * (2/3), _s_conga, 7, 1, _d_conga * (2/3), _s_conga, 7, 1, _d_conga * (2/3), _s_conga, 1, 1, _d_conga * (4/3), _s_conga, 4, 1, 0, 1, 0, -1, _d_conga * (2/3), _s_conga, 6, -1, _d_conga * (2/3), _s_conga, 6, -1, _d_conga * (2/3), _s_conga, 0, -1, _d_conga * (4/3), _s_conga, 1, 1, _d_conga * (2/3), _s_conga, 7, 1, _d_conga * (2/3), _s_conga, 7, 1, _d_conga * (2/3), _s_conga, 1, 1, _d_conga * (4/3), _s_conga, 2, -1, _d_conga * (2/3), _s_conga, 8, -1, _d_conga * (2/3), _s_conga, 8, -1, _d_conga * (2/3), _s_conga, 2, -1, _d_conga_last, _s_conga);
                    _d_conga = _d_conga * 0.875;
                    _s_conga += 0.16;
                    i++;
                }
                break;
            case 3:
                tension_value = 1;
                var _hflip = choose(1, -1);
                var _vflip = choose(0, 2);
                var _binterval = 0.75;
                var _bspeed = 1;
                ds_list_add(obj_purplecontrols.ds_bullet_list, abs(_vflip - 2) + 0.1, 1 * _hflip, _binterval, _bspeed, abs(_vflip - 0), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 1), 1 * _hflip, _binterval, _bspeed, abs(_vflip - 2) + 0.1, -1 * _hflip, _binterval, _bspeed, abs(_vflip - 0), 1 * _hflip, _binterval * 0.5, _bspeed, 4, 1, _binterval * 0.5, 1, abs(_vflip - 2), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 1) + 0.1, 1 * _hflip, _binterval, _bspeed, abs(_vflip - 0), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 2), 1 * _hflip, _binterval, _bspeed, abs(_vflip - 1) + 0.1, -1 * _hflip, _binterval, _bspeed, abs(_vflip - 2), 1 * _hflip, _binterval, _bspeed, abs(_vflip - 0), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 1) + 0.1, 1 * _hflip, _binterval, _bspeed, abs(_vflip - 0), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 1), 1 * _hflip, _binterval * 0.5, _bspeed, 4, 1, _binterval * 0.5, 1, abs(_vflip - 2) + 0.1, -1 * _hflip, _binterval, _bspeed, abs(_vflip - 0), 1 * _hflip, _binterval, _bspeed, abs(_vflip - 2), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 1) + 0.1, 1 * _hflip, _binterval, _bspeed, abs(_vflip - 0), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 2), 1 * _hflip, _binterval, _bspeed, abs(_vflip - 0) + 0.1, -1 * _hflip, _binterval, _bspeed, abs(_vflip - 1) + 0.1, 1 * _hflip, _binterval, _bspeed, abs(_vflip - 2), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 0), 1 * _hflip, _binterval * 0.5, _bspeed, 5, 1, _binterval * 0.5, 1, abs(_vflip - 2) + 0.1, -1 * _hflip, _binterval, _bspeed, abs(_vflip - 1), 1 * _hflip, _binterval, _bspeed, abs(_vflip - 0), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 2) + 0.1, 1 * _hflip, _binterval, _bspeed, abs(_vflip - 1), -1 * _hflip, _binterval, _bspeed, abs(_vflip - 2), 1 * _hflip, _binterval, _bspeed, abs(_vflip - 0) + 0.1, -1 * _hflip, 11.5, _bspeed);
                break;
            default:
                tension_value = 1;
                var _d_mild = 1.1;
                var _s_mild = 0.75;
                var _d_medmild = 1.025;
                var _s_medmild = 0.85;
                var _d_medium = 0.98;
                var _s_medium = 1;
                var _d_spicy = 0.95;
                var _s_spicy = 4/3;
                var _rand;
                _rand[0] = choose(0, 2);
                _rand[1] = choose(0, 2);
                _rand[2] = choose(0, 2);
                _rand[3] = choose(0, 2);
                _rand[4] = choose(0, 2);
                var _rside = choose(-1, 1);
                ds_list_add(obj_purplecontrols.ds_bullet_list, abs(0 - _rand[0]) + 0.1, -1 * _rside, _d_mild, _s_mild, abs(1 - _rand[0]) + 0.1, -1 * _rside, _d_mild, _s_mild, abs(2 - _rand[0]) + 0.1, -1 * _rside, _d_mild, _s_mild, abs(1 - _rand[0]) + 0.1, -1 * _rside, _d_mild, _s_mild, abs(choose(0, 2) - _rand[0]) + 0.1, -1 * _rside, 3.75, _s_mild);
                if (irandom(1) == 0)
                {
                    ds_list_add(obj_purplecontrols.ds_bullet_list, abs(1 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(0 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(1 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(2 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(1 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(2 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(1 - _rand[1]) + 0.1, 1 * _rside, 4.5, _s_medmild);
                }
                else
                {
                    ds_list_add(obj_purplecontrols.ds_bullet_list, abs(1 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(0 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(1 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(0 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(1 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(2 - _rand[1]) + 0.1, 1 * _rside, _d_medmild, _s_medmild, abs(1 - _rand[1]) + 0.1, 1 * _rside, 4.5, _s_medmild);
                }
                if (irandom(1) == 0)
                {
                    ds_list_add(obj_purplecontrols.ds_bullet_list, abs(1 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(0 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(2 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(1 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(0 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(1 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(2 - _rand[2]) + 0.1, -1 * _rside, 4, _s_medium);
                }
                else
                {
                    ds_list_add(obj_purplecontrols.ds_bullet_list, abs(1 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(0 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(1 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(2 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(0 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(1 - _rand[2]) + 0.1, -1 * _rside, _d_medium, _s_medium, abs(2 - _rand[2]) + 0.1, -1 * _rside, 4, _s_medium);
                }
                ds_list_add(obj_purplecontrols.ds_bullet_list, abs(1 - _rand[3]) + 6, 1 * _rside, 0, _s_spicy, abs(0 - _rand[3]), 1 * _rside, 0, _s_spicy, abs(2 - _rand[3]), 1 * _rside, _d_spicy, _s_spicy, abs(2 - _rand[3]) + 6, 1 * _rside, 0, _s_spicy, abs(1 - _rand[3]), 1 * _rside, 0, _s_spicy, abs(0 - _rand[3]), 1 * _rside, _d_spicy, _s_spicy, abs(1 - _rand[3]) + 6, 1 * _rside, 0, _s_spicy, abs(2 - _rand[3]), 1 * _rside, 0, _s_spicy, abs(0 - _rand[3]), 1 * _rside, _d_spicy, _s_spicy, abs(0 - _rand[3]) + 6, 1 * _rside, 0, _s_spicy, abs(1 - _rand[3]), 1 * _rside, 0, _s_spicy, abs(2 - _rand[3]), 1 * _rside, _d_spicy, _s_spicy, abs(1 - _rand[3]) + 6, 1 * _rside, 0, _s_spicy, abs(0 - _rand[3]), 1 * _rside, 0, _s_spicy, abs(2 - _rand[3]), 1 * _rside, _d_spicy, _s_spicy, abs(_rand[4] - _rand[3]) + 6, 1 * _rside, 0, _s_spicy, abs(((_rand[4] + 1) % 3) - _rand[3]), 1 * _rside, 0, _s_spicy, abs(((_rand[4] + 2) % 3) - _rand[3]), 1 * _rside, _d_spicy, _s_spicy, abs(1 - _rand[3]) + 6, 1 * _rside, 0, _s_spicy, abs(2 - _rand[3]), 1 * _rside, 0, _s_spicy, abs(0 - _rand[3]), 1 * _rside, _d_spicy, _s_spicy, abs(2 - _rand[3]) + 6, 1 * _rside, 0, _s_spicy, abs(0 - _rand[3]), 1 * _rside, 0, _s_spicy, abs(1 - _rand[3]), 1 * _rside, _d_spicy, _s_spicy, abs(1 - _rand[3]) + 6, 1 * _rside, 0, _s_spicy, abs(0 - _rand[3]), 1 * _rside, 0, _s_spicy, abs(2 - _rand[3]), 1 * _rside, _d_spicy, _s_spicy);
                break;
        }
        global.turntimer = 70;
        var i = 0;
        repeat (floor(ds_list_size(obj_purplecontrols.ds_bullet_list) / 4))
        {
            global.turntimer += round(0.5 + ((13 * ds_list_find_value(obj_purplecontrols.ds_bullet_list, 2 + i)) / _bullet_interval_modifier));
            i += 4;
        }
    }
    var _box_x = camera_get_view_x(view_camera[0]) + 320;
    var _box_y = camera_get_view_y(view_camera[0]) + 240;
    if (instance_exists(obj_growtangle))
    {
        _box_x = scr_get_box(4);
        _box_y = scr_get_box(5);
    }
    if (instance_exists(obj_purplecontrols))
    {
        if (ds_exists(obj_purplecontrols.ds_bullet_list, ds_type_list))
        {
            do
            {
                if (btimer >= (btimer_start + 15))
                {
                    if (ds_list_size(obj_purplecontrols.ds_bullet_list) > 0)
                    {
                        btimer -= round(0.5 + ((13 * ds_list_find_value(obj_purplecontrols.ds_bullet_list, 2)) / _bullet_interval_modifier));
                        if (ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0) < 3)
                        {
                            var _side = ds_list_find_value(obj_purplecontrols.ds_bullet_list, 1);
                            var _bul = scr_fire_bullet(_box_x + (_side * 416), _box_y + (floor(ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0) - 1) * 56), obj_pinkcatbullet, 90 + (_side * 90), 8 * ds_list_find_value(obj_purplecontrols.ds_bullet_list, 3) * _bullet_speed_modifier);
                            if (ds_list_find_value(obj_purplecontrols.ds_bullet_list, 3) >= 1.5)
                            {
                                _bul.spin_radius = 1.5;
                            }
                            var i = 0;
                            repeat (frac(ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0)) * 10)
                            {
                                i++;
                                _bul = scr_fire_bullet(_box_x + (_side * (416 - (i * 72 * ds_list_find_value(obj_purplecontrols.ds_bullet_list, 3)))), _box_y + (floor(ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0) - 1) * 56), obj_dokiheart, 90 + (_side * 90), 8 * ds_list_find_value(obj_purplecontrols.ds_bullet_list, 3) * _bullet_speed_modifier);
                                _bul.tension_value = tension_value;
                                _bul.image_xscale = 1.5;
                                _bul.image_yscale = 1.5;
                                _bul.visual_scale = 2/3;
                            }
                        }
                        else if (ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0) >= 6 && ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0) <= 8)
                        {
                            var _side = ds_list_find_value(obj_purplecontrols.ds_bullet_list, 1);
                            var _bul = scr_fire_bullet(_box_x + (_side * 416), _box_y + ((ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0) - 7) * 56), obj_dokiheart, 90 + (_side * 90), 8 * ds_list_find_value(obj_purplecontrols.ds_bullet_list, 3) * _bullet_speed_modifier);
                            _bul.tension_value = tension_value;
                            _bul.image_xscale = 2.5;
                            _bul.image_yscale = 2.5;
                            _bul.visual_scale = 0.4;
                        }
                        else
                        {
                            switch (ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0))
                            {
                                case 3:
                                    with (obj_pink_battlemovement)
                                    {
                                        mode = 2;
                                        phase = 0;
                                    }
                                    break;
                                case 4:
                                    with (obj_pink_battlemovement)
                                    {
                                        mode = 3;
                                        phase = 0;
                                    }
                                    break;
                                case 5:
                                    with (obj_pink_battlemovement)
                                    {
                                        mode = 4;
                                        phase = 0;
                                    }
                                    break;
                            }
                        }
                        ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                        ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                        ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                        ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                    }
                }
                if (ds_list_size(obj_purplecontrols.ds_bullet_list) < 4)
                {
                    ds_list_clear(obj_purplecontrols.ds_bullet_list);
                    break;
                }
            }
            until (btimer < (btimer_start + 15));
        }
    }
}
if (type == 201)
{
    if (made == 0)
    {
        made = 1;
        ammo = 4;
        grid_x = irandom(3);
        grid_y = irandom(3);
        pattern_variant = irandom(3);
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        with (obj_growtangle)
        {
            if (!i_ex(obj_purplecontrols))
            {
                instance_create_depth(x, y, 4, obj_purplecontrols);
            }
            obj_purplecontrols.mode = 2;
        }
        global.turntimer = 155;
    }
    var _box_x = camera_get_view_x(view_camera[0]) + 320;
    var _box_y = camera_get_view_y(view_camera[0]) + 240;
    if (instance_exists(obj_growtangle))
    {
        _box_x = scr_get_box(4);
        _box_y = scr_get_box(5);
    }
    if (ammo > 0)
    {
        if (btimer >= 6)
        {
            var _lane_distance = 40;
            ammo--;
            btimer = 0;
            snd_play(snd_whip_throw_only);
            var _bomb = instance_create((_box_x - (_lane_distance * 1.5)) + (grid_x * _lane_distance), (_box_y - (_lane_distance * 1.5)) + (grid_y * _lane_distance), obj_fusebomb);
            _bomb.fuse_time = 120 + (ammo * 2);
            _bomb.grid_x = grid_x;
            _bomb.grid_y = grid_y;
            switch (irandom(1))
            {
                case 1:
                    if (pattern_variant < 2)
                    {
                        grid_x++;
                        grid_y++;
                    }
                    else
                    {
                        grid_x--;
                        grid_y++;
                    }
                    break;
                default:
                    switch (pattern_variant)
                    {
                        case 0:
                            grid_x++;
                            break;
                        case 1:
                            grid_y++;
                            break;
                        case 2:
                            grid_x--;
                            break;
                        default:
                            grid_y++;
                    }
            }
            if (grid_x >= 4)
            {
                grid_x -= 4;
            }
            else if (grid_x < 0)
            {
                grid_x += 4;
            }
            if (grid_y >= 4)
            {
                grid_y -= 4;
            }
            else if (grid_y < 0)
            {
                grid_y += 4;
            }
        }
    }
}
if (type == 202)
{
    if (!i_ex(obj_growtangle))
    {
        exit;
    }
    var _fill_bulletlist = false;
    if (made == 0)
    {
        made = 1;
        phase = 0;
        life_time = 0;
        pattern_phase = 0;
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        with (obj_grazebox)
        {
            grazetimefactor = 0;
        }
        with (obj_growtangle)
        {
            instance_create_depth(x, y, 4, obj_purplecontrols);
            obj_purplecontrols.mode = 3;
            obj_purplecontrols.lane_x = 0;
            obj_purplecontrols.lane_y = 0;
            if (other.difficulty == 1)
            {
                with (obj_pink_battlemovement)
                {
                    instance_destroy();
                }
                with (instance_create_depth(x + 200, y, depth - 5, obj_pink_battlemovement))
                {
                    mode = 1;
                    air_time = 1;
                    sprite_index = spr_pink_ball;
                    image_speed = 1;
                    dest_x = other.x;
                    dest_y = other.y - 118;
                }
            }
        }
        instance_create_depth(x, y, 200, obj_purplebg);
        btimer2 = -210;
        pattern_dir = irandom(3) * 90;
        box_v_stable = camera_get_view_y(view_camera[0]) + 240;
        if (instance_exists(obj_growtangle))
        {
            box_v_stable = scr_get_box(5);
        }
        if (i_ex(obj_pink_enemy))
        {
            difficulty = obj_pink_enemy.difficulty;
        }
        _fill_bulletlist = true;
        if (difficulty == 1 || difficulty == 0)
        {
            switch (difficulty)
            {
                case 0:
                case 2:
                    with (obj_purplecontrols)
                    {
                        can_spin = false;
                    }
                    with (obj_purplebg)
                    {
                        visible = false;
                    }
                    break;
                case 1:
                    with (obj_purplecontrols)
                    {
                        can_spin = false;
                    }
                    global.turntimer = 700;
                    btimer = -180;
                    ammo = 6;
                    break;
            }
        }
    }
    if (btimer == -173)
    {
        with (instance_create_depth(camera_get_view_x(view_camera[0]) + 32, scr_get_box(5) + 96, 10, obj_huge_anime_face))
        {
            difficulty = other.difficulty;
        }
    }
    with (obj_purplecontrols)
    {
        if (rotate_speed == 0)
        {
            other.box_v_stable = scr_get_box(5);
        }
        if (other.difficulty == 1 && ds_list_size(ds_bullet_list) < 4 && other.ammo > 0)
        {
            other.ammo--;
            _fill_bulletlist = true;
        }
    }
    if (_fill_bulletlist)
    {
        switch (difficulty)
        {
            case 0:
                var _d_tuning = 0.95;
                var _s_tuning = 1.1;
                var _speed_v = _s_tuning * 1;
                var _speed_h = _speed_v * 1.15;
                var _speed_h1_final = 1.5;
                var _speed_h2_final = 2;
                var _speed_v_final = 2.5;
                ds_list_add(obj_purplecontrols.ds_bullet_list, 2, 270, _d_tuning * 0.525, _speed_v * 1.2, 1, 270, _d_tuning * 0.525, _speed_v * 1.2, 0, 270, _d_tuning * 0.8, _speed_v * 1.2, 1, 180, _d_tuning * 0.45, _speed_h * 1.25, 7, 180, 0, _speed_h * 1.25, 4, 180, _d_tuning * 0.9, _speed_h * 1.25, 6, 90, 0, _speed_v * 1.4, 2, 90, _d_tuning * 0.45, _speed_v * 1.4, 1, 90, _d_tuning * 0.45, _speed_v * 1.4, 8, 90, 0, _speed_v * 1.4, 0, 90, _d_tuning * 0.8, _speed_v * 1.4, 1, 0, _d_tuning * 0.15, _speed_h * 1.4, 7, 0, _d_tuning * 0.25, _speed_h * 1.4, 4, 0, _d_tuning * 0.5, _speed_h * 1.4, 1, 90, _d_tuning * 0.9, _speed_v * 1.3, 6, 180, 0, _speed_v * (2/3), 1, 180, _d_tuning * 0.9, _speed_v * (2/3), 6, 270, 0, _speed_v * (2/3), 1, 270, _d_tuning * 0.9, _speed_v * (2/3), 6, 0, 0, _speed_v * (2/3), 1, 0, _d_tuning * 1.7, _speed_v * (2/3), 4, 0, _d_tuning * 0.15, _speed_h * _speed_h1_final, 4, 0, _d_tuning * 0.15, _speed_h * ((_speed_h1_final * 0.8571428571428571) + (_speed_h2_final * 0.14285714285714285)), 4, 0, _d_tuning * 0.15, _speed_h * ((_speed_h1_final * 0.7142857142857143) + (_speed_h2_final * 0.2857142857142857)), 4, 0, _d_tuning * 0.05, _speed_h * ((_speed_h1_final * 0.5714285714285714) + (_speed_h2_final * 0.42857142857142855)), 0, 90, 0, _speed_v * _speed_v_final, 0, 270, 0, _speed_v * _speed_v_final, 4, 0, _d_tuning * 0.05, _speed_h * ((_speed_h1_final * 0.42857142857142855) + (_speed_h2_final * 0.5714285714285714)), 0, 90, 0, _speed_v * _speed_v_final, 0, 270, 0, _speed_v * _speed_v_final, 4, 0, _d_tuning * 0.05, _speed_h * ((_speed_h1_final * 0.2857142857142857) + (_speed_h2_final * 0.7142857142857143)), 0, 90, 0, _speed_v * _speed_v_final, 0, 270, 0, _speed_v * _speed_v_final, 4, 0, _d_tuning * 0.05, _speed_h * ((_speed_h1_final * 0.14285714285714285) + (_speed_h2_final * 0.8571428571428571)), 0, 90, 0, _speed_v * _speed_v_final, 0, 270, 0, _speed_v * _speed_v_final, 4, 0, _d_tuning * 0.05, _speed_h * _speed_h2_final, 0, 90, 0, _speed_v * _speed_v_final, 0, 270, 99, _speed_v * _speed_v_final);
                global.turntimer = 385;
                btimer = 32;
                break;
            case 2:
                with (obj_purplecontrols)
                {
                    can_spin = false;
                }
                with (obj_purplebg)
                {
                    visible = false;
                }
                var _d_tuning = 0.95;
                var _s_tuning = 1.1;
                var _speed_v = _s_tuning * 1;
                var _speed_h = _speed_v * 1.2;
                var _speed_strays = 1.4;
                var _speed_bursts = 1.65;
                var _d_bursts = 0.12;
                ds_list_add(obj_purplecontrols.ds_bullet_list, 0, 270, _d_tuning * 0.5, _speed_v * _speed_strays, 1, 270, _d_tuning * 0.25, _speed_v * _speed_strays, 2, 0, 0, _speed_h * _speed_strays, 8, 270, _d_tuning * 0.25, _speed_v * _speed_strays, 2, 270, _d_tuning * 0.25, _speed_v * _speed_strays, 1, 0, _d_tuning * 0.25, _speed_h * _speed_strays, 7, 0, 0, _speed_h * _speed_strays, 0, 90, _d_tuning * 0.25, _speed_v * _speed_strays, 0, 0, _d_tuning * 0.25, _speed_h * _speed_strays, 1, 90, _d_tuning * 0.25, _speed_v * _speed_strays, 7, 90, 0, _speed_v * _speed_strays, 2, 180, _d_tuning * 0.25, _speed_h * _speed_strays, 2, 90, _d_tuning * 0.25, _speed_v * _speed_strays, 1, 180, _d_tuning * 0.25, _speed_h * _speed_strays, 6, 180, _d_tuning * 0.25, _speed_h * _speed_strays, 0, 180, _d_tuning * 0.5, _speed_h * _speed_strays, 1, 0, 0, _speed_h * _speed_bursts, 1, 180, _d_tuning * _d_bursts, _speed_h * _speed_bursts, 1, 0, 0, _speed_h * _speed_bursts, 1, 180, _d_tuning * _d_bursts, _speed_h * _speed_bursts, 1, 0, 0, _speed_h * _speed_bursts, 1, 180, _d_tuning * 0.5, _speed_h * _speed_bursts, choose(6, 8), choose(90, 270), 0, _speed_v * _speed_bursts, 1, 90, 0, _speed_v * _speed_bursts, 1, 270, _d_tuning * _d_bursts, _speed_v * _speed_bursts, 1, 90, 0, _speed_v * _speed_bursts, 1, 270, _d_tuning * _d_bursts, _speed_v * _speed_bursts, 1, 90, 0, _speed_v * _speed_bursts, 1, 270, 99, _speed_v * _speed_bursts);
                global.turntimer = 200;
                btimer = 32;
                break;
            case 1:
                var _delay = 0.3;
                var _speed_v = 0.9;
                var _speed_h = 1;
                var _speed_12 = 1.5;
                var _speed_3 = 1.25;
                var _dir = irandom(3) * 90;
                var _diradd = choose(-90, 90);
                var _shot = choose(0, 1, 2);
                var _doki_queue = 0;
                var _doki_dist = 1;
                var _nextdelay = 1.2;
                var _speed_final;
                if (_dir == 90 || _dir == 270)
                {
                    _speed_final = _speed_v * _speed_12;
                }
                else
                {
                    _speed_final = _speed_h * _speed_12;
                }
                ds_list_add(obj_purplecontrols.ds_bullet_list, _shot, _dir, _delay, _speed_final);
                var _shot_prev = _shot;
                var _dir_prev = _dir;
                var _spd_prev = _speed_final;
                switch (_shot)
                {
                    case 0:
                        _shot = choose(0, 1);
                        break;
                    case 1:
                        _shot = choose(0, 2);
                        break;
                    case 2:
                        _shot = choose(1, 2);
                        break;
                }
                _dir = scr_wrap(_dir + (_diradd * choose(1, 2)));
                if (_dir == 90 || _dir == 270)
                {
                    _speed_final = _speed_v * _speed_12;
                }
                else
                {
                    _speed_final = _speed_h * _speed_12;
                }
                _shot_prev = _shot;
                _dir_prev = _dir;
                switch (_shot)
                {
                    case 0:
                        _shot = choose(0, 1);
                        break;
                    case 1:
                        _shot = choose(0, 1);
                        break;
                    case 2:
                        _shot = choose(0, 1);
                        break;
                }
                _dir = scr_wrap(_dir + (_diradd * choose(1, 2)));
                if (_dir == 90 || _dir == 270)
                {
                    _speed_final = _speed_v * _speed_3;
                }
                else
                {
                    _speed_final = _speed_h * _speed_3;
                }
                if (_shot_prev == 1 && _shot == 5 && (_dir == (_dir_prev + 90) || _dir == (_dir_prev - 270)))
                {
                    _shot = 4;
                }
                var _heartshot;
                switch (_shot)
                {
                    case 0:
                    case 1:
                    case 2:
                        _heartshot = _shot + 6;
                        break;
                    case 3:
                        _heartshot = 7;
                        break;
                    case 4:
                        _heartshot = 6 + choose(0, 2);
                        break;
                    case 5:
                        _heartshot = 7;
                        break;
                }
                if (_shot_prev == 1 && ((_heartshot == 6 && (_dir == (_dir_prev + 90) || _dir == (_dir_prev - 270))) || (_heartshot == 8 && (_dir == (_dir_prev - 90) || _dir == (_dir_prev + 270)))))
                {
                    _doki_queue = 1;
                }
                if ((_dir == (_dir_prev + 180) || _dir == (_dir_prev - 180)) && ((_shot_prev == 0 && _heartshot == 8) || (_shot_prev == 1 && _heartshot == 7) || (_shot_prev == 2 && _heartshot == 6)))
                {
                    _doki_queue = 1;
                }
                if (_doki_queue == 0)
                {
                    ds_list_add(obj_purplecontrols.ds_bullet_list, _shot_prev, _dir_prev, _delay * (1 - _doki_dist), _spd_prev);
                }
                else
                {
                    ds_list_add(obj_purplecontrols.ds_bullet_list, _shot_prev, _dir_prev, _delay, _spd_prev);
                }
                if (_doki_queue == 0)
                {
                    ds_list_add(obj_purplecontrols.ds_bullet_list, _heartshot, _dir, _delay * _doki_dist, _speed_final);
                }
                if (_doki_queue != 1)
                {
                    ds_list_add(obj_purplecontrols.ds_bullet_list, _shot, _dir, _nextdelay, _speed_final);
                }
                else
                {
                    ds_list_add(obj_purplecontrols.ds_bullet_list, _shot, _dir, _delay * _doki_dist, _speed_final);
                    switch (_shot)
                    {
                        case 0:
                        case 1:
                        case 2:
                            _heartshot = _shot + 6;
                            break;
                        case 3:
                            _heartshot = 7;
                            break;
                        case 4:
                            _heartshot = 6 + choose(0, 2);
                            break;
                        case 5:
                            _heartshot = 7;
                            break;
                    }
                    ds_list_add(obj_purplecontrols.ds_bullet_list, _heartshot, _dir, _nextdelay - (_delay * (1 - _doki_dist)), _speed_final);
                }
                break;
        }
    }
    if (instance_exists(obj_growtangle))
    {
        if (btimer >= 40)
        {
            do
            {
                var _bdir = pattern_dir;
                var _blane = -1;
                choose(2, 4);
                var _binterval = 0.8;
                var _bspeed = 10;
                var _bullet_scale = 2;
                var _shootdist = 352;
                if (instance_exists(obj_purplecontrols))
                {
                    if (ds_exists(obj_purplecontrols.ds_bullet_list, ds_type_list))
                    {
                        if (ds_list_size(obj_purplecontrols.ds_bullet_list) >= 3)
                        {
                            _bdir = ds_list_find_value(obj_purplecontrols.ds_bullet_list, 1);
                            _blane = ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0);
                            _binterval = ds_list_find_value(obj_purplecontrols.ds_bullet_list, 2) * 0.8;
                            _bspeed = ds_list_find_value(obj_purplecontrols.ds_bullet_list, 3) * 8;
                            ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                            ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                            ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                            ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                        }
                        if (ds_list_size(obj_purplecontrols.ds_bullet_list) < 4)
                        {
                            ds_list_clear(obj_purplecontrols.ds_bullet_list);
                            if (difficulty != 1)
                            {
                                btimer = -999;
                            }
                        }
                    }
                }
                btimer = 40 - floor(0.5 + (40 * _binterval));
                if (_blane <= 5 && _blane >= 0)
                {
                    var _bul = scr_fire_bullet(scr_get_box(4) + lengthdir_x(_shootdist, _bdir + 180), scr_get_box(5) + lengthdir_y(_shootdist, _bdir + 180), obj_pinklanebullet, _bdir, _bspeed);
                    _bul.image_xscale = _bul.image_xscale * _bullet_scale;
                    _bul.image_yscale = _bul.image_yscale * _bullet_scale;
                    _bul.depth = depth - 10;
                    var _lanebuldist = 52;
                    switch (_blane)
                    {
                        case 0:
                        case 3:
                        case 4:
                            _bul.x += lengthdir_x(_lanebuldist, _bdir + 270);
                            _bul.y += lengthdir_y(_lanebuldist, _bdir + 270);
                            _bul.sprite_index = spr_pinklanebullet_lane;
                            _bul.image_angle += 180;
                            break;
                        case 2:
                            _bul.x += lengthdir_x(_lanebuldist, _bdir + 90);
                            _bul.y += lengthdir_y(_lanebuldist, _bdir + 90);
                            _bul.sprite_index = spr_pinklanebullet_lane;
                            break;
                    }
                    _bul.image_angle += _bdir;
                    if (_blane >= 3 && _blane < 6)
                    {
                        _bul = scr_fire_bullet(scr_get_box(4) + lengthdir_x(_shootdist, _bdir + 180), scr_get_box(5) + lengthdir_y(_shootdist, _bdir + 180), obj_pinklanebullet, _bdir, _bspeed);
                        _bul.image_xscale = _bul.image_xscale * _bullet_scale;
                        _bul.image_yscale = _bul.image_yscale * _bullet_scale;
                        _bul.depth = depth - 10;
                        switch (_blane)
                        {
                            case 4:
                            case 5:
                                _bul.x += lengthdir_x(_lanebuldist, _bdir + 90);
                                _bul.y += lengthdir_y(_lanebuldist, _bdir + 90);
                                _bul.sprite_index = spr_pinklanebullet_lane;
                                break;
                        }
                        _bul.image_angle += _bdir;
                    }
                }
                if (_blane >= 6)
                {
                    var _lanebuldist = 66;
                    var _bul = instance_create_depth(scr_get_box(4) + lengthdir_x(_shootdist, _bdir + 180), scr_get_box(5) + lengthdir_y(_shootdist, _bdir + 180), depth - 11, obj_dokiheart);
                    _bul.tension_value = 3;
                    _bul.image_xscale = 3;
                    _bul.image_yscale = 3;
                    _bul.visual_scale = 2/3;
                    _bul.direction = _bdir;
                    _bul.speed = _bspeed;
                    switch (_blane)
                    {
                        case 6:
                        case 9:
                        case 10:
                            _bul.x += lengthdir_x(_lanebuldist, _bdir + 270);
                            _bul.y += lengthdir_y(_lanebuldist, _bdir + 270);
                            break;
                        case 8:
                            _bul.x += lengthdir_x(_lanebuldist, _bdir + 90);
                            _bul.y += lengthdir_y(_lanebuldist, _bdir + 90);
                            break;
                    }
                }
                pattern_dir += choose(90, 270);
                if (pattern_dir >= 360)
                {
                    pattern_dir -= 360;
                }
            }
            until (btimer < 40);
        }
    }
    if (difficulty != 1)
    {
        life_time++;
        if (life_time <= 8)
        {
            with (obj_purplecontrols)
            {
                y += 8;
                tire_y += 8;
            }
            with (obj_growtangle)
            {
                y += 8;
            }
            with (obj_heart)
            {
                y += 8;
            }
            with (obj_collidebullet)
            {
                y += 8;
            }
            with (obj_dokiheart)
            {
                y += 8;
            }
        }
    }
    if (difficulty == 1)
    {
        life_time++;
        switch (phase)
        {
            case 0:
                with (obj_purplecontrols)
                {
                    if (rotate_speed != 0)
                    {
                        other.life_time = 255;
                    }
                }
                if (life_time >= 28)
                {
                    with (obj_pink_battlemovement)
                    {
                        snd_play(snd_pink_laugh_long);
                        sprite_index = spr_pink_front_ohoho;
                    }
                    life_time = -5;
                    phase++;
                }
                break;
            case 1:
                with (obj_purplecontrols)
                {
                    if (rotate_speed != 0)
                    {
                        other.life_time = 255;
                    }
                }
                if (life_time >= 60)
                {
                    with (obj_pink_battlemovement)
                    {
                        image_speed = 0;
                    }
                }
                if (life_time >= 90)
                {
                    with (obj_pink_battlemovement)
                    {
                        sprite_index = spr_pink_front_surprised;
                    }
                    life_time = 0;
                    phase++;
                }
                break;
            case 2:
                with (obj_purplecontrols)
                {
                    if (rotate_speed != 0)
                    {
                        other.life_time = 255;
                    }
                }
                if (life_time >= 50)
                {
                    with (obj_pink_battlemovement)
                    {
                        if (instance_exists(obj_growtangle))
                        {
                            dest_x = scr_get_box(4);
                        }
                        dest_y = y;
                        mode = 6;
                    }
                    life_time = 0;
                    btimer = 0;
                    phase++;
                }
                break;
        }
    }
}
if (type == 203)
{
    var _bullet_interval_modifier = 1;
    if (made == 0)
    {
        if (i_ex(obj_pink_enemy))
        {
            difficulty = obj_pink_enemy.difficulty;
        }
        with (obj_pink_battlemovement)
        {
            instance_destroy();
        }
        made = 1;
        grid_x = irandom(3);
        grid_y = irandom(3);
        pattern_variant = irandom(3);
        pattern_repeat = 0;
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        with (obj_grazebox)
        {
            grazetimefactor = 0;
        }
        with (obj_growtangle)
        {
            if (!instance_exists(obj_purplecontrols))
            {
                instance_create_depth(x, y, 4, obj_purplecontrols);
                obj_purplecontrols.mode = 2;
            }
            y += 32;
            with (instance_create_depth(x + 200, y - 32, depth - 5, obj_pink_battlemovement))
            {
                mode = 5;
                sprite_index = spr_pink_idle;
                image_speed = 0.334;
                grid_x = -1;
                grid_y = -1;
            }
        }
        btimer_start = btimer;
        show_debug_message("THIS IS PATTERN OF BOMBINGS: " + string(difficulty));
        switch (difficulty)
        {
            case 0:
                ds_list_add(obj_purplecontrols.ds_bullet_list, 0, 1.05, 0, 0, 0, 1.05, 0, 0, 0, 0.98, 0, 0, 0, 0, 0, 1.1, 0, 0, 0, 0, 0, 0.98, 0, 0, 0, 0, 0, 0.97, 0, 0, 0, 0, 0, 0, 0, 1.25, 1, 0);
                break;
            case 1:
                ds_list_add(obj_purplecontrols.ds_bullet_list, 0, 0.85, 0, 0.7, 0, 0.6, 0, 0.6, 0, 0, 0, 0.8, 0, 0, 0, 0.65, 0, 0, 0, 0, 0, 1.25, 1, 0);
                break;
            case 2:
                ds_list_add(obj_purplecontrols.ds_bullet_list, 3, 1.25, 3, 1.25, 3, 1.25, 3, 1.5, 4, 3);
                break;
            case 3:
                ds_list_add(obj_purplecontrols.ds_bullet_list, 0, 0, 0, 1.05, 0, 0, 0, 0, 0, 1.05, 0, 0, 0, 0, 0, 1.05, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0.975, 0, 0, 0, 0, 0, 0, 0, 0.875, 2, 1.5, 1, 0);
                break;
            case 4:
                ds_list_add(obj_purplecontrols.ds_bullet_list, 0, 0.85, 0, 0.7, 0, 0.6, 0, 0.6, 0, 0, 0, 0.8, 0, 0, 0, 0.65, 0, 0, 0, 0, 0, 0.9, 2, 1.5, 1, 0);
                break;
        }
        global.turntimer = 50;
        var i = 0;
        repeat (floor(ds_list_size(obj_purplecontrols.ds_bullet_list) / 2))
        {
            global.turntimer += round(0.5 + ((45 * ds_list_find_value(obj_purplecontrols.ds_bullet_list, 1 + i)) / _bullet_interval_modifier));
            i += 2;
        }
    }
    var _startdelay = 0;
    if (instance_exists(obj_purplecontrols))
    {
        if (ds_exists(obj_purplecontrols.ds_bullet_list, ds_type_list))
        {
            if (ds_list_size(obj_purplecontrols.ds_bullet_list) > 0)
            {
                do
                {
                    if (btimer >= (btimer_start + _startdelay))
                    {
                        if (ds_list_size(obj_purplecontrols.ds_bullet_list) > 0)
                        {
                            btimer -= round(0.5 + ((45 * ds_list_find_value(obj_purplecontrols.ds_bullet_list, 1)) / _bullet_interval_modifier));
                            switch (ds_list_find_value(obj_purplecontrols.ds_bullet_list, 0))
                            {
                                case 0:
                                    with (obj_pink_battlemovement)
                                    {
                                        if (ds_list_size(list_bomb) <= 0)
                                        {
                                            ammo_doki = 0;
                                        }
                                        ds_list_add(list_bomb, 0);
                                        ammo_doki++;
                                    }
                                    break;
                                case 1:
                                    with (obj_pink_battlemovement)
                                    {
                                        snd_play(snd_pink_laugh_long);
                                        sprite_index = spr_pink_laugh;
                                        image_index = 0;
                                        image_speed = 0.5;
                                    }
                                    break;
                                case 2:
                                    with (obj_pink_battlemovement)
                                    {
                                        ds_list_add(list_bomb, 1);
                                    }
                                    break;
                                case 3:
                                    with (obj_pink_battlemovement)
                                    {
                                        var _list_xy = ds_list_create();
                                        var _randompattern = choose(0, 0, 1, 1, 2);
                                        switch (_randompattern)
                                        {
                                            case 0:
                                                var _rn;
                                                _rn[1] = 3 + irandom(1);
                                                _rn[0] = max(-1, _rn[1] - 4 - irandom(1));
                                                ds_list_add(_list_xy, -2, _rn[0], -2, _rn[1], 1 + irandom(2), -2, 5, _rn[1]);
                                                break;
                                            case 1:
                                                var _rn;
                                                _rn[2] = 1 + irandom(1);
                                                _rn[1] = 3 + irandom(1);
                                                _rn[0] = max(-1, _rn[1] - 4 - irandom(1));
                                                ds_list_add(_list_xy, -2, _rn[0], 5, _rn[1], _rn[2], -2, _rn[2], 4);
                                                break;
                                            case 2:
                                                var _rn;
                                                _rn[2] = 1 + irandom(1);
                                                _rn[1] = 3 + irandom(1);
                                                _rn[0] = max(-1, _rn[1] - 4 - irandom(1));
                                                ds_list_add(_list_xy, -2, -1, 4, -2, 5, 4 - choose(0, 1, 1), -1 + choose(0, 1, 1), 5);
                                                break;
                                        }
                                        var _list_order = ds_list_create();
                                        ds_list_add(_list_order, 0, 1, 2, 3);
                                        ds_list_shuffle(_list_order);
                                        var _xsign = 1;
                                        var _xoffset = 0;
                                        if (irandom(1) == 1)
                                        {
                                            _xsign = -1;
                                            _xoffset = 3;
                                        }
                                        var _ysign = 1;
                                        var _yoffset = 0;
                                        if (irandom(1) == 1)
                                        {
                                            _ysign = -1;
                                            _yoffset = 3;
                                        }
                                        var _xrotate = 0;
                                        var _yrotate = 1;
                                        if (irandom(1) == 1)
                                        {
                                            _xrotate = 1;
                                            _yrotate = 0;
                                        }
                                        ds_list_add(list_bomb_xy, _xoffset + (_xsign * ds_list_find_value(_list_xy, (ds_list_find_value(_list_order, 0) * 2) + _xrotate)), _yoffset + (_ysign * ds_list_find_value(_list_xy, (ds_list_find_value(_list_order, 0) * 2) + _yrotate)), _xoffset + (_xsign * ds_list_find_value(_list_xy, (ds_list_find_value(_list_order, 1) * 2) + _xrotate)), _yoffset + (_ysign * ds_list_find_value(_list_xy, (ds_list_find_value(_list_order, 1) * 2) + _yrotate)), _xoffset + (_xsign * ds_list_find_value(_list_xy, (ds_list_find_value(_list_order, 2) * 2) + _xrotate)), _yoffset + (_ysign * ds_list_find_value(_list_xy, (ds_list_find_value(_list_order, 2) * 2) + _yrotate)), _xoffset + (_xsign * ds_list_find_value(_list_xy, (ds_list_find_value(_list_order, 3) * 2) + _xrotate)), _yoffset + (_ysign * ds_list_find_value(_list_xy, (ds_list_find_value(_list_order, 3) * 2) + _yrotate)));
                                        ds_list_destroy(_list_order);
                                        ds_list_destroy(_list_xy);
                                        switch (irandom(3))
                                        {
                                            case 0:
                                                ds_list_add(list_bomb, 4, 2, 2, 2);
                                                break;
                                            case 1:
                                                ds_list_add(list_bomb, 2, 4, 2, 2);
                                                break;
                                            case 2:
                                                ds_list_add(list_bomb, 2, 2, 4, 2);
                                                break;
                                            default:
                                                ds_list_add(list_bomb, 2, 2, 2, 4);
                                        }
                                    }
                                    break;
                                case 4:
                                    with (obj_pink_battlemovement)
                                    {
                                        ds_list_add(list_bomb, 3);
                                    }
                                    break;
                            }
                            ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                            ds_list_delete(obj_purplecontrols.ds_bullet_list, 0);
                        }
                    }
                    if (ds_list_size(obj_purplecontrols.ds_bullet_list) < 2)
                    {
                        ds_list_clear(obj_purplecontrols.ds_bullet_list);
                        break;
                    }
                }
                until (btimer < (btimer_start + _startdelay));
            }
        }
    }
}
if (type == 204)
{
    if (made == 0)
    {
        made = 1;
        if (i_ex(obj_pink_enemy))
        {
            difficulty = obj_pink_enemy.difficulty;
        }
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        var _box_xscale = 1.125;
        var _box_yscale = 1.5;
        with (obj_growtangle)
        {
            if (!i_ex(obj_purplecontrols))
            {
                instance_create_depth(x, y, 4, obj_purplecontrols);
            }
            obj_purplecontrols.mode = 4;
            obj_purplecontrols.lane_x = 0;
            image_xscale *= _box_xscale;
            image_yscale *= _box_yscale;
        }
        global.turntimer = 390;
        bullet_lane = choose(0, 1);
        btimer_start = btimer;
        switch (difficulty)
        {
            default:
                b_interval[0] = 7;
                b_number[0] = 3;
                b_break[0] = -30;
                b_speed[0] = 3.2;
                b_interval[1] = 10;
                b_number[1] = 2;
                b_break[1] = -36;
                b_speed[1] = 2;
                b_interval[2] = 36;
                b_number[2] = 1;
                b_break[2] = -24;
                b_speed[2] = 1.25;
                break;
        }
        btimer_array[2] = b_interval[2] - 2;
        btimer_array[1] = b_interval[1] - 2;
        btimer_array[0] = b_interval[0] - 2;
        btimer_array_decimal[2] = 0;
        btimer_array_decimal[1] = 0;
        btimer_array_decimal[0] = 0;
        if (instance_exists(obj_growtangle))
        {
            instance_create_depth(scr_get_box(4) - 63, scr_get_box(1) - 8, -1, obj_roundbellbullet);
        }
    }
    var _pattern_speed_modifier = 1;
    switch (difficulty)
    {
        case 0:
            _pattern_speed_modifier = 1;
            break;
        case 1:
            _pattern_speed_modifier = 1.2;
            break;
        default:
            _pattern_speed_modifier = 1.5;
    }
    if (instance_exists(obj_growtangle))
    {
        btimer_array_decimal[0] += _pattern_speed_modifier;
        do
        {
            if (btimer_array_decimal[0] >= 1)
            {
                btimer_array_decimal[0] -= 1;
                btimer_array[0]++;
                if (btimer_array[0] > 0)
                {
                    if ((btimer_array[0] % b_interval[0]) == (b_interval[0] - 1))
                    {
                        if (btimer_array[0] >= (b_interval[0] * (b_number[0] - 1)))
                        {
                            btimer_array[0] = b_break[0];
                        }
                        var _bul = scr_fire_bullet(scr_get_box(4) - 28, scr_get_box(5) + (-1 * (24 + ((scr_get_box(3) - scr_get_box(1)) / 2))), obj_pinkcatbullet, 270, b_speed[0] * _pattern_speed_modifier);
                        _bul.mode = 2;
                        _bul.image_speed = choose(0, 0, 0, 0.02, 0.04, 0, 0.334, 0.5, 1, 0, 0, 0);
                        _bul.image_xscale = 2;
                        _bul.image_yscale = 2;
                    }
                }
            }
        }
        until (btimer_array_decimal[0] < 1);
        btimer_array_decimal[1] += _pattern_speed_modifier;
        do
        {
            if (btimer_array_decimal[1] >= 1)
            {
                btimer_array_decimal[1] -= 1;
                btimer_array[1]++;
                if (btimer_array[1] > 0)
                {
                    if ((btimer_array[1] % b_interval[1]) == (b_interval[1] - 1))
                    {
                        if (btimer_array[1] > (b_interval[1] * (b_number[1] - 1)))
                        {
                            btimer_array[1] = b_break[1];
                        }
                        var _bul = scr_fire_bullet(scr_get_box(4), scr_get_box(5) + (1 * (24 + ((scr_get_box(3) - scr_get_box(1)) / 2))), obj_pinkcatbullet, 90, b_speed[1] * _pattern_speed_modifier);
                        _bul.mode = 2;
                        _bul.image_speed = choose(0, 0, 0, 0.02, 0.04, 0, 0.334, 0.5, 1, 0, 0, 0);
                        _bul.image_xscale = 2;
                        _bul.image_yscale = 2;
                    }
                }
            }
        }
        until (btimer_array_decimal[1] < 1);
        btimer_array_decimal[2] += _pattern_speed_modifier;
        do
        {
            if (btimer_array_decimal[2] >= 1)
            {
                btimer_array_decimal[2] -= 1;
                btimer_array[2]++;
                if (btimer_array[2] > 0)
                {
                    if ((btimer_array[2] % b_interval[2]) == (b_interval[2] - 1))
                    {
                        if (btimer_array[2] > (b_interval[2] * (b_number[2] - 1)))
                        {
                            btimer_array[2] = b_break[2];
                        }
                        var _bul = scr_fire_bullet(scr_get_box(4) + 28, scr_get_box(5) + (-1 * (24 + ((scr_get_box(3) - scr_get_box(1)) / 2))), obj_pinkcatbullet, 270, b_speed[2] * _pattern_speed_modifier);
                        _bul.mode = 2;
                        _bul.image_speed = choose(0, 0, 0, 0.02, 0.04, 0, 0.334, 0.5, 1, 0, 0, 0);
                        _bul.image_xscale = 2;
                        _bul.image_yscale = 2;
                    }
                }
            }
        }
        until (btimer_array_decimal[2] < 1);
        with (obj_pinkcatbullet)
        {
            if (life_time >= 30)
            {
                if (y < scr_get_box(1) || y > scr_get_box(3))
                {
                    image_alpha -= (0.05 * speed);
                    if (image_alpha <= 0)
                    {
                        instance_destroy();
                    }
                }
            }
        }
    }
}
if (type == 205)
{
    if (made == 0)
    {
        made = 1;
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        var _box_xscale = 1.125;
        var _box_yscale = 1.5;
        with (obj_growtangle)
        {
            if (!i_ex(obj_purplecontrols))
            {
                instance_create_depth(x, y, 4, obj_purplecontrols);
            }
            obj_purplecontrols.mode = 5;
            obj_purplecontrols.lane_x = 0;
            obj_purplecontrols.y_ongrid -= 80;
            image_xscale *= _box_xscale;
            image_yscale *= _box_yscale;
        }
        global.turntimer = 300;
        btimer2 = 0;
        bullet_lane = choose(0, 1);
        bullet_lane2 = 0;
        btimer_start = btimer;
        if (instance_exists(obj_growtangle))
        {
            var _bul = scr_fire_bullet(scr_get_box(4) - 63, scr_get_box(1) + 6, obj_pinkcatbullet, 0, 0);
            _bul.image_speed = choose(0, 0, 0, 0, 0, 0.02, 0.04, 0, 0.5, 1, 0, 0, 0);
            _bul.image_xscale = 2;
            _bul.image_yscale = 2;
            _bul.destroyonhit = 0;
            _bul = scr_fire_bullet(scr_get_box(4) + 63, scr_get_box(1) + 6, obj_pinkcatbullet, 0, 0);
            _bul.image_speed = choose(0, 0, 0, 0, 0, 0.02, 0.04, 0, 0.5, 1, 0, 0, 0);
            _bul.image_xscale = 2;
            _bul.image_yscale = 2;
            _bul.destroyonhit = 0;
            _bul = scr_fire_bullet(scr_get_box(4) - 63, scr_get_box(3) - 6, obj_pinkcatbullet, 0, 0);
            _bul.image_speed = choose(0, 0, 0, 0, 0, 0.02, 0.04, 0, 0.5, 1, 0, 0, 0);
            _bul.image_xscale = 2;
            _bul.image_yscale = 2;
            _bul.destroyonhit = 0;
            _bul = scr_fire_bullet(scr_get_box(4) + 63, scr_get_box(3) - 6, obj_pinkcatbullet, 0, 0);
            _bul.image_speed = choose(0, 0, 0, 0, 0, 0.02, 0.04, 0, 0.5, 1, 0, 0, 0);
            _bul.image_xscale = 2;
            _bul.image_yscale = 2;
            _bul.destroyonhit = 0;
        }
        if (i_ex(obj_pink_enemy))
        {
            difficulty = obj_pink_enemy.difficulty;
        }
        b_interval[0] = 4;
        b_number[0] = 2;
        b_break[0] = -20;
        b_speed[0] = 5.4;
        b_interval[1] = 5;
        b_number[1] = 2;
        b_break[1] = -24;
        b_speed[1] = 4.4;
        b_interval[2] = 18;
        b_number[2] = 1;
        b_break[2] = -12;
        b_speed[2] = 3.4;
        btimer_array[2] = b_interval[2] - 2;
        btimer_array[1] = b_interval[1] - 2;
        btimer_array[0] = b_interval[0] - 2;
        btimer_array_decimal[2] = 0;
        btimer_array_decimal[1] = 0;
        btimer_array_decimal[0] = 0;
    }
    var _pattern_speed_modifier = 1;
    if (instance_exists(obj_growtangle))
    {
        btimer_array_decimal[0] += _pattern_speed_modifier;
        do
        {
            if (btimer_array_decimal[0] >= 1)
            {
                btimer_array_decimal[0] -= 1;
                btimer_array[0]++;
                if (btimer_array[0] > 0)
                {
                    if ((btimer_array[0] % b_interval[0]) == (b_interval[0] - 1))
                    {
                        if (btimer_array[0] >= (b_interval[0] * (b_number[0] - 1)))
                        {
                            btimer_array[0] = b_break[0];
                        }
                        var _bul = scr_fire_bullet(scr_get_box(4) - 28, scr_get_box(5) + (-1 * (24 + ((scr_get_box(3) - scr_get_box(1)) / 2))), obj_pinkcatbullet, 270, b_speed[0] * _pattern_speed_modifier);
                        _bul.mode = 2;
                        _bul.image_speed = choose(0, 0, 0, 0.02, 0.04, 0, 0.334, 0.5, 1, 0, 0, 0);
                        _bul.image_xscale = 2;
                        _bul.image_yscale = 2;
                    }
                }
            }
        }
        until (btimer_array_decimal[0] < 1);
        btimer_array_decimal[1] += _pattern_speed_modifier;
        do
        {
            if (btimer_array_decimal[1] >= 1)
            {
                btimer_array_decimal[1] -= 1;
                btimer_array[1]++;
                if (btimer_array[1] > 0)
                {
                    if ((btimer_array[1] % b_interval[1]) == (b_interval[1] - 1))
                    {
                        if (btimer_array[1] > (b_interval[1] * (b_number[1] - 1)))
                        {
                            btimer_array[1] = b_break[1];
                        }
                        var _bul = scr_fire_bullet(scr_get_box(4), scr_get_box(5) + (1 * (24 + ((scr_get_box(3) - scr_get_box(1)) / 2))), obj_pinkcatbullet, 90, b_speed[1] * _pattern_speed_modifier);
                        _bul.mode = 2;
                        _bul.image_speed = choose(0, 0, 0, 0.02, 0.04, 0, 0.334, 0.5, 1, 0, 0, 0);
                        _bul.image_xscale = 2;
                        _bul.image_yscale = 2;
                    }
                }
            }
        }
        until (btimer_array_decimal[1] < 1);
        btimer_array_decimal[2] += _pattern_speed_modifier;
        do
        {
            if (btimer_array_decimal[2] >= 1)
            {
                btimer_array_decimal[2] -= 1;
                btimer_array[2]++;
                if (btimer_array[2] > 0)
                {
                    if ((btimer_array[2] % b_interval[2]) == (b_interval[2] - 1))
                    {
                        if (btimer_array[2] > (b_interval[2] * (b_number[2] - 1)))
                        {
                            btimer_array[2] = b_break[2];
                        }
                        var _bul = scr_fire_bullet(scr_get_box(4) + 28, scr_get_box(5) + (-1 * (24 + ((scr_get_box(3) - scr_get_box(1)) / 2))), obj_pinkcatbullet, 270, b_speed[2] * _pattern_speed_modifier);
                        _bul.mode = 2;
                        _bul.image_speed = choose(0, 0, 0, 0.02, 0.04, 0, 0.334, 0.5, 1, 0, 0, 0);
                        _bul.image_xscale = 2;
                        _bul.image_yscale = 2;
                    }
                }
            }
        }
        until (btimer_array_decimal[2] < 1);
    }
    with (obj_pinkcatbullet)
    {
        if (life_time >= 30)
        {
            if (y < scr_get_box(1) || y > scr_get_box(3))
            {
                image_alpha -= (0.05 * speed);
                if (image_alpha <= 0)
                {
                    instance_destroy();
                }
            }
        }
    }
}
if (type == 206)
{
    if (made == 0)
    {
        made = 1;
        phase = 0;
        btimer = 0;
        grid_x = 3;
        grid_y = 0;
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        with (obj_growtangle)
        {
            if (!i_ex(obj_purplecontrols))
            {
                instance_create_depth(x, y, 4, obj_purplecontrols);
            }
            obj_purplecontrols.mode = 2;
            obj_purplecontrols.lane_x = 0;
            obj_purplecontrols.lane_y = 3;
        }
        global.turntimer = 240;
    }
    var _box_x = camera_get_view_x(view_camera[0]) + 320;
    var _box_y = camera_get_view_y(view_camera[0]) + 240;
    if (instance_exists(obj_growtangle))
    {
        _box_x = scr_get_box(4);
        _box_y = scr_get_box(5);
    }
    if (btimer >= 6)
    {
        var _lane_distance = 40;
        snd_play(snd_whip_throw_only);
        var _bomb = instance_create((_box_x - (_lane_distance * 1.5)) + (grid_x * _lane_distance), (_box_y - (_lane_distance * 1.5)) + (grid_y * _lane_distance), obj_fusebomb);
        _bomb.fuse_time = 60;
        _bomb.grid_x = grid_x;
        _bomb.grid_y = grid_y;
        _bomb.mode = 2;
        _bomb.active = 1;
        if (choose(0, 1) == 0)
        {
            grid_x += (-2 + irandom(4));
            grid_y += choose(-2, -1, 1, 2);
        }
        else
        {
            grid_x += choose(-2, -1, 1, 2);
            grid_y += (-2 + irandom(4));
        }
        if (grid_x >= 4)
        {
            grid_x -= 4;
        }
        else if (grid_x < 0)
        {
            grid_x += 4;
        }
        if (grid_y >= 4)
        {
            grid_y -= 4;
        }
        else if (grid_y < 0)
        {
            grid_y += 4;
        }
        phase++;
        if (phase < 2)
        {
            btimer -= 35;
        }
        else if (phase < 4)
        {
            btimer -= 25;
        }
        else if (phase < 6)
        {
            btimer -= 18;
        }
        else if (phase < 8)
        {
            btimer -= 11;
        }
        else if (phase < 9)
        {
            btimer -= 8;
        }
        else if (phase < 12)
        {
            btimer -= 6;
        }
        else
        {
            btimer -= 99;
        }
    }
}
if (type == 207)
{
    if (made == 0)
    {
        made = 1;
        btimer = 0;
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        with (obj_growtangle)
        {
            if (!i_ex(obj_purplecontrols))
            {
                instance_create_depth(x, y, 4, obj_purplecontrols);
            }
            obj_purplecontrols.mode = 6;
        }
        global.turntimer = 290;
    }
}
if (type == 208)
{
    if (made == 0)
    {
        made = 1;
        btimer = 0;
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        with (obj_growtangle)
        {
            if (!i_ex(obj_purplecontrols))
            {
                instance_create_depth(x, y, 4, obj_purplecontrols);
                obj_purplecontrols.mode = 7;
                obj_purplecontrols.difficulty = other.difficulty;
            }
        }
        snd_play(snd_jump);
        global.turntimer = 630;
    }
}
if (type == 209)
{
    if (made == 0)
    {
        made = 1;
        with (obj_pink_battlemovement)
        {
            instance_destroy();
        }
        var _box_xscale = 2.4;
        var _box_yscale = 1.249;
        if (instance_exists(obj_growtangle))
        {
            if (obj_growtangle.image_xscale == obj_growtangle.maxxscale)
            {
                with (obj_growtangle)
                {
                    instance_create_depth(x, y, depth, obj_growtangle);
                    instance_destroy();
                }
            }
        }
        with (obj_grazebox)
        {
            grazetimefactor = 0;
        }
        with (obj_growtangle)
        {
            maxxscale = 2 * _box_xscale;
            maxyscale = 2 * _box_yscale;
            with (instance_create_depth(x + 200, y, depth - 11, obj_pink_battlemovement))
            {
                mode = 1;
                air_time = 1;
                sprite_index = spr_pink_ball;
                image_speed = 1;
                dest_x = other.x;
                dest_y = other.y - 136;
            }
            if (!instance_exists(obj_pink_curtains))
            {
                instance_create_depth(x, y - 88, depth - 10, obj_pink_curtains);
            }
        }
        with (obj_pink_curtains)
        {
            difficulty = other.difficulty;
        }
        global.turntimer = 425;
        if (difficulty > 0)
        {
            global.turntimer += 80;
        }
    }
    if (difficulty == 0)
    {
        if (global.turntimer == 408)
        {
            if (!instance_exists(obj_moveheart))
            {
                scr_moveheart();
            }
        }
    }
    if (difficulty > 0)
    {
        if (global.turntimer == 488)
        {
            if (!instance_exists(obj_moveheart))
            {
                scr_moveheart();
            }
        }
    }
    with (obj_heart)
    {
        wspeed = global.sp * 1.5;
    }
}
if (type == 210)
{
    if (made == 0)
    {
        made = 1;
        var _node_dist_test = 54;
        with (obj_heart)
        {
            sprite_index = spr_purpleheart;
            canmove = 0;
        }
        with (obj_growtangle)
        {
            instance_destroy();
        }
        if (!i_ex(obj_purplecontrols))
        {
            instance_create_depth(x, y, 4, obj_purplecontrols);
        }
        obj_purplecontrols.mode = 8;
        obj_purplecontrols.difficulty = other.difficulty;
        global.turntimer = 1000;
    }
}
if (type == 300)
{
    if (btimer == 109 && !made)
    {
        with (obj_aqua_enemy)
        {
            if (fight_type == "solo")
            {
                global.turntimer = 480;
            }
        }
        btimer = 0;
        for (var t70a = 0; t70a < 6; t70a++)
        {
            for (var t70b = 0; t70b < 6; t70b++)
            {
                var t70_bullet = instance_create((obj_growtangle.x - 250) + (100 * t70a), (obj_growtangle.y - 250) + (100 * t70b), obj_omega_knife);
                t70_bullet.sprite_index = spr_stolen_knife;
                t70_bullet.mask_index = spr_stolen_knife_mask;
                t70_bullet.image_xscale = 1.65;
                t70_bullet.image_yscale = 1.65;
                t70_bullet.spin = 1;
                t70_bullet.spinspeed = -3;
                t70_bullet.direction = 315;
                t70_bullet.speed = 4;
                if (t70a == 2 && t70b == 2)
                {
                    t70_bullet.looplocked = true;
                }
                with (t70_bullet)
                {
                    scr_bullet_inherit(820);
                }
            }
        }
        made = true;
    }
    if ((btimer % 60) == 0)
    {
        var t70rand = choose(-45, 45);
        with (obj_omega_knife)
        {
            scr_lerpvar("direction", direction, direction + t70rand, 40);
        }
    }
}
if (type == 301)
{
    if (!made)
    {
        made = true;
        var d = instance_create(camerax() + 434, cameray() + 181, obj_blue_guidelines);
        scr_bullet_inherit(d);
    }
}
if (type == 302)
{
    if (!made)
    {
        var d = instance_create(obj_blue_enemy.x, obj_blue_enemy.y, obj_enemy_blue_boxspin);
        d.mode = 1;
        scr_bullet_inherit(d);
        made = true;
    }
}
if (type == 303)
{
    if (!made)
    {
        var d = instance_create(obj_blue_enemy.x, obj_blue_enemy.y, obj_enemy_blue_flower_aim);
        scr_bullet_inherit(d);
        made = true;
    }
}
if (type == 304)
{
    if (!made)
    {
        made = true;
        var d = instance_create(obj_blue_enemy.x, obj_blue_enemy.y, obj_blue_singing2);
        with (d)
        {
            scr_lerpvar("x", x, camerax() + 436, 30, 1, "out");
            scr_lerpvar("yanchor", yanchor, cameray() + 90, 30, 1, "out");
        }
        scr_bullet_inherit(d);
    }
}
if (type == 305)
{
    if (!made)
    {
        made = true;
        instance_create(468, 96, obj_green_bigpan);
    }
}
if (type == 306)
{
    if (!made)
    {
        made = true;
        var _purple_omega = instance_create(obj_growtangle.x, obj_growtangle.y, obj_omega_book_manager);
        scr_bullet_inherit(_purple_omega);
        _purple_omega.damage = floor(_purple_omega.damage * 1.25) + 15;
        if (variable_instance_exists(id, "omega_ex_mode"))
        {
            _purple_omega.omega_ex_mode = true;
            _purple_omega.angle_speed_goal *= 4;
            _purple_omega.angle_speed_change *= 2;
            _purple_omega.scroll_speed_goal *= 2;
        }
    }
}
if (type == 307)
{
    if (!made)
    {
        made = true;
        var _green_omega = instance_create(obj_growtangle.x, obj_growtangle.y, obj_omega_pan_manager);
        scr_bullet_inherit(_green_omega);
    }
}
if (type == 308)
{
    if (!made)
    {
        made = true;
        var _aqua_chainknife = instance_create(obj_aqua_enemy.x + 3, obj_aqua_enemy.y - 29, obj_attack_knifechain_manager2);
        scr_bullet_inherit(_aqua_chainknife);
        if (obj_aqua_enemy.fight_type == "seth" && obj_aqua_enemy.turns != 5)
        {
            _aqua_chainknife.knife_setup(obj_aqua_enemy.x, obj_aqua_enemy.y - 10, 0, 145, 45, 60, 6, 0.35);
        }
        else
        {
            _aqua_chainknife.knife_setup(obj_aqua_enemy.x, obj_aqua_enemy.y - 10, 0, 145, 45, 50, 8, 0.35);
        }
        _aqua_chainknife = instance_create(obj_aqua_enemy.x + 3, obj_aqua_enemy.y - 29, obj_attack_knifechain_manager2);
        scr_bullet_inherit(_aqua_chainknife);
        if (obj_aqua_enemy.fight_type == "seth" && obj_aqua_enemy.turns != 5)
        {
            _aqua_chainknife.knife_setup(obj_aqua_enemy.x, obj_aqua_enemy.y - 10, 0, 215, 45, 60, 6, 0.35);
        }
        else
        {
            _aqua_chainknife.knife_setup(obj_aqua_enemy.x, obj_aqua_enemy.y - 10, 0, 215, 45, 50, 8, 0.35);
        }
    }
}
if (type == 309)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_netskie_enemy))
        {
            var _aqua_fanofknives = instance_create(obj_netskie_enemy.aquamarker.x, obj_netskie_enemy.aquamarker.y, obj_attack_knifefan_manager);
            scr_bullet_inherit(_aqua_fanofknives);
            _aqua_fanofknives = instance_create(obj_netskie_enemy.x, obj_netskie_enemy.y, obj_attack_knifefan_manager);
            _aqua_fanofknives.netskie = true;
            _aqua_fanofknives.timer = 10;
            _aqua_fanofknives.sprite_index = spr_enemy_aqua_idle_fox;
            scr_bullet_inherit(_aqua_fanofknives);
            with (obj_attack_knifefan_manager)
            {
                knife_number = 2;
            }
        }
        else if (i_ex(obj_aqua_enemy))
        {
            var _aqua_fanofknives = instance_create(obj_aqua_enemy.x, obj_aqua_enemy.y, obj_attack_knifefan_manager);
            scr_bullet_inherit(_aqua_fanofknives);
            if (obj_aqua_enemy.fight_type == "seth")
            {
                _aqua_fanofknives.knife_number = 3;
            }
        }
    }
}
if (type == 310)
{
    if (!made)
    {
        made = true;
        var _aqua_knife_leafling = instance_create(obj_aqua_enemy.x, obj_aqua_enemy.y, obj_attack_knife_leafling);
        scr_bullet_inherit(_aqua_knife_leafling);
        if (obj_aqua_enemy.fight_type == "seth")
        {
            _aqua_knife_leafling.knife_number = 6;
        }
    }
}
if (type == 311)
{
    if (!made)
    {
        made = true;
        var _aqua_knife_everything = instance_create(obj_aqua_enemy.x, obj_aqua_enemy.y, obj_attack_knife_everything);
        scr_bullet_inherit(_aqua_knife_everything);
    }
}
if (type == 312)
{
    if (btimer == 119)
    {
        var _duck = instance_create(scr_get_box(0) + 75, scr_get_box(5), obj_thrash_duck_bullet);
        _duck.damage = 1;
        _duck.target = target;
        _duck.speed = 2;
        _duck.direction = 180;
        _duck.sprite_index = spr_thrash_duckshot;
        _duck.grazepoints = 1;
        snd_play(snd_pombark);
    }
}
if (type == 313)
{
    if (!made)
    {
        made = true;
        var _sethsupport = instance_create(scr_get_box(0) + 75, scr_get_box(5), obj_purple_aim_attack);
        _sethsupport.damage = floor(damage * 1.25);
        _sethsupport.target = target;
    }
}
if (type == 314)
{
    if (!made)
    {
        if (difficulty == 0)
        {
            difficulty = 9;
        }
        global.turntimer = 360;
        gloveflip = choose(1, -1);
        made = true;
        mytimer = 0;
        if (i_ex(obj_orange_enemy))
        {
            orange = 402;
            xstart = x;
            ystart = y;
        }
        bspr = orange.sprite_index;
        running = true;
    }
    mytimer++;
    if ((mytimer % 56) == 1 && running)
    {
        if (global.turntimer < 64)
        {
            running = false;
        }
        else
        {
            running = true;
        }
        if (running)
        {
            nextx = obj_growtangle.x + (gloveflip * (56 + random(24)));
            nexty = (obj_growtangle.y - 144) + random(20);
        }
        else
        {
            nextx = xstart;
            nexty = ystart;
            if (i_ex(obj_orange_enemy))
            {
                obj_orange_enemy.sprite_index = bspr;
                obj_orange_enemy.image_index = 0;
            }
        }
        sound_play_x(snd_jump, 0.5, 1.2);
        with (obj_orange_enemy)
        {
            var _x = x;
            var _y = y;
            var _dir = point_direction(x, y, other.nextx, other.nexty);
            if (other.mytimer > 5)
            {
                image_xscale *= -1;
            }
            if (!other.running)
            {
                image_xscale = abs(image_xscale);
            }
            var _step = 0;
            while (_step <= 1)
            {
                x = lerp(_x, other.nextx - (sprite_width * 1.25 * other.running), _step);
                y = lerp(_y, other.nexty - ((sprite_height / 2) * other.running), _step);
                with (scr_afterimage())
                {
                    fadeSpeed = 0.08 - (_step / 24);
                    speed = _step;
                    direction = _dir;
                    friction = 0.001 + (speed / 100);
                }
                _step += 0.1;
            }
        }
    }
    if ((mytimer % 56) == 15 && running)
    {
        with (obj_orange_enemy)
        {
            image_index = 0;
            sprite_index = spr_orange_screenpunch;
            scr_lerpvar("image_index", 0, image_number - 1, 8);
        }
    }
    if ((mytimer % 56) == 22 && running)
    {
        with (obj_orange_enemy)
        {
            sound_play(snd_punchheavythunder);
            with (instance_create_depth(x, y, depth - 5, obj_bulletparent))
            {
                sprite_index = spr_orange_screenpunchfist;
                image_xscale = other.image_xscale;
                image_yscale = other.image_yscale;
                for (var fi = 2; fi < 11; fi++)
                {
                    scr_var_delay("x", xstart + (2 * (irandom(4) - 2)), fi);
                    scr_var_delay("y", ystart + (2 * (irandom(4) - 2)), fi);
                }
                scr_var_delay("x", xstart, 11);
                scr_var_delay("y", ystart, 11);
                scr_lerpvar("image_alpha", 3, 0, 30);
            }
        }
    }
    if ((mytimer % 56) == 29 && running)
    {
        with (obj_orange_enemy)
        {
            scr_lerpvar("image_index", image_index, 0, 13);
        }
    }
    if ((mytimer % 56) == 25 && running)
    {
        with (instance_create_depth(nextx, nexty + 10, 3, obj_glove_manager))
        {
            bullets = other.difficulty;
            event_user(0);
            vspeed = 0;
            other.gloveflip *= -1;
            turn *= other.gloveflip;
            scr_shakescreen(8);
        }
    }
    if ((mytimer % 56) == 30 && i_ex(obj_heart) && running)
    {
        mytimer += (3 * (obj_heart.wspeed - 4));
    }
    if (global.turntimer < 1)
    {
        with (obj_orange_enemy)
        {
            image_xscale = abs(image_xscale);
        }
    }
}
if (type == 615)
{
    var _rate = 20;
    var spread = 15 + (btimer / 30);
    var tracktime = 30 + (btimer / 120);
    if (!variable_instance_exists(id, "startdir"))
    {
        stardir = random(30);
    }
    var loc = [obj_growtangle.x + lengthdir_x(180, stardir * spread), obj_growtangle.y + lengthdir_y(180, stardir * spread)];
    if ((btimer % _rate) == 0)
    {
        with (instance_create(loc[0], loc[1], obj_bullet_func))
        {
            scr_doom(id, 240);
            scr_bullet_init();
            speed = 1;
            friction = -0.2;
            siner = 0;
            track = tracktime;
            
            step_func = function()
            {
                siner++;
                image_angle = direction + 90;
                if (i_ex(obj_heart))
                {
                    if (siner < track)
                    {
                        image_blend = merge_color(c_white, c_red, (track - siner) / track);
                        direction = point_direction(x, y, obj_heart.x + 10, obj_heart.y + 10);
                    }
                }
                if (place_meeting(x, y, obj_heart))
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
            };
            
            end_step_func = function()
            {
                if ((siner % 4) == 0)
                {
                    with (scr_afterimagefast())
                    {
                        speed = other.speed * 0.1;
                        direction = other.direction + 180;
                    }
                }
            };
            
            draw_func = function()
            {
                draw_self();
            };
        }
    }
}
if (type == 620)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        if (i_ex(obj_growtangle))
        {
            instance_create(0, 0, obj_debug_orangeheartcontroller);
        }
        obj_heart.visible = false;
        with (obj_debug_orangeheartcontroller)
        {
            attack_speed = 20;
        }
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 621)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        if (i_ex(obj_growtangle))
        {
            instance_create(0, 0, obj_debug_orangeheartcontroller);
        }
        with (obj_debug_orangeheartcontroller)
        {
            difficulty = 1;
            attack_speed = 26;
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 622)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        if (i_ex(obj_growtangle))
        {
            instance_create(0, 0, obj_debug_orangeheartcontroller);
        }
        with (obj_debug_orangeheartcontroller)
        {
            difficulty = 2;
            attack_speed = 36;
            do_bullets = true;
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 623)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            timer = 20;
            attacktype = 0;
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 624)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 0;
            difficulty = 1;
            open_chase_difficulty = obj_flowery_enemy.open_chase_counter;
            timer = -12;
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 625)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 0;
            difficulty = 2;
            timer = -5;
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 626)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 0;
            difficulty = 3;
            timer = -5;
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 627)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 2;
        }
        with (obj_orangeheart_floweryjarona)
        {
            mode = 1;
            difficulty = 0;
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 628)
{
    if (!made)
    {
        made = true;
        instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 2;
        }
        with (obj_orangeheart_floweryjarona)
        {
            mode = 1;
            difficulty = 1;
            orange_dopple = true;
            orange_dopple = instance_create(x, y + 100, obj_marker_fancy);
            with (orange_dopple)
            {
                depth = other.depth;
                sprite_index = spr_orange_animepunch_finished_cent;
                image_speed = 1/3;
                scr_darksize();
            }
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 629)
{
    if (!made)
    {
        made = true;
        instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 2;
        }
        scr_turntimer(3200);
        with (obj_orangeheart_floweryjarona)
        {
            mode = 3;
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 630)
{
    if (!made)
    {
        made = true;
        with (instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart))
        {
            brakespeed = 1;
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 3;
            fakecamxspeedbase_original = -8;
            timer = 20;
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
        with (instance_create(((camerax() + (camerawidth() * 0.5)) - 15) + 96, scr_get_box(5), obj_orangeheart_square))
        {
            orangeheartControlled = true;
            stopper = false;
            box_width *= 2.5;
            recalculate_box();
        }
        with (instance_create(camerax() + 1200, scr_get_box(5), obj_orangeheart_square))
        {
            orangeheartControlled = true;
            obj_debug_orangeheartcontroller.new_box = id;
        }
        with (instance_create((obj_debug_orangeheartcontroller.new_box.x + 150) - 30, 0, obj_orangeheart_word_manager))
        {
            timer_goal = 24;
            timer = irandom(timer_goal - 1);
            orangeheartControlled = true;
            self.dir = choose(1, -1);
            y = (cameray() + (cameraheight() * 0.5)) - (((cameraheight() * 0.5) + 30) * self.dir);
            init();
        }
        with (instance_create(obj_debug_orangeheartcontroller.new_box.x + 150 + 30, scr_get_box(5) + irandom_range(-50, 50), obj_orangeheart_helpful_flower))
        {
            depth = other.depth - 100;
        }
    }
}
if (type == 631)
{
    if (!made)
    {
        made = true;
        with (instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart))
        {
            brakespeed = 1;
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 3;
            fakecamxspeedbase_original = -8;
            timer = 20;
            difficulty = 1;
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
        with (instance_create(((camerax() + (camerawidth() * 0.5)) - 15) + 80, scr_get_box(5), obj_orangeheart_square))
        {
            orangeheartControlled = true;
            stopper = false;
            box_width *= 2;
            recalculate_box();
        }
        with (instance_create(camerax() + 1050, scr_get_box(5), obj_orangeheart_square))
        {
            orangeheartControlled = true;
            obj_debug_orangeheartcontroller.new_box = id;
        }
        var do_dir = choose(-1, 1);
        var _words1;
        with (instance_create(obj_debug_orangeheartcontroller.new_box.x + 115, 0, obj_orangeheart_word_manager))
        {
            b_speed = 7;
            orangeheartControlled = true;
            self.dir = do_dir;
            y = (cameray() + (cameraheight() * 0.5)) - (((cameraheight() * 0.5) + 30) * self.dir);
            _words1 = id;
        }
        var _words2;
        with (instance_create(obj_debug_orangeheartcontroller.new_box.x + 185, 0, obj_orangeheart_word_manager))
        {
            b_speed = 7;
            orangeheartControlled = true;
            self.dir = do_dir;
            y = (cameray() + (cameraheight() * 0.5)) - (((cameraheight() * 0.5) + 30) * self.dir);
            _words2 = id;
        }
        with (instance_create(obj_debug_orangeheartcontroller.new_box.x + 150, scr_get_box(5) + irandom_range(-50, 50), obj_orangeheart_helpful_flower))
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
if (type == 632)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 0;
            difficulty = 4;
            open_chase_difficulty = obj_flowery_enemy.open_chase_counter;
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 633)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            timer = 0;
            attacktype = 0;
            difficulty = 5;
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 634)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        if (i_ex(obj_growtangle))
        {
            instance_create(0, 0, obj_debug_orangeheartcontroller);
        }
        with (obj_debug_orangeheartcontroller)
        {
            difficulty = 1;
            attack_speed = 26;
            do_bullets = true;
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 635)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 0;
            difficulty = 6;
            wall_counter = -3;
            timer = -12;
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 636)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        if (i_ex(obj_growtangle))
        {
            instance_create(0, 0, obj_debug_orangeheartcontroller);
        }
        obj_heart.visible = false;
        with (obj_debug_orangeheartcontroller)
        {
            attack_speed = 26;
            orange_dopple = true;
        }
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 637)
{
    if (!made)
    {
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
        obj_heart.visible = false;
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            attacktype = 0;
            difficulty = 7;
            wall_counter = -3;
            do_lines = false;
            scrolling = false;
            with (obj_orangeheart)
            {
                sprite_index = spr_orangeheart_centered;
                image_angle = -90;
                image_blend = c_red;
                cancharge = false;
                canmovevertically = false;
                drawafterimages = false;
            }
            snd_play(snd_impact);
            with (instance_create(obj_orangeheart.x + 10, obj_orangeheart.y + 10, obj_marker))
            {
                sprite_index = spr_battlebg_tiny;
                image_speed = 0;
                image_blend = merge_color(c_green, c_lime, 0.5);
                image_alpha = 0;
                scr_lerpvar("image_angle", -45, 0, 5, 1, "out");
                scr_lerpvar("image_alpha", 0, 1, 5, 1, "out");
            }
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
    }
}
if (type == 638)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        if (i_ex(obj_growtangle))
        {
            instance_create(0, 0, obj_debug_orangeheartcontroller);
        }
        obj_heart.visible = false;
        with (obj_debug_orangeheartcontroller)
        {
            attack_speed = 26;
            orange_dopple = true;
        }
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 639)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        if (i_ex(obj_growtangle))
        {
            instance_create(0, 0, obj_debug_orangeheartcontroller);
        }
        obj_heart.visible = false;
        with (obj_debug_orangeheartcontroller)
        {
            attacktype = 0;
            difficulty = 8;
        }
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
        with (obj_orangeheart_floweryjarona)
        {
            attack_speed = 24;
            attack_speed_limit = 36;
            attack_speed_change = 4;
            mode = 4;
            intro_timer = -9999;
        }
    }
}
if (type == 640)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        if (i_ex(obj_growtangle))
        {
            instance_create(0, 0, obj_debug_orangeheartcontroller);
        }
        obj_heart.visible = false;
        with (obj_debug_orangeheartcontroller)
        {
            attacktype = 0;
            difficulty = 9;
        }
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 641)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart);
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            do_chase = false;
            timer = 5;
            attacktype = 0;
            difficulty = 10;
            timer_goal = 28;
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}
if (type == 642)
{
    if (!made)
    {
        made = true;
        with (obj_trashy_trio)
        {
            with (trashy_marker)
            {
                visible = false;
                with (instance_create_depth(x, y, depth - 1, obj_bulletparent_fancy))
                {
                    timer = 0;
                    anchor_x = x;
                    anchor_y = y;
                    sprite_index = spr_npc_trashy;
                    image_index = other.image_index;
                    image_speed = other.image_speed;
                    scr_darksize();
                    
                    clean_func = function()
                    {
                        with (obj_trashy_trio)
                        {
                            with (trashy_marker)
                            {
                                if (counter == 2)
                                {
                                    idlesprite = spr_npc_trashy_battle_trip;
                                    x += 20;
                                }
                                visible = true;
                            }
                        }
                    };
                    
                    step_func = function()
                    {
                        timer++;
                        if (timer == 1)
                        {
                            sprite_index = spr_npc_trashy_battle_rev;
                            image_speed = 1;
                            snd_play(snd_car_screech);
                            snd_play(snd_lawnmower);
                            scr_lerpvar("x", x, x + 150, 25, 2, "out");
                        }
                        if (timer == 27)
                        {
                            snd_play(snd_cardrive);
                            scr_lerpvar("x", x, x - 110, 5);
                        }
                        if (timer == 33)
                        {
                            scr_lerpvar("x", x, x - 20, 15, 1, "out");
                            sprite_index = spr_npc_trashy_battle_trip;
                            audio_stop_sound(snd_cardrive);
                            audio_stop_sound(snd_lawnmower);
                            snd_play(snd_horriblemetalclang);
                            snd_play(snd_heavyswing, 1, 0.5);
                            scr_shakescreen(10);
                            var _angle = -10;
                            for (var a = 3; a < 5; a++)
                            {
                                for (var b = 0; b < 5; b++)
                                {
                                    if (a == 3 && b == 4)
                                    {
                                        continue;
                                    }
                                    if (a == 1 && (b == 1 || b == 3))
                                    {
                                        continue;
                                    }
                                    with (scr_fire_bullet(x, y + 80, obj_bullet_trash, 0, 0, spr_bullet_trashbag))
                                    {
                                        image_angle = irandom(360);
                                        scr_bullet_inherit_from(id, 960);
                                        hspeed = -1 - lengthdir_x(a * 1.5, ((180 + (30 * b) + (30 * a)) - ((a == 2) * 15)) + _angle);
                                        vspeed = -12 - lengthdir_y(a * 1.5, ((180 + (30 * b) + (30 * a)) - ((a == 2) * 15)) + _angle);
                                        gravity_direction = 270;
                                        gravity = (0.75 - (a * 0.05)) + random_range(-0.1, 0.1);
                                        hspeed += random_range(-0.25, 0.25);
                                        vspeed += random_range(-0.25, 0.25);
                                        vspeed *= 0.9;
                                        speed *= 1.075;
                                    }
                                }
                            }
                        }
                        if (timer >= 39 && (timer % 5) == 0 && global.turntimer > 45)
                        {
                            snd_play(snd_bounceflower_subtle, 1, 1.5);
                            with (scr_fire_bullet(x + 16, y + 80, obj_bullet_trash_extra, 0, 0, spr_bullet_trashbag))
                            {
                                scr_darksize();
                                var _a = (sin(global.time) * 2) + 3;
                                var _b = (cos(global.time) * 3) + 2;
                                image_angle = irandom(360);
                                scr_bullet_inherit_from(id, 960);
                                hspeed = -1 - _a;
                                vspeed = -12 - lengthdir_y(_a * 1.5, 180 + (30 * _a));
                                gravity_direction = 270;
                                gravity = 0.75 + random_range(-0.1, 0.1);
                                hspeed += random_range(-0.25, 0.25);
                                vspeed += random_range(-0.25, 0.25);
                                vspeed *= 0.9;
                                speed *= 1.075;
                            }
                        }
                        if (global.turntimer <= 15)
                        {
                        }
                    };
                    
                    draw_func = function()
                    {
                        draw_self();
                    };
                }
            }
        }
    }
}
if (type == 643)
{
    if (!made)
    {
        made = true;
        with (obj_trashy_trio)
        {
            with (ball_marker)
            {
                scr_lerpvar("x", xstart, xstart + 40, 10, 1, "out");
                state = "throw";
                factor = 0.1;
                attack_timer = 0;
                scr_lerpvar("timer_speed", 2, 4, 20);
                scr_lerpvar("factor", 0.1, 1, 20);
            }
        }
        with (instance_create(x, y, obj_bulletparent_fancy))
        {
            visible = false;
            
            step_func = function()
            {
                if (global.turntimer <= 21)
                {
                    with (obj_trashy_trio)
                    {
                        with (ball_marker)
                        {
                            scr_lerpvar("x", xstart + 40, xstart, 10, 1, "out");
                            scr_lerpvar("timer_speed", 4, 2, 20);
                            state = "idle";
                            factor = 0.1;
                            scr_lerpvar("factor", 0.1, 1, 20);
                        }
                    }
                    instance_destroy();
                }
            };
        }
    }
}
if (type == 644)
{
    if (!made)
    {
        made = true;
        with (instance_create(scr_get_box(4) + irandom_range(-50, 50), scr_get_box(5) + 110, obj_bulletparent_fancy))
        {
            scr_darksize();
            timer = -20;
            counter = 0;
            sprite_index = spr_nubert_sideways;
            image_speed = 0;
            image_index = 6;
            visible = false;
            if (irandom(1))
            {
                image_angle = clamp(point_direction(x, y, obj_heart.x + 10, obj_heart.y + 10), 45, 135);
            }
            else
            {
                image_angle = clamp(point_direction(x, y, obj_heart.x + 10, obj_heart.y + 10) + irandom_range(-20, 20), 45, 135);
            }
            
            clean_func = function()
            {
                with (obj_trashy_trio)
                {
                    with (nubert_marker)
                    {
                        image_goal = 0;
                    }
                }
            };
            
            step_func = function()
            {
                if (!i_ex(obj_bullet_super_nubert2))
                {
                    if (!visible && (timer == -4 || timer == -10))
                    {
                        if (counter < 4)
                        {
                            counter++;
                            image_index = 6;
                            visible = true;
                            x = scr_get_box(4) + irandom_range(-50, 50);
                            if (irandom(1))
                            {
                                image_angle = clamp(point_direction(x, y, obj_heart.x + 10, obj_heart.y + 10), 45, 135);
                            }
                            else
                            {
                                image_angle = clamp(point_direction(x, y, obj_heart.x + 10, obj_heart.y + 10) + irandom_range(-20, 20), 45, 135);
                            }
                        }
                        else
                        {
                            global.turntimer = 8;
                        }
                    }
                    timer++;
                    image_index = scr_approach(image_index, 3, 0.5);
                }
                if (((timer == 9 && counter) || timer == 20) && visible)
                {
                    visible = false;
                    timer = -5;
                    with (instance_create_depth(x, y, obj_growtangle.depth - 2, obj_bullet_super_nubert2))
                    {
                        nubert_first = true;
                        snd_play(snd_jump);
                        nubert_angle_goal = other.image_angle;
                        nubert_angle = 90;
                        nubert_first_angle = nubert_angle;
                        scr_lerpvar("nubert_speed", 44, 0.5, 16 + floor(abs(90 - nubert_angle_goal) * 0.2), 2, "out");
                    }
                }
            };
            
            draw_func = function()
            {
                var _off = 0;
                if (timer >= 0)
                {
                    if ((timer % 2) == 0)
                    {
                        _off = 2;
                    }
                    else
                    {
                        _off = -2;
                    }
                }
                draw_sprite_ext(sprite_index, image_index, x + lengthdir_x(_off, image_angle + 90), y + lengthdir_y(_off, image_angle + 90), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
            };
        }
    }
}
if (type == 645)
{
    if (!made)
    {
        made = true;
        with (obj_trashy_trio)
        {
            with (trashy_marker)
            {
                with (instance_create_depth(x, y, depth - 1, obj_bulletparent_fancy))
                {
                    sprite_index = spr_trashy_beam_glow;
                    image_index = 0;
                    image_speed = 0;
                    image_xscale = 2;
                    image_yscale = 2;
                    timer = -3;
                    laser_sound = snd_play(snd_rurus_appear);
                    snd_pitch(laser_sound, 0.25);
                    
                    clean_func = function()
                    {
                        with (obj_trashy_trio)
                        {
                            with (trashy_marker)
                            {
                                x -= 20;
                                idlesprite = spr_npc_trashy;
                            }
                        }
                    };
                    
                    step_func = function()
                    {
                        snd_pitch(laser_sound, audio_sound_get_pitch(laser_sound) + 0.025);
                        if (timer >= 0 && irandom(1) && timer < 10)
                        {
                            var _rand = 135 + random(90);
                            var _len = 40 + random(40);
                            with (instance_create(x + 24 + lengthdir_x(_len, _rand), y + 76 + lengthdir_y(_len, _rand), obj_marker))
                            {
                                var _lifetime = 10 + irandom(8);
                                sprite_index = spr_trashy_bullet_glow;
                                image_speed = 0.5;
                                direction = _rand + 180;
                                speed = _len / _lifetime;
                                scr_lerpvar("image_alpha", 1, 0, _lifetime);
                                image_xscale = 1.5;
                                image_yscale = 1.5;
                                scr_lerpvar("image_xscale", 1.5, 0.5, _lifetime);
                                scr_lerpvar("image_yscale", 1.5, 0.5, _lifetime);
                            }
                        }
                        if (timer == 5)
                        {
                            instance_create_depth(x + 29, y + 76 + 8, obj_growtangle.depth - 0.01, obj_trashy_beam);
                        }
                        if (timer == 15)
                        {
                            with (obj_trashy_beam)
                            {
                                trashy_beam_go();
                            }
                        }
                    };
                    
                    draw_func = function()
                    {
                        timer += 0.25;
                        if (timer > 0)
                        {
                            image_index = clamp(timer * 0.2, 0, 3) + ((timer * 2) % 2);
                        }
                        draw_self();
                    };
                }
            }
        }
    }
}
if (type == 646)
{
    if (!made)
    {
        made = true;
        with (instance_create(x - 24, y + 63, obj_bulletparent_fancy))
        {
            scr_script_delayed(snd_play, 15, 397, 1, 1.5);
            scr_darksize();
            timer = -20;
            counter = 0;
            sprite_index = spr_nubert_sideways;
            image_speed = 0;
            image_index = 6;
            visible = false;
            image_angle = 180;
            
            clean_func = function()
            {
                with (obj_trashy_trio)
                {
                    with (nubert_marker)
                    {
                        image_goal = 0;
                    }
                }
                with (obj_trashy_trio)
                {
                    with (trashy_marker)
                    {
                        x -= 20;
                        idlesprite = spr_npc_trashy;
                    }
                }
            };
            
            step_func = function()
            {
                if (!i_ex(obj_bullet_super_nubert2))
                {
                    if (!visible && (timer == -4 || timer == -10))
                    {
                        if (counter < 1)
                        {
                            counter++;
                            image_index = 6;
                            visible = true;
                            image_angle = 180;
                        }
                        else
                        {
                            global.turntimer = 8;
                        }
                    }
                    timer++;
                    image_index = scr_approach(image_index, 3, 0.5);
                }
                if (((timer == 9 && counter) || timer == 20) && visible)
                {
                    visible = false;
                    timer = -5;
                    with (instance_create_depth(x, y, obj_growtangle.depth - 2, obj_bullet_super_nubert2))
                    {
                        nubert_cannon = true;
                        nubert_first = true;
                        snd_play(snd_jump);
                        nubert_angle_goal = 180;
                        nubert_angle = 180;
                        nubert_first_angle = nubert_angle;
                        nubert_speed = 20;
                        nubert_turn = 10;
                        scr_script_delayed(scr_lerpvar, 52, "nubert_speed", 20, 0.5, 16, 2, "out");
                    }
                }
            };
            
            draw_func = function()
            {
                var _off = 0;
                if (timer >= 0)
                {
                    if ((timer % 2) == 0)
                    {
                        _off = 2;
                    }
                    else
                    {
                        _off = -2;
                    }
                }
                draw_sprite_ext(sprite_index, image_index, x + lengthdir_x(_off, image_angle + 90), y + lengthdir_y(_off, image_angle + 90), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
            };
        }
    }
}
if (type == 647)
{
    if (!made)
    {
        made = true;
        if (i_ex(obj_growtangle))
        {
            with (instance_create(scr_get_box(4) - 75, scr_get_box(5), obj_orangeheart))
            {
                rotatecontrol = true;
            }
        }
        with (instance_create(0, 0, obj_debug_orangeheartcontroller))
        {
            do_chase = false;
            timer = 5;
            attacktype = 0;
            difficulty = 12;
            timer_goal = 30;
        }
        with (obj_orangeheart_floweryjarona)
        {
            instance_destroy();
        }
        obj_heart.visible = false;
        with (obj_growtangle)
        {
            image_xscale = camerawidth() / 75;
        }
    }
}

enum e__VW
{
    XView,
    YView,
    WView,
    HView,
    Angle,
    HBorder,
    VBorder,
    HSpeed,
    VSpeed,
    Object,
    Visible,
    XPort,
    YPort,
    WPort,
    HPort,
    Camera,
    SurfaceID
}
