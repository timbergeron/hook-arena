














/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
void() CheckRules =
{       
	if (timelimit && time >= timelimit)
		NextLevel ();
	
	if (fraglimit && self.frags >= fraglimit)
		NextLevel ();
};

//============================================================================

void() PlayerDeathThink =
{
	local entity    old_self;
	local float             forward;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else    
			self.velocity = forward * normalize(self.velocity);
	}

// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

// wait for any button down -- commented out by crt - AUTORESPAWN!!
/*	if (!self.button2 && !self.button1 && !self.button0)
		return;
*/
	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};


void() PlayerJump =
{
	local vector start, end;
	
	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.waterlevel >= 2)
	{
//crt - higher jumps out of water..
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 300;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;		// don't pogo stick

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	
	self.button2 = 0;
// player jumping sound
//crt - get rid of jump sound for spec
	if (self == winner || self == loser)
		sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z + 270;
};


/*
===========
WaterMove

============
*/
.float  dmgtime;

void() WaterMove =
{
//dprint (ftos(self.waterlevel));
	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		else if (self.air_finished < time + 9)
			sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{       // drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}
	
	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{       
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{       // do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			T_Damage (self, world, world, 10*self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{       // do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4*self.waterlevel);
		}
	}
	
	if ( !(self.flags & FL_INWATER) )
	{       

// player enter water sound

		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}       
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{       // solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{       // open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;  // safety net
			return;
		}
	}
};

