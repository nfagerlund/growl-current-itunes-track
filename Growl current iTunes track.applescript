-- The first time you run this script, you must uncomment the following line. After running it once, re-comment it forever. 

-- tell application "Growl" to register as application "iTunes Track Alert" all notifications {"Current Track"} default notifications {"Current Track"} icon of application "iTunes"

on get_image(imgPath)
	set imgfd to open for access POSIX file imgPath
	set img to read imgfd as "TIFF"
	close access imgfd
	return img
end get_image
-- RE: the above and the `sips` shenanigans below: Growl team broke using images from files, so we have to do this oververbose bullshit now. 
-- https://groups.google.com/forum/?fromgroups=#!topic/growldiscuss/AEjOOIH95KY
-- http://code.google.com/p/growl/issues/detail?id=541

tell application "iTunes"
	copy (a reference to (current track)) to atrack
	set trackName to name of atrack
	set trackArtist to artist of atrack
	set trackAlbum to album of atrack
	set trackRating to rating of atrack
	if artworks of atrack is not {} then
		set hasArtwork to true
		--the following used to work, but it broke when itunes switched from PICT data to JPEG data for artwork. :( And I can't even be positive it's always JPEG; it could be PNG sometimes, or they could keep changing it in the future.
		--set trackArtwork to the data of artwork 1 of atrack -- <- old style
		--anyway, instead we have to do this: 
		set trackArtwork to the raw data of artwork 1 of atrack
		tell me to set tmpfileref to (open for access "/tmp/growlitunesart" with write permission)
		tell application id "com.apple.iTunes" to write trackArtwork to tmpfileref starting at 0
		tell me to close access tmpfileref
		do shell script "sips --setProperty format tiff /tmp/growlitunesart"
		set tiffArtwork to my get_image("/tmp/growlitunesart")
		-- Anyway, the magic of sips means we're basically protected from future format change shenanigans. 
		-- although I HAVE NO IDEA why I have to say "my" in front of get_image. http://stackoverflow.com/questions/2767069/mail-cant-continue-for-a-applescript-function
		-- Ah ok:
		-- http://www.trismegistos.com/magicalletterpage/applescript/index.html
		-- "NOTE: Subroutines cannot be called from within a tell ... end tell unless, you use 'my'. 'My' tells Applescript that you want to execute an Applescript command proper and not a command from the application you are addressing"
	else
		set hasArtwork to false
	end if
end tell

tell application "Growl"
	if hasArtwork is true then
		notify with name "Current Track" title trackArtist & " – " & trackName description trackArtist & " – " & trackAlbum & " – " & trackName & " (" & (trackRating / 20 as integer) & "★)" application name "iTunes Track Alert" image tiffArtwork
	else
		notify with name "Current Track" title trackArtist & " – " & trackName description trackArtist & " – " & trackAlbum & " – " & trackName & " (" & (trackRating / 20 as integer) & "★)" application name "iTunes Track Alert"
	end if
	
end tell
