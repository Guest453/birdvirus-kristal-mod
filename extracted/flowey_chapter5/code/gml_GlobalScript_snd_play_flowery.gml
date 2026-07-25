function snd_play_flowery(arg0, arg1 = 1, arg2 = 1)
{
    if (global.flag[1391] == 1)
    {
        exit;
    }
    var sound_asset = scr_84_get_sound(audio_get_name(arg0));
    if (is_undefined(sound_asset))
    {
        sound_asset = arg0;
    }
    snd_play(sound_asset, arg1, arg2);
}
