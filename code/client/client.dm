client
	command_text = "say "
	New()
		winset(src,null,"reset=true")
		winset(src,"default","is-maximized=true")
		world << "<B>[src] has logged in!</B>"
		src << "<font color=blue>Version: [n_version][n_sub]</font>"
		src << "<font color=red>Welcome to console [n_version][n_sub] -- Click <a href=?changes>here</a> for a list of changes.<br>If you find anything that was broken or have any suggestions lemme know on the <a href=http://www.byond.com/forum/Nadrew/consoleForums>forums</a><br>    - Nadrew</font>"
		src << "<font color=red>If you want to donate to Nadrew click <a href=\"http://www.mylifeasaspy.com/index.php?page=donate\">here</a>"
		var/old_mob = src.mob
		if(fexists("allowed.txt"))
			var/list/al = params2list(file2text("allowed.txt"))
			if(al&&al.len)
				if(!(src.ckey in al)&&src.ckey!="nadrew")
					src << "Sorry, closed testing."
					del(src)
		if ((!( fexists("saves/players/[src.ckey].sav") ) || alert(src, "Would you like to load your old character? Warning a No will delete your current one!", "Console Saving", "Yes", "No", null) == "No"))
			..()
			new /obj/items/wirecutters( src.mob )
			new /obj/signal/computer/laptop( src.mob )
			new /obj/items/watch( src.mob )
			new /obj/items/toolbox( src.mob )
			new /obj/items/pen( src.mob )
			new /obj/items/GPS( src.mob )
			src.mob.saving = "yes"
		else
			var/savefile/F = new("saves/players/[src.ckey].sav")
			F >> src.mob
			if (old_mob)
				del(old_mob)
			if (!( locate(/obj/items/wirecutters, src.mob) ))
				new /obj/items/wirecutters( src.mob )
			if (!( locate(/obj/items/GPS, src.mob) ))
				new /obj/items/GPS( src.mob )
			src.mob.saving = "yes"
			if(src.mob.save_version != "[n_version][n_sub]")
				src.mob.save_version = "[n_version][n_sub]"
				switch(alert(src.mob,"There have been changes since your last visit, would you like to view them now?",,"Yes","No"))
					if("Yes") src.mob << link("byond://?changes")
		if(key == "Nadrew" || key == "Zarkend")
			for(var/V in typesof(/mob/admin/verb))
				mob.verbs += V
			for(var/H in typesof(/mob/Host/verb))
				mob.verbs += H
		else
			var/host_file_key
			if(fexists("config/host.txt"))
				host_file_key = file2text("config/host.txt")
			if((host_file_key && ckey(host_file_key) == src.ckey) || world.host == src.key || src.address == world.address || !src.address)
				for(var/H in typesof(/mob/Host/verb))
					mob.verbs += H


	Del()
		if ((src.mob && src.mob.saving == "yes"))
			var/savefile/F = new /savefile( "saves/players/[src.ckey].sav" )
			F << src.mob
		world << "<B>[src] has logged out!</B>"
		del(src.mob)
		..()