/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{
	local   float   mspeed, aspeed;
	local   float   r;
	local	string	valstr;
	
	

	
	
	

	if (intermission_running)
	{
		IntermissionThink ();   // otherwise a button could be missed between
		return;                                 // the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;         // intermission or finale
		
		
		
		
	if ( self.aflag )
            CCamChasePlayer ();	
		
		
		
		
		
		
		
		
		
		
//crt
	if (self.motd == 1)
	{
		sprint (self, PRINT_HIGH, "\n\n\nQuake1 «rapple “ocket ¡rena+ v1.2\n");
				sprint (self, PRINT_HIGH, "by woods - woods@das.caltech.edu\n\n");
				sprint (self, PRINT_HIGH, "Please agree with opponent before using *optional* hook.\n\n");
				sprint (self, PRINT_HIGH, "ƒÔ˜ÓÏÔ·‰ “¡ Õ·Û∫\n\n");
				sprint (self, PRINT_HIGH, "http://www.smackeron.com/arena\n\n");
				sprint (self, PRINT_HIGH, "\n\n");
		sprint (self, PRINT_HIGH, "Type: √ÔÌÌ·Ó‰Û\n\n");
		
		
		self.motd = 0;
	}

	r = rint (time_to_start - time);
	if (	(r >= 0) && 
		(time_to_start> 0) && 
		(r != last_time) &&
		(winner.classname=="player") &&
		(loser.classname=="player"))
        {
		last_time = r;
		if (r == 0)
		{
			stuffcmd(winner , "play ra/fight.wav\n");
			stuffcmd(loser , "play ra/fight.wav\n");
			bprint (PRINT_HIGH, winner.netname);
			bprint (PRINT_HIGH, " vs. ");
			bprint (PRINT_HIGH, loser.netname);			
			bprint (PRINT_HIGH, "\n");
			if (first.classname == "player")
			{
				bprint (PRINT_HIGH, first.netname);
				bprint (PRINT_HIGH, " is next in line\n");
			}
			winner.takedamage = DAMAGE_AIM;
			loser.takedamage = DAMAGE_AIM;
			centerprint (winner, "∆…«»‘°");
			centerprint (loser, "∆…«»‘°");
		}
		else
		{
			valstr=ftos(r);
			if (r<=3)
			{
				stuffcmd(winner, "play ra/");
				stuffcmd(winner, valstr);
				stuffcmd(winner,".wav\n");
				stuffcmd(loser, "play ra/");
				stuffcmd(loser, valstr);
				stuffcmd(loser,".wav\n");
			}
			centerprint3 (winner, loser.netname, "\n\n",valstr);
			centerprint3 (loser, winner.netname, "\n\n",valstr);
			W_SetCurrentAmmo ();
		}
	}

	if (self.idletime != 0)
	{
		r = rint (self.idletime - time);
		if (r != self.lasttime)
		{
			if (r == 60)
			{
				sprint (self, PRINT_HIGH,"You have 1 minute left.\n Impulse 70 to get back in line\n");
				stuffcmd(self, "play player/axhit1.wav\n");
			}
			if (r == 30)
			{
				sprint (self, PRINT_HIGH,"You have 30 seconds left.\n Impulse 70 to get back in line\n");
				stuffcmd(self, "play player/axhit1.wav\n");
			}
			if (r == 0)
			{
				sprint (self, PRINT_HIGH,"Sorry, your wait time has expired!\n");
				bprint (PRINT_HIGH,self.netname);
				self.idletime = 0;
				bprint (PRINT_HIGH," stood around too long\n");
				stuffcmd(self, "play player/death1.wav\n");
				stuffcmd(self, "disconnect\n");		
				return;
			}
			if (r <= 10)
			{
				sprint (self, PRINT_HIGH,"You have ");
				valstr=ftos(r);
				sprint (self, PRINT_HIGH,valstr);
				sprint (self, PRINT_HIGH," seconds left to get in line\n");
				stuffcmd(self, "play player/axhit1.wav\n");
			}
		}
		self.lasttime = r;
	}
	if (self != loser && self != winner)
		if ((self.laststattime < time) && winner.classname == "player" && loser.classname == "player") 
			PrintStats(self);
//end crt

	makevectors (self.v_angle);             // is this still used

        self.deathtype = "";

	CheckRules ();
	
	
	
	
	if (self.style & RA_OBSERVER)//RA OBSERVER code by JPG
	    	{
	        // find the closest teleport
	        observer_find_teleport();
	
	        // check for 'squished'
	        observer_check_size();
		}
		
		if (self.style & RA_OBSERVER)// RA Observer Code by JPG
	    	{
	          observer_pre_think();
	          return;
	        }
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	WaterMove ();
/*
	if (self.waterlevel == 2)
		CheckWaterJump ();
*/

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING)
		return; // dying, so do nothing

	if (self.button2)
	{
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time        
	if (time < self.pausetime)
		self.velocity = '0 0 0';

	if(time > self.attack_finished && self.currentammo == 0 && self.weapon != IT_AXE && self.weapon != IT_MORNINGSTAR)
		{
			self.weapon = W_BestWeapon ();
			W_SetCurrentAmmo ();
	}
};
	
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

// invisibility
	if (self.invisible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, PRINT_HIGH, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{       // just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
		
	// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
		self.modelindex = modelindex_player;    // don't use eyes
		
		
		
		

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint (self, PRINT_HIGH, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		
		if (self.invincible_finished < time)
		{       // just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
		if (self.invincible_finished > time)
		{
			self.effects = self.effects | EF_DIMLIGHT;
			self.effects = self.effects | EF_RED;
		}
		else
		{
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
			self.effects = self.effects - (self.effects & EF_RED);
		}
	}

// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				if (deathmatch == 4)
					sprint (self, PRINT_HIGH, "OctaPower is wearing off\n");
				else
					sprint (self, PRINT_HIGH, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}         
			
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{       // just stopped
			self.items = self.items - IT_QUAD;
			if (deathmatch == 4)
			{
				self.ammo_cells = 255;
				self.armorvalue = 1;
				self.armortype = 0.8;
				self.health = 100;
			}
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time)
		{
			self.effects = self.effects | EF_DIMLIGHT;
			self.effects = self.effects | EF_BLUE;
		}
		else
		{
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
			self.effects = self.effects - (self.effects & EF_BLUE);
		}
	}       

// suit 
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;          // don't drown

// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, PRINT_HIGH, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{       // just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}       












};











/*
================
PlayerPostThi






Called every frame after physics are run
================
*/


void() PlayerPostThink =
{


 if (self.style & RA_OBSERVER)
        {
         observer_post_think();
         return;
        }


// resume patch begins

       self.cnt = self.cnt + 1;

       if (self.cnt == 10)
       {
               js_update();     //update the backup entity with fragcount
               self.cnt = 0;    //once every second.
       }

	//resume patch ends




	local   float   mspeed, aspeed;
	local   float   r;

//dprint ("post think\n");
	if (self.view_ofs == '0 0 0')
		return;         // intermission or finale
	if (self.deadflag)
		return;

// check to see if player landed and play landing sound 
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) )
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			self.deathtype = "falling";
			T_Damage (self, world, world, 5); 
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
	}

	self.jump_flag = self.velocity_z;

	CheckPowerups ();
	
	CheckMOTD ();
	
 

	W_WeaponFrame ();

};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
	

