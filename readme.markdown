Growl Current iTunes Track
=====

This is meant to be used with [FastScripts](http://www.red-sweater.com/fastscripts/). Assign it a comfy keyboard shortcut, go into the Growl prefs and assign it the "music video" notification theme, and you have a nice easy "Hey, what song is this?" button. 

You'd think this wouldn't be so hard to do, but none of the similar scripts I've seen around the internet seem able to stay up to date with the constantly breaking APIs, or else they do something braindead that I hate. So here's mine, it works with all the current constraints (iTunes stopped returning PICT data for artwork, Growl somehow forgot that image files exist???), and I'll keep it up to date. 

Caveats and Stuff
----

### Installation is Bullshit

Sorry. 

- You have to compile it. Open it in Applescript Editor, then export it as a .scpt file. Not a good way around this if I want to put it in Git, because .scpt is a weird-ass file format to begin with and it also needs the compiled resource fork extended attribute (anathema to Git) if you want it to feel fast. 
- It has to register with Growl as an application, but when I was testing this a few years back, leaving the registration event uncommented seemed to give me a permanent performance lag, and who has an extra 200ms or whatever to spare when they need to know what song is playing??? I mean JESUS. So you've gotta run it once with that line uncommented, then re-comment it and save. This might be fixable??? Pull requests welcome.
- Move it to your ~/Library/Scripts folder, OK, don't have a problem with this part, whatever.

### That Whole Thing With the Artwork

I realize that writing a temp file, shelling out to sips, then re-slurping the file probably isn't the best way to do this. That kind of grew up in three distinct stages in reaction to interface breakages, where each time I was trying to avoid having to actually build something. If anyone can find a way to get Image Events.app to work with data in memory instead of files, that would probably be a lot less stupid, but then again I wouldn't be surprised if it weren't.
