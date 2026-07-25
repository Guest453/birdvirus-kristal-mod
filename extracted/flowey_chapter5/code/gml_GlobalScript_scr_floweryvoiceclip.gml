function scr_floweryvoiceclip(arg0)
{
    if (!variable_global_exists("flowery_txtsnd"))
    {
        scr_floweryvoiceclip_init();
    }
    var flowerysnd = 534;
    var text_char = arg0;
    for (var i = 0; i < array_length(global.flowery_txtsnd); i++)
    {
        if (text_char != global.flowery_txtsnd[i][0])
        {
            continue;
        }
        if (text_char == "h")
        {
            var chance = random(1);
            flowerysnd = (chance >= 0.5) ? 208 : 665;
            if (global.lang == "ja")
            {
                flowerysnd = 193;
            }
            break;
        }
        else
        {
            flowerysnd = scr_84_get_sound(audio_get_name(global.flowery_txtsnd[i][1]));
            if (global.lang == "ja")
            {
                if (room == room_dw_fcastle_cafe)
                {
                    if (flowerysnd == 238)
                    {
                        flowerysnd = 373;
                    }
                }
                else if (room == room_dw_garden_enemyrush)
                {
                    if (i_ex(obj_dw_garden_enemyrush) && obj_dw_garden_enemyrush.cutscene == 8 && i_ex(obj_cutscene_master))
                    {
                        if (flowerysnd == 642)
                        {
                            flowerysnd = 190;
                        }
                    }
                }
                else if (room == room_dw_fcastle_top_intro)
                {
                    if (i_ex(obj_ch5_DW22) && i_ex(obj_cutscene_master))
                    {
                        if (flowerysnd == 611)
                        {
                            flowerysnd = 242;
                        }
                        else if (flowerysnd == 698)
                        {
                            flowerysnd = 670;
                        }
                    }
                }
            }
            break;
        }
    }
    return flowerysnd;
}

function scr_floweryvoiceclip_init()
{
    if (!variable_global_exists("flowery_txtsnd"))
    {
        global.flowery_txtsnd = [];
    }
    var _assets = [131, 111, 106, 110, 5, 244, 228, 187, 117, 757, 226, 717, 633, 205, 154, 44, 72, 750, 210, 54, 15, 250, 673, 77, 95, 49, 616, 183, 144, 197, 74, 678, 436, 702, 574, 53, 89, 204, 216, 704, 125, 151, 212, 208, 140, 627, 3, 622, 741, 739, 147, 142, 79, 743, 14, 696, 185, 653, 159, 628, 29];
    var alphabet_upper = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    var alphabet_lower = [];
    for (var i = 0; i < array_length(alphabet_upper); i++)
    {
        alphabet_lower[array_length(alphabet_lower)] = string_lower(alphabet_upper[i]);
    }
    var alphabet = alphabet_upper;
    for (var i = 0; i < array_length(alphabet_lower); i++)
    {
        alphabet[array_length(alphabet)] = alphabet_lower[i];
    }
    var alphabet_index = 0;
    for (var i = 0; i < array_length(_assets); i++)
    {
        var text_char = string(i);
        if (i > 9)
        {
            text_char = alphabet[alphabet_index];
            alphabet_index += 1;
        }
        var sound_asset = _assets[i];
        global.flowery_txtsnd[i][0] = text_char;
        global.flowery_txtsnd[i][1] = sound_asset;
    }
}

function scr_set_floweryvoicemode(arg0)
{
    if (global.typer != 88 && global.typer != 96 && global.typer != 86)
    {
        exit;
    }
    if (string_pos("\\V", arg0) != 0)
    {
        global.voiceclipmode = 0;
        if (global.flag[1391] == 1)
        {
            global.voiceclipmode = 2;
        }
        if (string_pos("\\v1", arg0) != 0)
        {
            global.voiceclipmode = 1;
        }
    }
    else if (string_pos("\\v1", arg0) != 0)
    {
        global.voiceclipmode = 1;
    }
    else
    {
        global.voiceclipmode = 2;
    }
}
