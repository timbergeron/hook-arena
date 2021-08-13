
// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

//crt
entity(string spottype) SelectSpawnPoint;
void() GibPlayer;

float   modelindex_eyes, modelindex_player;


void() CheckMOTD =
{
    if ((self.motd_count < 6) && (self.motd_time < time)) // 10 == seconds MOTD will display
    {
        self.motd_time = time + 1;
        self.motd_count = self.motd_count + 1;
        centerprint(self, "Quake1 Çrapple Òocket Árena+ v1.2\n\nby woods - woods@das.caltech.edu\n\n\nThis is  RA an with an *optional* hook. Monkeys, enjoy.\n\nPlease agree with opponent before using hook.\n\n\nCheck console for ãïííáîäó"); //Type in you're message here "\n" = new line

 
 // bindings for commands
 
 DoBindings ();
        return;
    }
};



/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

string nextmap;

float   intermission_running;
float   intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
	self.angles = self.mangle;      // so C can get at it
};



void() SetChangeParms =
{
	if (self.health <= 0)
	{
		SetNewParms ();
		return;
	}
 
// remove items
	self.items = self.items - (self.items & 
	(IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	
// cap super health
	if (self.health > 100)
		self.health = 100;
	if (self.health < 50)
		self.health = 50;
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;
	if (self.ammo_shells < 25)
		parm4 = 25;
	else
		parm4 = self.ammo_shells;
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
	parm10 = self.style;      //added for cam?
	parm11 = self.state;    // player ID
        parm12 = self.lip;      // ID of player being watched in observer mode
        
        
        
        
};

void() SetNewParms =
{
	parm1 = IT_SHOTGUN | IT_AXE | IT_MORNINGSTAR;
	parm2 = 100;
	parm3 = 0;
	parm4 = 25;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 1;
	parm9 = 0;
	// RA Observer Code by JPG -start-	
	parm10 = NEW_CLIENT;
        parm11 = 0; // player ID
	parm12 = 0; // ID of player being watched in observer mode
		// RA Observer Code by JPG -end-
};
	
	
	




void () SetArenaParms =
{
   parm1 = ((((((((IT_SHOTGUN | IT_AXE) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN) | IT_ARMOR3;
   parm2 = 100;
   parm3 = 200;
   parm4 = 100;
   parm5 = 100;
   parm6 = 100;
   parm7 = 100;
   parm8 = 32;
   parm9 = 80.000999;   
   parm10 = self.style;   
};

void () SetNewParms2 =
{   
   parm1  = IT_AXE;
   parm2  = 100;
   parm3  = 0;
   parm4  = 0;
   parm5  = 0;
   parm6  = 0;
   parm7  = 0;
   parm8  = 0;
   parm9  = 0;
   parm10 = self.style;      
};




















void() DecodeLevelParms =
{
	if (serverflags)
	{
		if (world.model == "maps/start.bsp")
			SetNewParms ();         // take away all stuff on starting new episode
	}
	
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;
	self.style = parm10; //added for cam?
	self.state = parm11; //added for cam?	
        self.lip   = parm12; //added for cam?	
	
	
	
	
	
	
	
	
	
};


/*crt crt crt*/
//some of this code taken from CTF by Zoid (zoid@threewave.com)

string(entity who) TeamSetStatRes =
{
	if (who.statstate > 7) // 768 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 7) // 600 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 6) // 480 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 5) // 400
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 4) // 384 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 3) // 350 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 2) // 300 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 1) // 240 
		return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	// 200 
	return "\n\n\n\n\n\n\n\n\n\n\n\n";
};


void(entity who) PrintStats =
{
	local string wh,wa,lh,la, res;


	who.laststattime = time + PLAYERSTATTIME;

	res = TeamSetStatRes(who);
/*	wh = ftos(winner.health);  didn't work worth anything
	wa = ftos(winner.armorvalue);
	lh = ftos(loser.health);
	la = ftos(loser.armorvalue);

//	centerprint12(who, res, winner.netname, "  HEALTH:",wh,"  ARMOR:",wa,"\n",loser.netname,"  HEALTH:",lh,"  ARMOR:",la);
	centerprint7(who, res, winner.netname,wh,wa,loser.netname,lh,la);*/
	centerprint5(who, res, winner.netname,"          ",loser.netname,"              ");
	if (winner.health > 0)
		self.armorvalue=winner.health;
	if (loser.health > 0)
		self.health = loser.health;
	who.currentammo = who.mypos;

};	

void(string playstr) playallsound =
{
	local entity tempent;

	if (winner.classname == "player")
		stuffcmd(winner, playstr);
	if (loser.classname == "player")
		stuffcmd(loser, playstr);
	if (self.classname == "player")
		stuffcmd(self, playstr);
	if (first.classname == "player")
	{				
		tempent = first;
		do
		{
			stuffcmd(tempent, playstr);
			tempent = tempent.next;
		} while (tempent != first);
	}
};



















float() readytostart = 
{
	if (time > time_to_start && winner.classname=="player" && loser.classname=="player")
		return 1;
	else
		return 0;
};


// second function for when players was in the countdown not used anymore

float() readytostart2 = 
{
	if (winner.classname=="player" && loser.classname=="player")
		return 1;
	else
		return 0;
};


// end second function for when players was in the countdown




void(entity anent) setfullwep =
{
		anent.ammo_nails = anent.ammo_nails + 200;
		anent.ammo_shells = anent.ammo_shells + 200;
		anent.ammo_rockets = anent.ammo_rockets + 100;
		anent.ammo_cells = anent.ammo_cells + 100;
	if (anent.ammo_shells > 100)
		anent.ammo_shells = 100;
	if (anent.ammo_nails > 200)
		anent.ammo_nails = 200;
	if (anent.ammo_rockets > 100)
		anent.ammo_rockets = 100;		
	if (anent.ammo_cells > 100)
		anent.ammo_cells = 100;		
		anent.items = IT_AXE | IT_SHOTGUN;
		anent.items = anent.items | IT_MORNINGSTAR;
		anent.items = anent.items | IT_NAILGUN;
		anent.items = anent.items | IT_SUPER_NAILGUN;
		anent.items = anent.items | IT_SUPER_SHOTGUN;
		anent.items = anent.items | IT_ROCKET_LAUNCHER;
		anent.items = anent.items | IT_GRENADE_LAUNCHER;
		anent.items = anent.items | IT_LIGHTNING;
		anent.items = anent.items - (anent.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;
		anent.armorvalue = 200;
		anent.armortype = 0.8;
		anent.health = 100;
		anent.weapon = 32;
		anent.super_damage_finished = 0;
		anent.radsuit_finished = 0;
		anent.invisible_finished = 0;
		anent.invincible_finished = 0;
		anent.effects = 0;
		anent.invincible_time = 0;
		W_SetCurrentAmmo ();

};






















void(entity anent) setfullhealth = //not going to use anymore? NOPE!
{
		anent.armorvalue = 200;
		anent.armortype = 0.8;
		anent.health = 100;
};

void(entity anent, entity t) teleport_to_arena =
{
	local vector org;

	spawn_tfog (anent.origin);

// spawn a tfog flash in front of the destination
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

	spawn_tfog (org);
	spawn_tdeath(t.origin, anent);

// move the player and lock him down for a little while
	if (!anent.health)
	{
		anent.origin = t.origin;
		anent.velocity = (v_forward * anent.velocity_x) + (v_forward * anent.velocity_y);
		return;
	}

	setorigin (anent, t.origin);
	anent.angles = t.mangle;
	if (anent.classname == "player")
	{
		anent.fixangle = 1;		// turn this way immediately
		anent.teleport_time = time + 0.7;
		if (anent.flags & FL_ONGROUND)
			anent.flags = anent.flags - FL_ONGROUND;
		anent.velocity = v_forward * 300;
	}
	anent.flags = anent.flags - anent.flags & FL_ONGROUND;	
};

void(entity anent) gotoarena = //crt
{
	local entity sp;

	sp = SelectSpawnPoint("info_teleport_destination");

	teleport_to_arena(anent, sp);
	setorigin(anent, sp.origin);
	setfullwep(anent);
	stuffcmd(anent, "r_drawviewmodel 1\n");
	if (winner != anent)
	{
		setfullwep(winner);
		time_to_start = time + 10;
	}

};



void() getnewopponent = 
{
	local entity holder;
	local float pos;


	if (first.classname == "player")
	{
		loser = first;
		holder = first.prev;
		if (first == first.next)
			first=world;
		else
		{
			first = first.next;
			first.prev=holder;
			holder.next=first;
			
		}
		
		gotoarena(loser);
		bprint (PRINT_HIGH, "The new challenger is ");
		bprint (PRINT_HIGH, loser.netname);
		bprint (PRINT_HIGH, "\n");
		if (first.classname == "player")
		{
			holder = first;
			pos = 0;
			do
			{
				pos = pos + 1;
				holder.mypos = pos;
				holder = holder.next;
			} while (holder.classname == "player" && holder != first);
		}
	}
	else
	{
		loser=world;
		bprint (PRINT_HIGH, "Waiting for opponent\n");	
	}
};

void(entity anent) addtoqueue=
{
	local	entity	trail;
	local	float	pos;
	if (first.classname != "player")
	{
		first=anent;
		first.next=first;
		first.prev=first;
		sprint(anent, PRINT_HIGH, "You are next in line\n");
		anent.mypos = 1;
	}
	else
	{
		trail=first.prev;
		trail.next=anent;
		anent.prev=trail;
		first.prev=anent;
		anent.next=first;
		sprint(anent, PRINT_HIGH, "You are last in line\n");
		
		trail = first;
		pos = 1;
		do
		{
			trail = trail.next;
			pos = pos + 1;
		} while (trail != anent);
		anent.mypos = pos;
		
	}
};

/*crt crt crt*/



/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission =
{
	local   entity spot;
	local   float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{       // pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
	objerror ("FindIntermission: no spot");
};


void() GotoNextMap =
{
	local string newmap;

//ZOID: 12-13-96, samelevel is overloaded, only 1 works for same level

	if (cvar("samelevel") == 1)   // if samelevel is set, stay on same level
	
		changelevel (mapname);
	else
		changelevel (nextmap);
	/*
	else {
		// configurable map lists, see if the current map exists as a
		// serverinfo/localinfo var
		newmap = infokey(world, mapname);
		if (newmap != "")
			changelevel (newmap);
		else
			changelevel (nextmap);
	}
	*/
};



/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;
	
	GotoNextMap ();
};

/*
============
execute_changelevel

The global "nextmap" has been set previously.
Take the players to the intermission spot
============
*/
void() execute_changelevel =
{
	local entity	pos;

	intermission_running = 1;
	
// enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + 5;
	else
		intermission_exittime = time + 2;

	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);
	
	pos = FindIntermission ();

	other = find (world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = TRUE;		// turn this way immediately
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);
		other = find (other, classname, "player");
	}	

	WriteByte (MSG_ALL, SVC_INTERMISSION);
};


void() changelevel_touch =
{
	local entity    pos;

	if (other.classname != "player")
		return;

// if "noexit" is set, blow up the player trying to leave
//ZOID, 12-13-96, noexit isn't supported in QW.  Overload samelevel
//      if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	if ((cvar("samelevel") == 2) || ((cvar("samelevel") == 3) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}

	bprint (PRINT_HIGH, other.netname);
	bprint (PRINT_HIGH," exited the level\n");
	
	nextmap = self.map;

	SUB_UseTargets ();

	self.touch = SUB_Null;

// we can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (!self.map)
		objerror ("chagnelevel trigger doesn't have map");
	
	InitTrigger ();
	self.touch = changelevel_touch;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	// make a copy of the dead body for appearances sake
	CopyToBodyQue (self);
	// set default spawn parms
	SetNewParms ();
	// respawn              
	PutClientInServer ();
};


/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
	//crt - disable suicide
	return;
	//end crt;
	bprint (PRINT_MEDIUM, self.netname);
	bprint (PRINT_MEDIUM, " suicides\n");
	set_suicide_frame ();
	self.modelindex = modelindex_player;
//	logfrag (self, self);
	self.frags = self.frags - 2;    // extra penalty
	respawn ();
};

float(vector v) CheckSpawnPoint =
{
	return FALSE;
};

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
//crt - changed this procedure to find ANY entity type
entity(string spottype) SelectSpawnPoint =
{
	local   entity spot, newspot, thing;
	local   float   numspots, totalspots;
	local   float   rnum, pcount;
	local   float   rs;
	local entity spots;

	numspots = 0;
	totalspots = 0;

// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
		
// choose a info_player_deathmatch point

// ok, find all spots that don't have players nearby

	spots = world;
	spot = find (world, classname, spottype);       
	while (spot)
	{
		totalspots = totalspots + 1;

		thing=findradius(spot.origin, 84);
		pcount=0;               
		while (thing)
		{
			if (thing.classname == "player")
				pcount=pcount + 1;                      
			thing=thing.chain;      
		}
		if (pcount == 0) {
			spot.goalentity = spots;
			spots = spot;
			numspots = numspots + 1;
		}

		// Get the next spot in the chain
		spot = find (spot, classname, spottype);                
	}
	totalspots=totalspots - 1;
	if (!numspots) {
		// ack, they are all full, just pick one at random
//		bprint (PRINT_HIGH, "Ackk! All spots are full. Selecting random spawn spot\n");
		totalspots = rint((random() * totalspots));
		spot = find (world, classname, spottype);       
		while (totalspots > 0) {
			totalspots = totalspots - 1;
			spot = find (spot, classname, spottype);
		}
		return spot;
	}
		
// We now have the number of spots available on the map in numspots

	// Generate a random number between 1 and numspots

	numspots = numspots - 1;
	
	numspots = rint((random() * numspots ) );

	spot = spots;
	while (numspots > 0) {
		spot = spot.goalentity;
		numspots = numspots - 1;
	}
	return spot;

};
void() DecodeLevelParms;
void() PlayerDie;

/*
===========
ValidateUser


============
*/
float(entity e) ValidateUser =
{
/*
	local string    s;
	local string    userclan;
	local float     rank, rankmin, rankmax;

//
// if the server has set "clan1" and "clan2", then it
// is a clan match that will allow only those two clans in
//
	s = serverinfo("clan1");
	if (s)
	{
		userclan = masterinfo(e,"clan");
		if (s == userclan)
			return true;
		s = serverinfo("clan2");
		if (s == userclan)
			return true;
		return false;
	}

//
// if the server has set "rankmin" and/or "rankmax" then
// the users rank must be between those two values
//
	s = masterinfo (e, "rank");
	rank = stof (s);

	s = serverinfo("rankmin");
	if (s)
	{
		rankmin = stof (s);
		if (rank < rankmin)
			return false;
	}
	s = serverinfo("rankmax");
	if (s)
	{
		rankmax = stof (s);
		if (rankmax < rank)
			return false;
	}

	return true;
*/
};





void() PutClientInArena =
{
	local entity spot;        
 
         //remove observer stuff---------
         if (self.style & RA_OBSERVER) 
         self.style        = self.style - (self.style & RA_OBSERVER);
         
         self.dest1        = self.dest2 
                            = self.dest 
                            = self.mangle 
                            = '0 0 0';
         //--convert to player-----------                   
         
         //spot = find(world, classname, "info_teleport_destination");
         spot = SelectSpawnPoint ("info_teleport_destination",ra_spawns);
         self.trigger_field= spot;
         
//	 self.touch        = player_touch;
	 self.classname    = "player";
	 self.health       = 100;
	 self.takedamage   = DAMAGE_NO;
         self.solid        = SOLID_SLIDEBOX;
	 self.movetype     = MOVETYPE_WALK;	 
	 self.max_health   = 100;
	 self.flags        = FL_CLIENT;	 
	 self.dmg          = 2;   		// initial water damage
	 self.air_finished = time + 12;
         self.effects      = 0;
         
	 //--make him phat----------------
	 self.items        = ((((((((IT_SHOTGUN | IT_AXE) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN) | IT_ARMOR3;
	 self.health       = 100;
	 self.armorvalue   = 200;
	 self.ammo_shells  = 100;
	 self.ammo_nails   = 100;
	 self.ammo_rockets = 100;
	 self.ammo_cells   = 100;
	 self.weapon       = 32;
	 self.armortype    = (80.000999) * 0.01;         
         //--lock*&*load-----
  	 W_SetCurrentAmmo ();

	 self.attack_finished = time;
	 self.th_pain         = player_pain;
	 self.th_die          = PlayerDie;
	
	 self.deadflag  = DEAD_NO;
         
	 self.pausetime = 0;// paustime is set by teleporters to keep the player from moving a while
	 self.origin    = spot.origin + '0 0 1';
	 self.angles    = spot.angles;
	 self.fixangle  = TRUE;		// turn this way immediately
         self.velocity  = '0 0 0'; 
         self.velocity  = v_forward * 300;
	 setmodel (self, "progs/player.mdl");
	 
	 if (modelindex_player==0) modelindex_player = self.modelindex;

	 setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	 player_stand1 ();
	 self.view_ofs = '0 0 28';//default was 22 :) taller!
	 self.height = (self.team) - 1;
         	 
	 makevectors(self.angles);
	 spawn_tdeath (self.origin, self);	 
	 spawn_tfog (self.origin);	 
};






















/*
===========
PutClientInServer

called each time a player enters a new level
============
*/
void() PutClientInServer =
{
	local   entity spot;
	local 	string	s;
	local	entity trail;

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_NO; //crt
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;                   // initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;

	DecodeLevelParms ();
	
	W_SetCurrentAmmo ();
	
	
	
	if ( self.aflag )
             CCamChasePlayer ();
	
	
	
	
	
	

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	
	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
	spot = SelectSpawnPoint ("info_player_deathmatch");

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;           // turn this way immediately

// oh, this is a hack!
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';

// Mod - Xian (May.20.97)
// Bug where player would have velocity from their last kill

	self.velocity = '0 0 0';

	player_stand1 ();
	
	makevectors(self.angles);
	spawn_tfog (self.origin + v_forward*20);

	spawn_tdeath (self.origin, self);

/*
	// Set Rocket Jump Modifiers
	if (stof(infokey(world, "rj")) != 0)
	{                
		rj = stof(infokey(world, "rj"));
	}
*/
	
/*	if (deathmatch == 4)
	{
		self.ammo_shells = 0;
		if (stof(infokey(world, "axe")) == 0)
		{
			self.ammo_nails = 255;
			self.ammo_shells = 255;
			self.ammo_rockets = 255;
			self.ammo_cells = 255;
			self.items = self.items | IT_NAILGUN;
			self.items = self.items | IT_SUPER_NAILGUN;
			self.items = self.items | IT_SUPER_SHOTGUN;
			self.items = self.items | IT_ROCKET_LAUNCHER;
//		self.items = self.items | IT_GRENADE_LAUNCHER;
			self.items = self.items | IT_LIGHTNING;
		}
		self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;
		self.armorvalue = 200;
		self.armortype = 0.8;
		self.health = 250;
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	}

	if (deathmatch == 5)
	{
		self.ammo_nails = 80;
		self.ammo_shells = 30;
		self.ammo_rockets = 10;
		self.ammo_cells = 30;
		self.items = self.items | IT_NAILGUN;
		self.items = self.items | IT_SUPER_NAILGUN;
		self.items = self.items | IT_SUPER_SHOTGUN;
		self.items = self.items | IT_ROCKET_LAUNCHER;
		self.items = self.items | IT_GRENADE_LAUNCHER;
		self.items = self.items | IT_LIGHTNING;
		self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;
		self.armorvalue = 200;
		self.armortype = 0.8;
		self.health = 200;
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	}
*/
//crt!!
		self.ammo_shells = 10;
		self.ammo_nails = 0;
		self.ammo_shells = 0;
		self.ammo_rockets = 0;
		self.ammo_cells = 0;
		self.takedamage = DAMAGE_NO;
		self.items = IT_AXE;
		self.items = IT_NAILGUN;
		


// code to take things away this is what spectaror spwans with





		self.armorvalue = 0;
		self.armortype = 0;
		self.health = 100;
		self.weapon = 4096;
		self.idletime = 0;
		self.lasttime = 0;
		self.laststattime = 0;

		

//crt
	if (self.netname == "unconnected")
		return;

	if (winner.classname != "player")
	{
		winner=self;
		gotoarena(self);
		self.next=self;
		self.prev=self;
		bprint (PRINT_HIGH, "Waiting for opponent\n");
	}
	else
		if (loser.classname != "player")
		{
			loser=self;
			gotoarena(self);
			self.next=self;
			self.prev=self;
			bprint (PRINT_HIGH, self.netname);
			bprint (PRINT_HIGH, " is the new challenger\n");
		}
		else
		{
			stuffcmd(self, "r_drawviewmodel 0\n");
			addtoqueue(self);
		}

		W_SetCurrentAmmo ();



 observer_start();// non contestants forced observers         

//crt!!
};






/*
===========
PutClientInServerReg

called each time a player enters a new level
============
*/
void() PutClientInServerReg =
{
	local   entity spot;
	local 	string	s;
	local	entity trail;

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_NO; //crt
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;                   // initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;

	DecodeLevelParms ();
	
	W_SetCurrentAmmo ();
	
	
	
	if ( self.aflag )
             CCamChasePlayer ();
	
	
	
	
	
	

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	
	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
	spot = SelectSpawnPoint ("info_player_deathmatch");

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;           // turn this way immediately

// oh, this is a hack!
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';

// Mod - Xian (May.20.97)
// Bug where player would have velocity from their last kill

	self.velocity = '0 0 0';

	player_stand1 ();
	
	makevectors(self.angles);
	spawn_tfog (self.origin + v_forward*20);

	spawn_tdeath (self.origin, self);

/*
	// Set Rocket Jump Modifiers
	if (stof(infokey(world, "rj")) != 0)
	{                
		rj = stof(infokey(world, "rj"));
	}
*/
	
/*	if (deathmatch == 4)
	{
		self.ammo_shells = 0;
		if (stof(infokey(world, "axe")) == 0)
		{
			self.ammo_nails = 255;
			self.ammo_shells = 255;
			self.ammo_rockets = 255;
			self.ammo_cells = 255;
			self.items = self.items | IT_NAILGUN;
			self.items = self.items | IT_SUPER_NAILGUN;
			self.items = self.items | IT_SUPER_SHOTGUN;
			self.items = self.items | IT_ROCKET_LAUNCHER;
//		self.items = self.items | IT_GRENADE_LAUNCHER;
			self.items = self.items | IT_LIGHTNING;
		}
		self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;
		self.armorvalue = 200;
		self.armortype = 0.8;
		self.health = 250;
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	}

	if (deathmatch == 5)
	{
		self.ammo_nails = 80;
		self.ammo_shells = 30;
		self.ammo_rockets = 10;
		self.ammo_cells = 30;
		self.items = self.items | IT_NAILGUN;
		self.items = self.items | IT_SUPER_NAILGUN;
		self.items = self.items | IT_SUPER_SHOTGUN;
		self.items = self.items | IT_ROCKET_LAUNCHER;
		self.items = self.items | IT_GRENADE_LAUNCHER;
		self.items = self.items | IT_LIGHTNING;
		self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;
		self.armorvalue = 200;
		self.armortype = 0.8;
		self.health = 200;
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	}
*/
//crt!!
		self.ammo_shells = 10;
		self.ammo_nails = 0;
		self.ammo_shells = 0;
		self.ammo_rockets = 0;
		self.ammo_cells = 0;
		self.takedamage = DAMAGE_NO;
		self.items = IT_AXE;
		self.items = IT_NAILGUN;
		


// code to take things away this is what spectaror spwans with





		self.armorvalue = 0;
		self.armortype = 0;
		self.health = 100;
		self.weapon = 4096;
		self.idletime = 0;
		self.lasttime = 0;
		self.laststattime = 0;

		

//crt
	if (self.netname == "unconnected")
		return;

	if (winner.classname != "player")
	{
		winner=self;
		gotoarena(self);
		self.next=self;
		self.prev=self;
		bprint (PRINT_HIGH, "Waiting for opponent\n");
	}
	else
		if (loser.classname != "player")
		{
			loser=self;
			gotoarena(self);
			self.next=self;
			self.prev=self;
			bprint (PRINT_HIGH, self.netname);
			bprint (PRINT_HIGH, " is the new challenger\n");
		}
		else
		{
			stuffcmd(self, "r_drawviewmodel 0\n");
			addtoqueue(self);
		}

		W_SetCurrentAmmo ();



// observer_start();// non contestants forced observers         

//crt!!
};









































/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
};


/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 =
{
};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
};

/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
*/