void() ClientConnect =
{
//crt


    







// resume patch begins

js_resume();            
			      
	if (self.frags == 0)  
		    js_backup();   





	self.motd = 1;
	stuffcmd(self, "sv_aim 2\n");
	bprint (PRINT_HIGH, self.netname);
	bprint (PRINT_HIGH, self.netname);
	bprint (PRINT_HIGH, " entered the game\n");
	
	
	
	
	
	
	

 	
	if (self.frags == 0)                             
	{
		    bprint (PRINT_HIGH, " entered the game\n");
	}
	else
	{
		    bprint (PRINT_HIGH, " re-entered the game with "); //an alternative
		    bprint (PRINT_HIGH, ftos(self.frags));             //message is
		    bprint (PRINT_HIGH, " frag");                      //printed to 
		    if (self.frags == 1)                   //let people know
			    bprint(PRINT_HIGH, "\n");                  //that a player
		    else                                   //has returned
			    bprint(PRINT_HIGH, "s\n");                 //and regained
	}                                                  //previous frags
	
	//resume patch ends	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
// a client connecting during an intermission can cause problems
	if (intermission_running)
		GotoNextMap ();

};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
	local entity holder;
	local float wasdead;
	local string s;


	if (gameover)
		return;

//crt
	if (self.deadflag == DEAD_NO)
		wasdead = 0;
	else
		wasdead = 1;

	// let everyone else know


	bprint (PRINT_HIGH, self.netname);
	s=ftos(self.frags);
		bprint (PRINT_HIGH, " left the game with ");
		bprint (PRINT_HIGH, s);
		bprint (PRINT_HIGH, " frags\n");
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	GibPlayer();
	set_suicide_frame ();
//crt
	if (self == winner)
	{
		bprint (PRINT_HIGH, "The winner has left\n");
		winner = loser;
		if (winner.classname == "player")
		{
			bprint (PRINT_HIGH, "The new winner is ");
			bprint (PRINT_HIGH, winner.netname);
			bprint (PRINT_HIGH, "\n");
			winner.takedamage = DAMAGE_NO;
		}
		else
			bprint (PRINT_HIGH, "Waiting for winner\n");	
		getnewopponent();
	
	}
	else
	if (self == loser)
	{
		bprint (PRINT_HIGH, "The challenger has left\n");
		winner.takedamage = DAMAGE_NO;
		getnewopponent();
	}
	else
	if (self == first)
	{
		bprint (PRINT_HIGH, "The line leader has left\n");
		if (first.next == first)
			first=world;
		else
		{
	
			holder=first.prev;
			first=first.next;
			first.prev=holder;
			holder.next=first;
		}
	}
	else //in the chain
	{

		if (wasdead == 1) //I'm dead.. doesn't matter
			return;
		if (self.next == world) //got out of line
			return;

		holder=self.next;
		holder.prev=self.prev;
		holder=self.prev;
		holder.next=self.next;
	}				
	

};

/*
===========
ClientObituary

called when a player dies
============
*/

