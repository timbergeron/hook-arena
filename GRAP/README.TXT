GRAPPLING HOOK V1.12
(EDITED FROM MORNING STAR V 1.11 TO REMOVE THE FREEZE)

Hi!

Instructions:

        1.  Store the PAK0.PAK file in any subdirectoy of your Quake
            program directory EXCEPT the \id1 subdirectory.  (Trust me, you
            DON'T want to erase your old PAK0.PAK file.)

        2.  Start up Quake using the -game parameter to indicate which
            subdirectory the PAK0.PAK file is stored under.  For example,
            if Quake is in C:\QUAKE and the new PAK0.PAK file is in
            C:\QUAKE\GRAPPLE, you would use the following command line for
            Quake:

            QUAKE -game GRAPPLE

        3.  Select the Morning Star by either selecting the axe twice, or by
            using IMPULSE 21.

        4.  The Morning Star is fairly simple to use, but rather difficult to
            use correctly.  <grin>  Press the attack button to fire the
            Morning Star.  If the star makes contact, and you are still
            holding the attack button, you will be pulled up to it and held
            there until you release the star (by releasing the attack button).

            You can now change weapons while the star is attatched to
            something.  (I didn't want to do that, since it makes the star
            ridiculously powerful as a weapon.  But apparently the majority
            of Quake players won't use a weapon unless it's at least as
            powerful as a BFG 9000.)  You can't control the star while you
            are using another weapon though; to unhook the star, you have
            to change back to it.  (I will change the star back to the "old
            style" if I get enough complaints.  For some reason, people only
            like the super-powerful weapons until they get nailed by it
            themselves a few times.  <grin>)

            Also, if the hook doesn't QUITE pull you up to a platform, you
            can hold the jump button while hanging.  This makes you move the
            chain downward, to foot level.  Usually this is enough to get you
            onto the platform.  (If you are trying to pull yourself up from
            the bottom of a platform through a half-inch hole, though, don't
            bother.  <grin>)  This also works if the grapple has trouble
            negotiating stairs.


Fixes since 1.00:

	- No longer causes crash when attached to a shootable trigger
          or evil altar
        - much cooler sights & sounds when attached to enemy
        - improved view model (it still looks like an axe, but it goes
          through a full swing now)

Fixes since 1.01:

        - No more diagnostic data (how embarrasing!)

Fixes since 1.02:

        - Morning star now trails a chain behind it, so players in Deathmatch
          no longer have to search for the telltale spiked ball to see where
          you're going (and how long it'll take you to get there).
        - Fixed a potential bug in Deathmatch, which could cause players to
          be permenantly paralyzed if hit with more than one grapple.
        - Changed damage process.  Now damage done by an attached grapple is
          no longer dependent on the frame rate (unless your frame rate drops
          below 10 fps).
        - Fixed "jitters" caused by hanging from attached grapple.  Actually
          they're still there, but are a lot less obvious.
        - Allowed limited "swinging" from attached grapple.  Try moving back
          and forth while attached.
        - Made the axe a seperate weapon.  You can access it either by
          using IMPULSE 21 or using IMPULSE 1 to toggle between the axe and
          the grapple.  (You can tell the difference by the fact that when
          the grapple is active, the shotgun is lit, even though an axe is
          seen.)
        - Getting teleported now causes the grapple to automatically release.

Fixes since 1.03:

        - Getting killed now causes the grapple to automatically release.
          (If I had a server, I would have found this one so damn fast...
          <sigh>)
        - Fixed the Obits.  Now it knows the diff between an axe and a 
          morning star.

Fixes since 1.04:

        - Fixed the intermittent player paralysis bug.  A ridiculously
          stupid mistake; the only reason I didn't fix it before was because
          it seemed to work.

Fixes since 1.05:

        - NEW MODELS!  Now has a new star, chain, and view model!
        - Changed the "HookPull" physics again.  Now the hook's origin moves
          as the player rotates.
        - Changed the star's bounding box.  Now you have to hit the enemy
          dead on to hook him.  This makes the star MUCH more difficult to
          use as a weapon at long range (especially in Deathmatch).
        - Uses a "flying" player model in Deathmatch ("deathc4").

Fixes since 1.06:

        - I _think_ I fixed the player paralysis bug that occurs when a
          hooked player attempts to fire his weapon.  Whoever gets this file,
          try this:

                1.  One player hooks another.
                2.  The hooked player attempts to fire his weapon.
                3.  The hooker releases the hook.
                4.  The hooked player attempts to fire his weapon again.

          In previous versions, under these circumstances, the hookee could
          no longer fire any weapons, until killed.  As I said, I think I
          fixed this bug, but I won't know unless someone runs across it
          again.

Changes since 1.08:

        - ALL RIGHT ALL READY!  I've changed the star so you can now fire
          other weapons while attatched.  Hope you all enjoy it.
        - Now the jump button elevates you on the chain.  You can get up
          from the edge of platforms that way.

Changes since 1.09:

        - Now the files are stored in a PAK file.  It took me a while to get
          this one to work, so I hope you appreciate it.  <grin>

Changes since 1.09b:

        - Fixed the "weapon change" key.  (The ONE thing I never tested...
          oh well.)
        - Added a mess of new sounds.
        - I *think* the intermittent weapon-freeze bug is fixed.  Since this
          bug only happens in about one out of every thousand uses of the
          grapple, it's impossible to tell if it's truly fixed until it
          happens again, in which case we'll know it isn't.
        - Now even easier to negotiate stairs, platform edges, etc. with the
          Jump button.
        - Took out the "flying" model, after complaints that it looked really
          dorky.
        - Put the Morning Star impulse commands near the front of this text
          file, so the lamers (hopefully!) won't miss it.

Changes since 1.10:

	- Now uses version 1.06 QuakeC files.
	- Fixed the quad damage bug (not the way I would have liked to
          have fixed it, but I don't have time to rebuild the entire
          Quake engine).


Well, barring the creation of a means to edit MDL files (rather than simply
creating new ones), the hook is pretty much finished.  Keep an eye out for
several new projects, including the Wraithverge, a force field, and a new
end level (with a MUCH better boss).

Even though you can now fix any bugs yourselves, I would still really
appreciate it if you would E-Mail any comments, suggestions, or bug reports
to:

        "Mike" <amichael@asu.alasu.edu>

After all, if nobody reports my mistakes, how am I supposed to avoid making
more mistakes in the future?


Special thanks to Hmmmm (who assisted me in my struggle against id's shipping
schedule, and who set up a 28.8k server to give me the chance to play with my
little hook in Deathmatch), ^danco (for his cool hook mesh, even though I
didn't use it... maybe for my Harpoon weapon add-on), and Railed (for his
help in getting Util 3d to work!).  
