phaseturn++;
if (phase == 1 || phase == 2)
{
    if (phaseturn == 1)
    {
        myattackchoice = 3;
        scr_debug_print("chase tutorial");
    }
    if (phaseturn == 2)
    {
        myattackchoice = 0;
        scr_debug_print("jarona 1");
    }
    if (phaseturn == 3)
    {
        myattackchoice = 4;
        scr_debug_print("chase random");
    }
    if (phaseturn == 4)
    {
        myattackchoice = 2;
        scr_debug_print("jarona with bullets");
    }
    if (phaseturn == 5)
    {
        myattackchoice = 4;
        scr_debug_print("chase random");
        difficulty = chase_attack_difficulty;
    }
    if (phaseturn == 6)
    {
        myattackchoice = 2;
        phaseturn = 4;
        scr_debug_print("jarona with bullets");
    }
}
if (phase == 3)
{
    if (phaseturn == 1)
    {
        myattackchoice = 10;
        scr_debug_print("box attack 1");
    }
    if (phaseturn == 2)
    {
        myattackchoice = 21;
        scr_debug_print("lilypad");
    }
    if (phaseturn == 3)
    {
        if (did_sethaqua_attack_without_getting_hurt == true)
        {
            myattackchoice = 11;
            scr_debug_print("box attack 2");
        }
        else
        {
            myattackchoice = 10;
            scr_debug_print("box attack 1");
        }
    }
    if (phaseturn >= 4)
    {
        myattackchoice = 21;
        scr_debug_print("lilypad");
        phaseturn = 2;
    }
}
if (phase == 4)
{
    if (phaseturn == 1)
    {
        myattackchoice = 16;
        scr_debug_print("Flowery Bullets fist. NO kist kidding");
    }
    if (phaseturn == 2)
    {
        myattackchoice = 18;
        scr_debug_print("Flowery Bullets fist. Medium kist kidding");
    }
    if (phaseturn == 3)
    {
        myattackchoice = 12;
        scr_debug_print("chase random");
        difficulty = chase_attack_difficulty;
    }
    if (phaseturn == 4)
    {
        myattackchoice = 18;
        scr_debug_print("Flowery Bullets fist. Medium kist kidding");
    }
}
if (phase == 5)
{
    if (phaseturn == 1)
    {
        myattackchoice = 15;
        scr_debug_print("FloweryChaseBlueYellow");
    }
    if (phaseturn >= 2)
    {
        myattackchoice = 15;
        scr_debug_print("FloweryChaseBlueYellow");
    }
}
if (phase == 6)
{
    if (phaseturn == 1)
    {
        myattackchoice = 19;
        scr_debug_print("SuperJarona");
    }
    if (phaseturn != 1)
    {
        myattackchoice = 14;
        scr_debug_print("FloweryDeflect2point5");
    }
}
