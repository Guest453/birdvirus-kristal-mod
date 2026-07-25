if (chargecon == 0 && !shakeheart)
{
    if (button1_h())
    {
        chargecon = 1;
        loop_sound = snd_loop(snd_chargeshot_charge);
        snd_pitch(loop_sound, 0.25);
        snd_volume(loop_sound, 0.5, 0);
        chargetimer = 0;
        glowtimer = 0;
    }
}
if (chargecon == 1)
{
    if (button1_h())
    {
        dashstate = 1;
        chargetimer = scr_approach(chargetimer, 16, 1);
        snd_pitch(loop_sound, min(0.5 + (chargetimer * 0.05), 1));
    }
    else if (chargetimer == 16)
    {
        snd_stop(loop_sound);
        snd_play(snd_explosion_mmx3, 0.5, 2);
        chargecon = 2;
        dashtimer = 0;
    }
    else
    {
        chargetimer = 8 + (chargetimer * 0.5);
        snd_stop(loop_sound);
        snd_play(snd_explosion_mmx3, 0.5, 2);
        chargecon = 2;
        dashtimer = 0;
    }
}
if (chargecon == 2)
{
    x = basex + chargedistance;
    chargecon = 3;
}
if (chargecon == 3)
{
    chargetimer = 0;
    dashtimer++;
    x = lerp_ease_out(x, basex, dashtimer / 15, 2);
    if (dashtimer >= 15)
    {
        x = basex;
        chargecon = 0;
        dashtimer = 0;
    }
}