void(entity targ, entity attacker) ClientObituary =
{
	local   float rnum;
	local   string deathstring, deathstring2;
	local   string s;
	local   float ah,aa;
	local   string  attackerteam, targteam;
	local	entity tempent;

	rnum = random();
	//ZOID 12-13-96: self.team doesn't work in QW.  Use keys
//	attackerteam = infokey(attacker, "team");
//	targteam = infokey(targ, "team");
	
	if (targ.classname == "player")
	{
//crt

		if (loser.classname=="player") //stop them from attacking during countdown
		{
			loser.takedamage = DAMAGE_NO;
			stuffcmd(loser,"-attack\n");
		}
		if (winner.classname=="player")
		{
			winner.takedamage = DAMAGE_NO;
			stuffcmd(winner,"-attack\n");
		}

		if (attacker != targ)
		{
			ah=attacker.health;
			aa=attacker.armorvalue;
		}
		if (targ == winner)
		{
			winner.loses = winner.loses + 1;
			loser.wins = loser.wins + 1;
			
			bprint (PRINT_HIGH, "The winner ");
			bprint (PRINT_HIGH, winner.netname);
			bprint (PRINT_HIGH, " has been defeated\n");
			if (targ == attacker)
			{
				bprint (PRINT_HIGH, "by Himself!\n");
				attacker.frags = attacker.frags - 1;
			}
			winner = loser;

			if (winner.classname == "player")
			{
				bprint (PRINT_HIGH, "The new winner is ");
				bprint (PRINT_HIGH, winner.netname);
				bprint (PRINT_HIGH, "\n");
			}
			getnewopponent();
		}
		if (targ == loser)
		{
			loser.loses = loser.loses + 1;
			winner.wins = winner.wins + 1;
			bprint (PRINT_HIGH, "The challenger ");
			bprint (PRINT_HIGH, loser.netname);
			bprint (PRINT_HIGH, " has failed\n");
			if (targ == attacker)
			{
				bprint (PRINT_HIGH, "because he became bored with life!\n");
				attacker.frags = attacker.frags - 1;
			}
			getnewopponent();
		}
	}
	if (attacker.classname == "player")
	{
		if (attacker != targ)
		{
			if (ah == 100 && aa == 200)
			{
				bprint (PRINT_HIGH, "∆Ã¡◊Ã≈”” ÷È„ÙÔÚ˘°\n");
				
				playallsound("play ra/flawless.wav\n");
						

			}
			else
			{
				bprint (PRINT_HIGH, attacker.netname);
				bprint (PRINT_HIGH, " had ");
				s=ftos(ah);
				bprint (PRINT_HIGH, s);
				bprint (PRINT_HIGH, " health and ");
				s=ftos(aa);
				bprint (PRINT_HIGH, s);
				bprint (PRINT_HIGH, " armor left\n");
				if (ah >= 75 && aa >= 100)
					playallsound("play ra/excelent.wav\n");				
			}
			attacker.frags = attacker.frags + 1;
		}
//		logfrag (attacker, targ);
	}


/*		if (deathmatch > 3)	 //no other messages in RA!!
		{
			if (targ.deathtype == "selfwater")
			{
				bprint (PRINT_MEDIUM, targ.netname);
				bprint (PRINT_MEDIUM," electrocutes himself.\n ");
				targ.frags = targ.frags - 1;
				return;
			}
		}

		if (attacker.classname == "teledeath")
		{
			bprint (PRINT_MEDIUM,targ.netname);
			bprint (PRINT_MEDIUM," was telefragged by ");
			bprint (PRINT_MEDIUM,attacker.owner.netname);
			bprint (PRINT_MEDIUM,"\n");
			logfrag (attacker.owner, targ);

			attacker.owner.frags = attacker.owner.frags + 1;
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint (PRINT_MEDIUM,"Satan's power deflects ");
			bprint (PRINT_MEDIUM,targ.netname);
			bprint (PRINT_MEDIUM,"'s telefrag\n");

			targ.frags = targ.frags - 1;
			logfrag (targ, targ);
			return;
		}

		// double 666 telefrag (can happen often in deathmatch 4)
		if (attacker.classname == "teledeath3") 
		{
			bprint (PRINT_MEDIUM,targ.netname);
			bprint (PRINT_MEDIUM," was telefragged by ");
			bprint (PRINT_MEDIUM,attacker.owner.netname);
			bprint (PRINT_MEDIUM, "'s Satan's power\n");
			targ.frags = targ.frags - 1;
			logfrag (targ, targ);
			return;
		}
	

		if (targ.deathtype == "squish")
		{
			if (teamplay && targteam == attackerteam && attackerteam != "" && targ != attacker)
			{
				logfrag (attacker, attacker);
				attacker.frags = attacker.frags - 1; 
				bprint (PRINT_MEDIUM,attacker.netname);
				bprint (PRINT_MEDIUM," squished a teammate\n");
				return;
			}
			else if (attacker.classname == "player" && attacker != targ)
			{
				bprint (PRINT_MEDIUM, attacker.netname);
				bprint (PRINT_MEDIUM," squishes ");
				bprint (PRINT_MEDIUM,targ.netname);
				bprint (PRINT_MEDIUM,"\n");
				logfrag (attacker, targ);
				attacker.frags = attacker.frags + 1;
				return;
			}
			else
			{
				logfrag (targ, targ);
				targ.frags = targ.frags - 1;            // killed self
				bprint (PRINT_MEDIUM,targ.netname);
				bprint (PRINT_MEDIUM," was squished\n");
				return;
			}
		}

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				// killed self
				logfrag (attacker, attacker);
				attacker.frags = attacker.frags - 1;
				bprint (PRINT_MEDIUM,targ.netname);
				if (targ.deathtype == "grenade")
					bprint (PRINT_MEDIUM," tries to put the pin back in\n");
				else if (targ.deathtype == "rocket")
					bprint (PRINT_MEDIUM," becomes bored with life\n");
				else if (targ.weapon == 64 && targ.waterlevel > 1)
				{
					if (targ.watertype == CONTENT_SLIME)
						bprint (PRINT_MEDIUM," discharges into the slime\n");
					else if (targ.watertype == CONTENT_LAVA)
						bprint (PRINT_MEDIUM," discharges into the lava\n");
					else
						bprint (PRINT_MEDIUM," discharges into the water.\n");
				}
				else
					bprint (PRINT_MEDIUM," becomes bored with life\n");
				return;
			}
			else if ( (teamplay == 2) && (targteam == attackerteam) &&
				(attackerteam != "") )
			{
				if (rnum < 0.25)
					deathstring = " mows down a teammate\n";
				else if (rnum < 0.50)
					deathstring = " checks his glasses\n";
				else if (rnum < 0.75)
					deathstring = " gets a frag for the other team\n";
				else
					deathstring = " loses another friend\n";
				bprint (PRINT_MEDIUM, attacker.netname);
				bprint (PRINT_MEDIUM, deathstring);
				attacker.frags = attacker.frags - 1;
				//ZOID 12-13-96:  killing a teammate logs as suicide
				logfrag (attacker, attacker);
				return;
			}
			else
			{
				logfrag (attacker, targ);
				attacker.frags = attacker.frags + 1;

				rnum = attacker.weapon;
				if (targ.deathtype == "nail")
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
				}
				else if (targ.deathtype == "supernail")
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				else if (targ.deathtype == "grenade")
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				else if (targ.deathtype == "rocket")
				{
					if (attacker.super_damage_finished > 0 && targ.health < -40)
					{
						rnum = random();
						if (rnum < 0.3)
							deathstring = " was brutalized by ";
						else if (rnum < 0.6)
							deathstring = " was smeared by ";
						else
						{
							bprint (PRINT_MEDIUM, attacker.netname);
							bprint (PRINT_MEDIUM, " rips ");
							bprint (PRINT_MEDIUM, targ.netname);
							bprint (PRINT_MEDIUM, " a new one\n");
							return;
						}
						deathstring2 = "'s quad rocket\n";
					}
					else
					{
						deathstring = " rides ";
						deathstring2 = "'s rocket\n";
						if (targ.health < -40)
						{
							deathstring = " was gibbed by ";
							deathstring2 = "'s rocket\n" ;
						}
					}
				}
				else if (rnum == IT_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
				
				
                                 else if (rnum == IT_MORNINGSTAR)
				{
					deathstring = " was disemboweled by ";
					deathstring2 = "\n";
				}				
				
				
				
				
				
	
				else if (rnum == IT_SHOTGUN)
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
				}
				else if (rnum == IT_SUPER_SHOTGUN)
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
				else if (rnum == IT_LIGHTNING)
				{
					deathstring = " accepts ";
					if (attacker.waterlevel > 1)
						deathstring2 = "'s discharge\n";
					else
						deathstring2 = "'s shaft\n";
				}
				bprint (PRINT_MEDIUM,targ.netname);
				bprint (PRINT_MEDIUM,deathstring);
				bprint (PRINT_MEDIUM,attacker.netname);
				bprint (PRINT_MEDIUM,deathstring2);
			}
			return;
		}
		else
		{
			logfrag (targ, targ);
			targ.frags = targ.frags - 1;            // killed self
			rnum = targ.watertype;

			bprint (PRINT_MEDIUM,targ.netname);
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint (PRINT_MEDIUM," sleeps with the fishes\n");
				else
					bprint (PRINT_MEDIUM," sucks it down\n");
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (PRINT_MEDIUM," gulped a load of slime\n");
				else
					bprint (PRINT_MEDIUM," can't exist on slime alone\n");
				return;
			}
			else if (rnum == -5)
			{
				if (targ.health < -15)
				{
					bprint (PRINT_MEDIUM," burst into flames\n");
					return;
				}
				if (random() < 0.5)
					bprint (PRINT_MEDIUM," turned into hot slag\n");
				else
					bprint (PRINT_MEDIUM," visits the Volcano God\n");
				return;
			}

			if (attacker.classname == "explo_box")
			{
				bprint (PRINT_MEDIUM," blew up\n");
				return;
			}
			if (targ.deathtype == "falling")
			{
				bprint (PRINT_MEDIUM," fell to his death\n");
				return;
			}
			if (targ.deathtype == "nail" || targ.deathtype == "supernail")
			{
				bprint (PRINT_MEDIUM," was spiked\n");
				return;
			}
			if (targ.deathtype == "laser")
			{
				bprint (PRINT_MEDIUM," was zapped\n");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint (PRINT_MEDIUM," ate a lavaball\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (PRINT_MEDIUM," tried to leave\n");
				return;
			}

			bprint (PRINT_MEDIUM," died\n");
		}

	}*/
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
};
