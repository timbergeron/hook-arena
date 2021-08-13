


void() NextLevel =
{
	local entity o;
	local string newmap;
	local string nextmap;

//crt
	if (mapname == "arenax") nextmap = "xarena3";
	else if (mapname == "xarena3") nextmap = "arenazap";
	else if (mapname == "arenazap") nextmap = "arenarg4";
	else if (mapname == "arenarg4") nextmap = "arenarg5";
	else if (mapname == "arenarg5") nextmap = "arenarg6";
	else if (mapname == "arenarg6") nextmap = "crandome";
	else if (mapname == "crandome") nextmap = "egyptra";
	else if (mapname == "egyptra") nextmap = "bbarena2";
	else if (mapname == "bbarena2") nextmap = "dm2arena";
	else if (mapname == "dm2arena") nextmap = "marena2";
	else if (mapname == "marena2") nextmap = "rarena3";
	else if (mapname == "rarena3") nextmap = "23ar-a";
	else if (mapname == "23ar-a") nextmap = "basarena";
	else if (mapname == "basarena") nextmap = "chamber1";
	else if (mapname == "chamber1") nextmap = "gear8";
	else if (mapname == "gear8") nextmap = "ptucket";
	else if (mapname == "ptucket") nextmap = "yard1";
	else if (mapname == "yard1") nextmap = "mayan1";
	else if (mapname == "mayan1") nextmap = "rgarden";
	else if (mapname == "rgarden") nextmap = "arenax";

	gameover = TRUE;

	o = spawn();
	o.map = nextmap;
	o.think = execute_changelevel;
	o.nextthink = time + 0.1;

	return;
//DISABLED

	if (nextmap != "")
		return; // already done

	if (mapname == "start")
	{
		if (!cvar("registered"))
		{
			mapname = "e1m1";
		}
		else if (!(serverflags & 1))
		{
			mapname = "e1m1";
			serverflags = serverflags | 1;
		}
		else if (!(serverflags & 2))
		{
			mapname = "e2m1";
			serverflags = serverflags | 2;
		}
		else if (!(serverflags & 4))
		{
			mapname = "e3m1";
			serverflags = serverflags | 4;
		}
		else if (!(serverflags & 8))
		{
			mapname = "e4m1";
			serverflags = serverflags - 7;
		}
 
		o = spawn();
		o.map = mapname;
	}
	else
	{
		// find a trigger changelevel
		o = find(world, classname, "trigger_changelevel");
		if (!o || mapname == "start")
		{       // go back to same map if no trigger_changelevel
			o = spawn();
			o.map = mapname;
		}
	}

	nextmap = o.map;

	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};






