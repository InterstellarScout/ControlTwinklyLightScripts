# Overview
Twinkly lights are pretty, dude. They sparkle, and emanate stellar rainbow vortexes. I just wanna jump right in to see what other worlds aren't burning. In these times of glorious challenges and *relative* peacefulness (and let's keep it that way), we must remember that technology lets to do amazing things. What's one amazing thing? Lights. MMMmmm. Crisp and vibrant effects to occationally admire. Twinkly makes really pretty lights so I can float in peace vibes.
But Twinkly... one tiny teetensy witte problem....

*Leans in, beaconing Twinkly* Dear Twinkly devs, come on. Dudes... My dudes, please. I need an API for these thing. Please? Any excuse to put on some fat is a good one. I have been working all day and just want to press a button and BAM, EFFECT! Maybe even a Streamdeck app? Now I'm asking for too much, so let's just start simple. An API. Just a login? Look, I'm only a little desperate for more conveniences in my life, so a simple API through you would just make me sooooo happy. If I google search "Twinkly API" and find a forum saying "We don't have one," implying others do, I get sad. We don't like sad. Ideally I just find it, I want to feel nothing. Just nothing. An easy path to a button press of dopamine is all I'm asking for. A simple API. Pretty please? Then at a push of a button, I can breathe centering breaths and pretend that this is fine. 
Just "Choose from effects on deviceX" and BAM. 
Imagine that.
Imagine being a gamer, then tapping a button.
BAM
Rainbow Vortex. 
WEEEEEE!!!
Another button.
BAM
FIRE BACKDROPPP! 
RAWRRRRR!!!
Another button.
Total Darkness.
....
*whispers* I Love you. You're doing great. Thanks for making my life brighter <3

IN THE MEAN TIME. SOLUTIONS!
Well, I efforted because I'm a lazy bastard. I don't want to "Open my phone" and "Open app" and "Devices tab" and "Select device" and "Design Tab" and "Slide over to Favorites" and "Select Favorites" and "Select RainbowVortex" and multiply that times 3, and then notice that it's been 2 minutes, thus thwarting any satisfaction.

# Actual Overview
Control Your Twinkly over your network with the light's REST API. Runs in Powershell 5.2 and 7. To help with testing, this repository supplies some Postman sample requests.
To get started, see General Instructions.


## Is there any security?
ROTFLOL
Is there security?
Haha
You're funny. You think? LOL.
Actually?!? HAHAHAHA
Who tf can afford that? LOLOLOLOLOL.
No.
But Twinkly...
*Leans in, beaconing Twinkly* Dear Twinkly... 

In the Twinkly Lighting.postman_collection.json file you will find a random challenge ("aaaaaa...") and challenge body ("AAECAwQ..."). It's required and literally doesn't matter (in the same format), and it can be the same every time. 
It's as if Twinkly (the devs) wanted to make an attempt at security... maybe make an API some day, maybe? One that customers can use against their accounts? 

*Whispers sharply through Teams, bothering the Twinkly Devs. Only got kicked out twice probably.* 
Dudes
Make a subscription for all I care. My (censored) is already (censored) money all over those CEO's golden toilets. They are winning for themselves, not humanity. And people wonder why people don't want kinds? Mammals don't reproduce in danger. We must become secure in our present and very near future.
Ite?
JOLLY GOOD GAME!

# Versions
## V1 - Working 
Powershell Scripts work. 
## V2 - Experimental
Is a work in progress. Probably doesn't work. Will it ever work? Idk. Maybe? Probably? Heck, maybe even tomorrow (very big doubt tho).

# Prerequisites
Powershell 7 for V2 scripts. Link to latest PowerShell Releases: [Link to PowerShell releases](https://github.com/PowerShell/PowerShell/releases)

# General Instructions
1. Save the scripts.
2. Modify the script IP addresses to each Twinkly light and have set the IP Addresses at the bottom of the script. 
	1. You can find the IP Address on the device page in the app.
3. Run the script. It will then login to the device, set the command, and then peace out. 
4. If you are playing an effect, modify the Script that says "RainbowVortex" or "Sparkly 0" and replace their respective phrase in the script to the name of the effect that you have uploaded to your device.
5. If you are playing a color, modify the Script that says color and set the RGB color you wish to display. 

# StreamDeck Desktop Instructions
1. Get the ScriptDeck Plugin: [Link](https://marketplace.elgato.com/product/windows-scriptdeck-857f01dd-8fd4-44d5-8ec7-67ac850b21d3)
2. Save the scripts.
3. Modify the script IP addresses to each Twinkly light (You can find this on the device in the app.)
4. If you are playing an effect, modify the Script that says "RainbowVortex" or "Sparkly 0" and replace their respective phrase in the script to the name of the effect that you have uploaded to your device.
5. For each button in the Stream Deck App, paste "Start Process" button, and then point it to the script.
6. Repeat for each script.

# Tips for making effects
1. Device 11 Character Name Limit: If your effect name is longer, use only the first 11 characters when referencing them in the scripts. For example, the name of Lava Sparkle in the device is "Lava Sparkl"
2. Choose effects widly: Currently you cannot delete effects that exist on device that were created before the latest effect. You must delete all the way back in time to remove it. 
3. Be careful with your device. Effects are device based and cannot be backed up nor used or edited across devices. (TWINKLY FIX THISS!!!!)


# Resources
This API documentation *mostly* works for these lights. [Link to XLED Docs](https://xled-docs.readthedocs.io/en/latest/rest_api.html#get-led-movie-config)


# To do eventually (or not) list
- V1 scripts aren't fast, and I'm pretty sure there's a way to start processes so they trigger all at once, but that's gonna take more effort. For each process being kicked off, I need to add the function, effectively moving all the above functions into the whole script.
	For each....
- A script to show you the movies installed on each. Also output information about them like name and type.
- Add a retry after all of them have ran for those that failed. 
- Make the colors accept command line input to take the rgb color values. 
- Make the effects accept command line input to take the effect names.
- Have scripts use a config file for IP Addresses and effects(?)
- Solve world hunger.
- Fix humanity's 100% cause of death? Death. (iow, invent immortality).
- Strive for -x5 a person's carbon footprint per day for every person. We must not let ourselves die out here. We must preserve.
- Be happy.






*Dabs*





