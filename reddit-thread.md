Skip to main content
[Release] 120Hz BOE OLED Refresh Rate Enabler (SDC testing needed, also enables 70Hz for LCD) : r/SteamDeck


r/SteamDeck
Current search is within r/SteamDeck

Remove r/SteamDeck filter and expand search to all of Reddit
Search in r/SteamDeck
Advertise on Reddit

Open chat
Create
Create post
Open inbox
1

User Avatar
Expand user menu
Skip to NavigationSkip to Right Sidebar

Back
r/SteamDeck icon
Go to SteamDeck
r/SteamDeck
•
2y ago
Nyaaori

[Release] 120Hz BOE OLED Refresh Rate Enabler (SDC testing needed, also enables 70Hz for LCD)
Configuration
Sorry, this post has been removed by the moderators of r/SteamDeck.

Upvote
302

Downvote

220
Go to comments

Share
u/microsoft365 avatar
microsoft365
•
Promoted

Data analysis can feel like finding a needle in a haystack. Microsoft 365 Copilot Chat helps you find key insights fast.
Learn More
m365copilot.com
Thumbnail image: Data analysis can feel like finding a needle in a haystack. Microsoft 365 Copilot Chat helps you find key insights fast.
Join the conversation
Sort by:

Best

Search Comments
Expand comment search
Comments Section
Nyaaori
OP
•
2y ago
It took me about 6-8 hours of manual tuning and testing of display timings to get these values for BOE panels, be sure to let me know if you run into any problems on BOE panels.

Also let me know how well things work out on SDC panels, especially if any damage is caused so that I can put up a warning not to use it on SDC panel decks.

Observed issues: Gamma/Brightness curves vary depending on refresh rate.



Upvote
82

Downvote

Reply

Share

u/NoelleTGS avatar
NoelleTGS
•
2y ago
Oh shit, I didn't even realize it was possible to overclock these displays that far. Nice work



Upvote
27

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
OLED panels tend to have quite wide tolerances

For LCD panels, TN panels often do too, while IPS panels tend to be quite limited.

The limits I have reached on my steam deck seem to be limits of Valve's MIPI->eDP converter and not of the panel itself



Upvote
30

Downvote

Reply

Share

u/NoelleTGS avatar
NoelleTGS
•
2y ago
Do you know if there's any risk of damage by using this? I'd be willing to test my OLED Samsung screen if not



Upvote
11

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
Running any hardware out of factory specification always carries potential risk of damage, though for displays, risk of permanent damage from a short term signal test is generally quite low, but not impossible.

Factory specifications can also be wrong and say a piece of hardware is good for conditions it is not, but in those cases it becomes the responsibility of the manufacturer to replace if premature failure happens.

If you're particularly worried, it may be wise to wait until someone at least performs a "smoke test" to see if any immediate problems occur that stick even after returning back to 90hz.

Bigger potential for damage is running out of spec for extended periods of time, which would also need testing.

If, for example, operating at 120hz rather than 90hz reduces expected panel lifespan from 10 years to 8 years, most will likely not care too much in comparison to the improvement in experience provided by doing so, but if it reduces it from 5 years to 1 year, it would be a larger concern for most.



Upvote
42

Downvote

Reply

Share

u/NUKE---THE---WHALES avatar
NUKE---THE---WHALES
•
2y ago
•
Edited 2y ago
Is the panel rated for 90Hz and you're overclocking it to 120Hz?

Or the panel is rated for 120Hz and Valve is underclocking it?



Upvote
5

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
Going by Valve's comments in the code I changed, it looks like it's specified for 45, 48, 51, 55, 60, 65, 72, 80, and 90hz with all other values being out-of-spec.

If requested I could make a version that only contains my values for up to 90hz, allowing using refresh rate settings valve did not include in their settings.



Upvote
10

Downvote

Reply

Share

u/NUKE---THE---WHALES avatar
NUKE---THE---WHALES
•
2y ago
is there some kind of model id for the panel? i'd like to see the datasheet for it if it exists

also i didn't even know you could overclock displays into higher framerates, that's cool. fair play to you for the code


Upvote
4

Downvote

Reply

Share

u/Acceptable_Special_8 avatar
Acceptable_Special_8
•
2y ago
would you be so nice to compile a version with only the missing hz steps included? Have a Samsung Deck at hand, if you like me to do some testing ;)



Upvote
2

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
I intend on removing even values above 90hz from next release in order to prevent SteamOS from doubling lower values into gamma/colour banding ranges.

From what I have heard about Samsung panel decks so far, I am pretty sure I would need to have physical access to one for a while in order to find compatible timings, given that calculating them alone does not seem to work well.



Upvote
1

Downvote

Reply

Share

u/Acceptable_Special_8 avatar
Acceptable_Special_8
•
2y ago
Yeah, i tried 70hz for a 35fps cap in a demanding game and the gamma was unusable on my samsung panel. Thanks for your work, enjoy the Holidays;)


Upvote
2

Downvote

Reply

Share

More replies

1 more reply
u/aintgotnoclue117 avatar
aintgotnoclue117
•
2y ago
•
Edited 2y ago
Is the AW34DWF able to be overclocked in that way too, then? If that's a question you could answer, anyway.



Upvote
1

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
If you're running SteamOS you can enable controlling external display refresh rates and set STEAM_DISPLAY_REFRESH_LIMITS, ie STEAM_DISPLAY_REFRESH_LIMITS=low,high or STEAM_DISPLAY_REFRESH_LIMITS=30,175 to enable selecting from 30 to 175 within QAM

But aside from all that, most displays can be run at rates at least slightly higher than stock, you could get a 60hz panel that will let you run at only up to 65hz but you could also get a 60hz panel that runs fine at over 200hz.


Upvote
2

Downvote

Reply

Share

WeebBrandon
•
2y ago
Oh my god the real Honoka Kousaka



Upvote
3

Downvote

Reply

Share

u/NoelleTGS avatar
NoelleTGS
•
2y ago
Truth :3


Upvote
3

Downvote

Reply

Share


2 more replies
iReaddit-KRTORR
•
2y ago
Ah awesome! I saw your other post and I think given everything, capping at 120hz seemed to make sense from a stability standpoint.

Does this mod also enable/play with VRR? YOU ARE AWESOME!!



Upvote
10

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
No VRR yet, I would very likely need to modify kernel drivers to do that, for now it only extends refresh rate options, including filling in those that were missing from stock range [46, 52, 54, 57, 58, 61, 63, 67, 69, 70, 71, 74, 75, 79, 83, and 89Hz]

After hours of manually tuning timings, I'm also starting to think that while VRR might be possible for BOE OLED panel decks to display, it may be quite a poor experience, potentially full of brightness/gamma flickering problems.

Hopefully SDC panels are more promising on that front.

It's looking like BOE panels can clock to higher frequencies [~130-134hz maximum], but SDC panels [with their apparent ~98-102hz maximum] may or may not be able to do VRR smoothly, I would need to have one to do testing against to see how promising it would be.



Upvote
21

Downvote

Reply

Share

u/LippyBumblebutt avatar
LippyBumblebutt
•
2y ago
Valve said, VRR is impossible due to the MIPI connection. Do you think this is a problem?



Upvote
9

Downvote

Reply

Share

UnknownInventor
•
2y ago
They explained in a previous post that the vrr extensions may not work with mipi but the underlying functionality could still be added by messing with the blanking interval. As technically old CRT VGA monitors support VRR even though they were built significantly before GSync or FreeSync ever came out.



Upvote
16

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
VRR extensions, to my knowledge, are just a way for a display to let your GPU know when it supports VRR or not. VRR itself does not do anything new that has not been part of display signal timing for nearly 50 years now.

Enabling VRR on deck would involve hard-enabling support for it when a known working panel is detected, but other than that, should work fine on any panel that supports it. An alternative method, and what I would likely do, would be adding a driver parameter to force enable it on a given port even if no support was detected.


Upvote
6

Downvote

Reply

Share

iReaddit-KRTORR
•
2y ago
Ah understood. Looking forward to seeing how this may or may not affect displays long term.


Upvote
3

Downvote

Reply

Share

u/Prize_Negotiation66 avatar
Prize_Negotiation66
•
2y ago
Your stupid site is down



Upvote
1

Downvote

Reply

Share

u/SteamDeck-ModTeam avatar
SteamDeck-ModTeam
MOD
•
2y ago
•
emoji:deck_logo: Mod Team
Your post or comment was removed because it was deemed either unkind/toxic/harassing/insulting/offensive/trolling and/or inappropriate thereby breaking Rule #1 of r/steamdeck. We want this sub to feel welcoming to anyone and everyone who comes here. Discussion and debate are encouraged but name-calling, harassment, being rude to others, generally toxic behavior, and slurs will not be tolerated.

This rule violation has resulted in removal of your content, and could result in a ban from the sub and/or a report to Reddit.

Bottom line - Be kind or get yeeted.

Thank you!


Upvote
1

Downvote

Share

u/Prize_Negotiation66 avatar
Prize_Negotiation66
•
2y ago
Your great site is down


Upvote
2

Downvote

Reply

Share


1 more reply
u/Thesterx avatar
Thesterx
•
2y ago
someone remind me when Samsung panel is tested



Upvote
60

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
There was a comment replying here saying something like "I wouldn't touch this until steam officially enables it" and I had typed out a response only to get a message saying that comment was deleted when I went to actually post my response, so here's that response anyway.

I mean, aside from that being very unlikely, it would be quite silly to think Valve would enable an overclock by default :p

They might fill in those missing refresh rate options though, somewhat hoping someone from Valve contacts me to help with that so I could contribute a pgp-signed commit into gamescope's repository.

Regardless, anyone is free to inspect what changes I have made and/or compile things for themselves, https://git.spec.cat/Nyaaori/gamescope/commit/d39000aa9f53d1bd3c6fa993fdaeb6cc99ad4ae0

Hard part was manually tuning and testing timings for BOE panels over several hours, code part only took like 5-10 minutes.


Upvote
34

Downvote

Reply

Share


[deleted]
u/TheAcaciaBoat avatar
TheAcaciaBoat
•
2y ago
Does not work on Samsung oled, everything becomes completely garbled at 100hz (first I’ve tried). Any way to uninstall it? Thanks!



Upvote
20

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
Could you see at what threshold that happens? 99 or 98 might work.

Aside from that, either switch steamos branch so it updates and overwrites it, or disable read-only, move /usr/bin/gamescope.orig back to /usr/bin/gamescope, then re-enable read-only mode.



Upvote
15

Downvote

Reply

Share

Upper-Dark7295
•
2y ago
•
Edited 2y ago
64GB - Q3
You should probably note that if he can't see his screen at all (which happened to me when I set my LCD to a global 20Hz 6 months ago, could never see anything upon boot), that that solution doesn't work easily. He needs to get a steamOS recovery image, boot into that, then you're able to use the dolphin file explorer to move that file since you can actually see the screen. Docking it should work too



Upvote
3

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
In this case, worst case you can just hold Steam+B to kill the current open game, or reboot, given steamui always renders at display native and I do not change that at all with my modifications.


Upvote
4

Downvote

Reply

Share

u/McSetty avatar
McSetty
•
2y ago
Does it impact external displays as well?



Upvote
3

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
It should not impact external displays unless set in a really bizarre way.



Upvote
3

Downvote

Reply

Share

u/McSetty avatar
McSetty
•
2y ago
Thanks I assumed as much, I was alluding to the fact that connecting an external display seems like a decent recovery path instead of a complete OS reinstall. SSH would be a good option as well, but it's probably far less likely they have SSHD enabled.



Upvote
4

Downvote

Reply

Share

Upper-Dark7295
•
2y ago
64GB - Q3
I should note that when I mentioned the recovery image, you don't actually need to reinstall the OS, you just use the recovery image as a way to see your screen and use the file explorer



Upvote
3

Downvote

Reply

Share

u/McSetty avatar
McSetty
•
2y ago
gotcha thanks


Upvote
2

Downvote

Reply

Share


1 more reply

3 more replies
u/TemporalTechnologies avatar
u/TemporalTechnologies
•
Promoted

Run a 2 min check to spot the brittle paths before on call wakes you.
Learn More
pages.temporal.io
Thumbnail image: Run a 2 min check to spot the brittle paths before on call wakes you.
wedditasap
•
2y ago
All of a sudden people now clamor BOE as the superior panel, lmao



Upvote
16

Downvote

Reply

Share

[deleted]
•
2y ago
All because a few highly upvoted posts had dead pixels lmao.


Upvote
4

Downvote

Reply

Share


1 more reply
[deleted]
•
2y ago
Why lower limit is 40fps/hz when you can go to 30fps/30hz ?



Upvote
14

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
While the LCD panel steam deck can do down to ~28hz, the BOE OLED panel steam deck can not do so.

Aside from that... It would not really make sense to extend it down past 36 because...

30x2=60, 31x2=62, 32x2=64, 33x2=66, 34x2=68, and 35x2=70

For OLED decks, going below 45 does not make much sense on stock either because 90/2=45, and when extended to 120hz the unified limiter will not pick values below 61hz as 60x2=120


Upvote
23

Downvote

Reply

Share

580083351
•
2y ago
Speaking of my external LCD monitor, it's an old one now. What I have observed about it is that even though it will accept and display higher refresh rates, it is actually dropping frames.

Not saying that is happening here, but further testing is required to confirm that frames are not being dropped.



Upvote
16

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
In the case of embedded displays rather than external, dropping happens to be quite rare due to having increased directness of control of a panel. I have already confirmed that no dropping occurs on either my BOE OLED or LCD decks, but no clue about SDC OLED decks.

In external displays, there can be additional processing happening between receiving a signal and displaying an image, that would be where frame dropping most commonly occurs.


Upvote
21

Downvote

Reply

Share

ihave3apples
•
2y ago
I'm going to be real salty if it turns out that only the BOE panel on the LE deck is the one that can do 120hz, which of course sold out officially this morning...



Upvote
12

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
I do not have a deck with a Samsung panel currently so unfortunately I can not perform manual timing tuning like I was able to do with a BOE panel deck (which was quite annoying to get given they only shipped LE ones to US&Canada, luckily I had access to an old secondary steam account and could order from that, got kinda worried with shipping but despite the box being a bit wet given it was left out in the rain briefly, everything turned out okay)

If I do end up receiving enough donations to buy a second OLED deck than I intend on ordering one so that I can hand-tune Samsung panel timings. Without one though, it looks like SDC decks will be limited to ~98hz for now.

I will likely update my code to handle SDC and BOE decks separately to avoid enabling modes SDC decks can not function at.


Upvote
6

Downvote

Reply

Share

u/JFrogPlatform avatar
u/JFrogPlatform
•
Promoted

One platform for CI/CD, security, release automation. Enterprise-grade. Learn More.
Learn More
jfrog.com
Thumbnail image: One platform for CI/CD, security, release automation. Enterprise-grade. Learn More.
Effective-Amount310
•
2y ago
So how do I know if my LE has a boe?



Upvote
6

Downvote

Reply

Share


[deleted]
•
2y ago
Nyaaori
OP
•
2y ago
From everything I have heard, all LE decks have BOE panels. That being said, if you run xrandr --verbose | grep MHz from desktop mode and the first [or only] value you see is close or equal to 102.00MHz you have a BOE panel but if you see a value close or equal to 133.20MHz you have an SDC panel



Upvote
15

Downvote

Reply

Share

u/LippyBumblebutt avatar
LippyBumblebutt
•
2y ago
Aren't those numbers backwards? On your git you state "BOE limit ~133Hz, SDC Bandwidth Limit ~100Hz" With the Deck resolution at ~1Mpix, that should be about the same in MHz?



Upvote
4

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
SDC at 90Hz uses ~133MHz of bandwidth while BOE at 90Hz uses ~102MHz of bandwidth; Valve's MIPI converter seems to begin struggling at roughly ~147-148MHz which is where those numbers come from.

I do not know if SDC can be made to use narrower timings to reduce bandwidth usage or not, and given I currently only have a BOE deck I can not currently test for that.



Upvote
7

Downvote

Reply

Share

lonewolf7002
•
2y ago
Since I don't know a whole lot about timing signals, if the BOE is using less bandwidth, does it somehow have a lesser picture quality? If the quality is the same, why would the SDC panel require more bandwidth to display the exact same picture?


Upvote
2

Downvote

Reply

Share


3 more replies

1 more reply
luv1290
•
2y ago
109HZ seems to be the spot where the colors/gamma dont get shot up. Anything past that it gets brighter and you lose color.


Upvote
5

Downvote

Reply

Share

u/AAGaming00 avatar
AAGaming00
•
2y ago
512GB - Q2
this can be done without a steamos-readonly disable (and the breakage that often causes), i have a decky plugin to do so that i'll be releasing soon once it's updated to handle the OLED



Upvote
5

Downvote

Reply

Share

u/AAGaming00 avatar
AAGaming00
•
2y ago
512GB - Q2
hm wait looking at the gamescope changes maybe not, didn't know they hardcoded VFP

it's still possible to run a custom gamescope without unlocking readonly though

very weird



Upvote
4

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
Doing so with file replacement happens to be significantly easier and takes less time, I could do so without that but things would have taken several additional hours of work to handle doing that.


Upvote
1

Downvote

Reply

Share

u/Long_Candle_9050 avatar
Long_Candle_9050
•
2y ago
hello when i enable 120 hz with a BOE panel the contrast gets boosted very high and looks washed out.


How do I uninstall this script to be safe ? Thanks - Hank



Upvote
4

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
On OLED panels, gamma curves relate directly to how long pixels are driven, so when you increase refresh rate you end up with reduced resolution in darker colours.

I left removal instructions in another comment here, but if you do not use the higher values than your panel will not be driven at those higher values. Gamma curves being off should not in of itself cause issues for the display.


Upvote
5

Downvote

Reply

Share

luv1290
•
2y ago
Been using this for a few hours now; 109hz seems like the sweet spot. In the future is it possible to correct the colors with the 120hz mode or is that just a negative side effect of pushing the panel past 90hz.


Upvote
4

Downvote

Reply

Share


3 more replies
hoowahman
•
2y ago
Worked great for me. Ran art of rally at 120. It was at low settings but it all appeared to run well.


Upvote
3

Downvote

Reply

Share

u/LoafyLemon avatar
LoafyLemon
•
2y ago
256GB
Any possibility for you to upload source code for the modified version of game scope? I also notice the license is missing.



Upvote
3

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
I already linked my changes in another comment here :p

There's not a whole lot of code changes, primarily adding logic for handling setting clock rates in addition to vfp rates, things were mostly manual display tuning.


Upvote
2

Downvote

Reply

Share


[deleted]
•
2y ago

Mast3rBait3rPro
•
2y ago
512GB - Q3
WuZiKK
•
2y ago
When i try to install it, terminal days there's no such file or directory. What have i missed?


Upvote
2

Downvote

Reply

Share


2 more replies
u/Fadi5555 avatar
Fadi5555
•
2y ago
Can you make 30fps with 30hz without flickering? It would be amazing


Upvote
2

Downvote

Reply

Share

ThatDistantStar
•
2y ago
The BOE panel can just overclock further, it doesn't have any other advantages at stock refresh rates?


Upvote
2

Downvote

Reply

Share


1 more reply
[deleted]
•
2y ago
Kudos, this is going to brick so many deck screens!


Upvote
2

Downvote

Reply

Share

u/MikeWazowski215 avatar
MikeWazowski215
•
2y ago
I love this community 🫡


Upvote
2

Downvote

Reply

Share

u/Reteurg avatar
Reteurg
•
2y ago
My SDC Panel starts flickering above 96hz. Unfortunately the image quality gets increasingly more pixelated between 91and 95hz. Is this expected? So I guess I'll stay at 90hz for now but mad respect for your work. Hope you can get your hands on an SDC Panel to tweak the settings accordingly. Keep it up!



Upvote
2

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
Thanks, I will be releasing a new version soon with an experimental alternative method of adjusting refresh rate on SDC panels, and removing even values over 99hz so that 50-60hz do not have gamma problems.


Upvote
2

Downvote

Reply

Share

u/KarateMan749 avatar
KarateMan749
•
2y ago
512GB - After Q2
your link is down


Upvote
2

Downvote

Reply

Share


5 more replies
Wise_Fox_8317
•
2y ago
Where can I find the website to this I tried clicking link 🫡


Upvote
2

Downvote

Reply

Share

WRXSTIL1KE
•
2y ago
Where did all the information and Git page go? All the links lead to a DNS server issue. Did something happened? I was using this software and was very happy with it. Please bring it back. 


Upvote
2

Downvote

Reply

Share


2 more replies
Octave1904
•
2y ago
Is it safe for the steam deck LCD ?



Upvote
2

Downvote

Reply

Share

Gamer_Paul
•
2y ago
I've had mine allowing 70hz for the longest time. No issues so far. It's not like I run it at 70hz for everything, but I definitely use it when appropriate (light weight games that aren't emulation).


Upvote
3

Downvote

Reply

Share


1 more reply
YouOnly-LiveOnce
•
2y ago
1TB OLED Limited Edition
Just out of curiosity long as you don't push frame limiter up it won't push monitor harder yeah?

Looking forward to anything VRR related would be absolutely huge if its possible



Upvote
2

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
I did change how 90Hz mode works slightly [I manually tuned all 80 modes from 40hz to 120Hz] so using this will push BOE OLED panel controllers slightly more at 90hz than stock would, but it should still be well within expected panel tolerances. I would not expect any harm to come from that.

Modes that will drive BOE panels at rates higher than stock: 46-48, 50, 53-54, 58, 60-63, 65-64, 68-69, 75-79, 82-83, 86, 89-120

All other modes will drive BOE panels at rates lower than stock.

For SDC, all modes from 45 through 90 will drive panel at stock rate, for 40-44 they'll be lower than stock, 91-120 will be higher than stock.

For LCD decks, only 61-70 would push panel harder, but there's very little risk comparatively there, especially given many, including myself, have run LCD decks at 70hz for extended periods without issue.


Upvote
3

Downvote

Reply

Share

u/ttdpaco avatar
ttdpaco
•
2y ago
So, it works pretty well as far as the refresh rate is concerned.


But woo lord, it shifts the gamma entirely too much for me. But so far, it's pretty awesome for messing with things - thank you!



Upvote
1

Downvote

Reply

Share

luv1290
•
2y ago
Change it to 109hz; colors go back to normal


Upvote
2

Downvote

Reply

Share


4 more replies
AnchoraSalutis
•
2y ago
I keep getting "no such file or directory" am certain it's input correctly



Upvote
1

Downvote

Reply

Share

Mervium
•
2y ago
1TB OLED Limited Edition
open konsole from the file the script is in



Upvote
2

Downvote

Reply

Share

AnchoraSalutis
•
2y ago
Thanks! Up and running now (and slowly getting the hang on linux)


Upvote
2

Downvote

Reply

Share


1 more reply

[deleted]
•
2y ago
ZeroRains
•
2y ago
Is there anything or any plans that could address the color banding issues by raising up to 120hz?


Upvote
1

Downvote

Reply

Share


1 more reply
u/Mkilbride avatar
Mkilbride
•
2y ago
So, 16 days later how is this>?


Upvote
1

Downvote

Reply

Share


1 more reply
Grand-Produce-3455
•
2y ago
sites down


Upvote
1

Downvote

Reply

Share

TheHybred
•
2y ago
512GB - Q1
Not sure why people care that much about 120hz, 90hz is where you begin to get that "high refesh rate" feel and look, and on an analog stick it's even more convincing. So I'd be more than happy to stick at 90hz/fps and save battery than to push it furhter for something hardly noticable



Upvote
0

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
I have noticed quite a large difference between 90 and 120hz on my deck, happens to be particularly noticeable within 2D rhythm games, most of which already get 8+ hours of battery life regardless.


Upvote
7

Downvote

Reply

Share

gangstazn24
•
2y ago
another way to get dead pixels on ur BOE lol



Upvote
-1

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
In certain circumstances, running displays at higher refresh rates can actually cause stuck pixels to become unstuck. Depends on why a pixel got stuck to begin with but that is something known to happen.


Upvote
8

Downvote

Reply

Share

ZeroRains
•
2y ago
Can you please post the uninstall script? You mentioned you posted it here but can't find it anywhere



Upvote
0

Downvote

Reply

Share

u/standaloneinstaller avatar
standaloneinstaller
•
2y ago
https://old.reddit.com/r/SteamDeck/comments/185qpx5/release_120hz_boe_oled_refresh_rate_enabler_sdc/kb3n61r/


Upvote
1

Downvote

Reply

Share


6 more replies

Mervium
•
2y ago
1TB OLED Limited Edition

Khalmoon
•
2y ago
1TB OLED

GrailQuestPops
•
2y ago
LCD-4-LIFE
tiandrad
•
2y ago
512GB OLED
You have my curiosity, figure out vrr and then you will have my attention.


Upvote
1

Downvote

Reply

Share

oderlydischarge
•
2y ago
Are there alot of games that actually can take advantage of the enhanced refresh rate? or is it pretty much limited to indie/8bit like games/side scrollers?



Upvote
1

Downvote

Reply

Share

Wise_Fox_8317
•
2y ago
Some of the well optimized games can do it as well fairly certain Doom 2016 and Hifi Rush can. That new Jet set radio can what is it called cyberfunk. Also some older games even at stock Shadow of War plays at 90 given the opportunity I think it may run higher. Most of the Re engine remake games likely can as well. Lot of cool possibilities


Upvote
1

Downvote

Reply

Share


3 more replies
Oo_Toyo_oO
•
2y ago
W


Upvote
1

Downvote

Reply

Share

AsrielSelix
•
2y ago
I ran this on my boe and seems successful! Only downside is that the home screen seems to be stuck at 90hz so whenever I leave or exit a game it does the 1 sec black screen. Do you think this can be fixed? I'd even be fine locking home screen at 60 so this doesn't happen somehow



Upvote
1

Downvote

Reply

Share

Nyaaori
OP
•
2y ago
Changing steamui rate requires overriding display EDID, I have an unreleased script for doing that too but it can be an easy way to get your deck into a state requiring a recovery image to fix.


Upvote
2

Downvote

Reply

Share

u/KarateMan749 avatar
KarateMan749
•
2y ago
512GB - After Q2
I was trying to find this yesterday. 😅. I hope i remember tonight


Upvote
1

Downvote

Reply

Share

cwills75
•
2y ago
Great job with this mod. As Valve has broken Vibrant Deck with recent built in updates, is there any way to globally offset the raised gamma in gaming mode?


Upvote
1

Downvote

Reply

Share

Mysterious-Return-98
•
2y ago
when I try to run the program It saysno such file or directory and the file laying in the download please help



Upvote
1

Downvote

Reply

Share

u/KillerIsJed avatar
KillerIsJed
•
2y ago
You have to change the directory to wherever you downloaded the file.

You can use “dir” to see a list of files/directories. Then do “cd directory” to go there, then run the script.

I downloaded it to my Desktop so: Cd Desktop Then run the command to start it as directed on the link.


Upvote
1

Downvote

Reply

Share


[deleted]
•
2y ago
ZeroRains
•
2y ago
Let us know when the next release is out! Thank you for all your hard work! Also would you consider adding a uninstall script for ease of testing?


Upvote
1

Downvote

Reply

Share

i_max2k2
•
2y ago
1TB OLED Limited Edition
I’m seeing some black clipping on 120hz, I was wondering if there was any way to remove the mod, without restoring the system?



Upvote
1

Downvote

Reply

Share

i_max2k2
•
2y ago
1TB OLED Limited Edition
I saw the script and glad you back up the original file, all we have to do is replace that with the original and that should do it? I’ll create an uninstall script and share it with you.


Upvote
1

Downvote

Reply

Share


2 more replies
[deleted]
•
2y ago
I've used it and in most games the brightness and colors are horrible (not to discourage you, but I think it needs more work). Are you able to resolve this issue? I'm on the Limited Edition OLED model too.


Upvote
1

Downvote

Reply

Share

u/Closetojesus avatar
Closetojesus
•
2y ago
I hope you find even more success in this endeavor, i have a Samsung screen so i think i will just live with my 90hz and i can always replace the screen in the future, or you could find a better panel to install and endorse for the community, maybe even get a deal with coding a panel for the steam deck with a supplier if you push their product


Upvote
1

Downvote

Reply

Share

WRXSTIL1KE
•
2y ago
Where can I redownload this? I’ve been using it for about a month and I love it. Sadly I had to do a Steam Deck Re-image and now I’m stuck at 90Hz. I would love to reinstall it.  



Upvote
1

Downvote

Reply

Share

u/Early-Bat-4870 avatar
Early-Bat-4870
•
2y ago
Is this no longer working? i Get...

gamescope: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
Download corrupt or invalid? Please try again...

It used to work but I thinkl valve patches this script out with steamos updates


Upvote
1

Downvote

Reply

Share


1 more reply
Nyaaori
OP
•
2mo ago
I've been really busy for a while now, but intend on updating this for SteamOS 3.8 after valve gets around to releasing, there have been a few changes in the OS that should make things much easier to do.


Upvote
1

Downvote

Reply

Share

u/dontuseliqui avatar
dontuseliqui
•
2y ago
Can someone share the tool - the link has been broken for a while. Thanks


Upvote
1

Downvote

Reply

Share

Wise_Fox_8317
•
2y ago
Any luck on this 😩link still not working is it permanently cooked or did they migrate to a different site



Upvote
1

Downvote

Reply

Share

u/Iurigrang avatar
Iurigrang
•
2y ago
This article links to a mirror of the download
https://steamdeckexplained.com/overclock-steam-deck-display-120hz/


Upvote
3

Downvote

Reply

Share


5 more replies
u/dontuseliqui avatar
dontuseliqui
•
2y ago
Can you share the script? The server has been down for a while


Upvote
1

Downvote

Reply

Share

u/Iurigrang avatar
Iurigrang
•
2y ago
Is this link broken? where can I find this?


Upvote
1

Downvote

Reply

Share

u/EVPointMaster avatar
EVPointMaster
•
1y ago
Anyone with an OLED Samsung panel that can report what refresh rates they can achieve?

TradlyGent
•
10mo ago
Does this work for anyone in latest steam version? It appears that I just get black screen and exit on every game I try in Gaming Mode. I have a deck oled LE BOE.


Nyaaori
OP
•
2mo ago
Been quite busy recently but I'm intending on updating things after SteamOS 3.8 comes out, Valve made some internal changes that should make patches like this much easier to maintain and install.


1 more reply
[deleted]
•
10mo ago
same here, just tried on my SDC deck


5 more replies
[deleted]
•
10mo ago
I own a 512gb steam deck oled SDC panel. I was playing around with the mod on latest firmware and updates, I can report no noticable visual artifatcs: everything was fine visually speaking. I can report some stability issues, the deck seems to be a bit unstable, and one big problem that makes no sense to me: games won't boot in gaming mode but will in desktop mode. Unfortunately for this reason I find my self forced to uninstall this mod, a bit sad...


Nyaaori
OP
•
2mo ago
I'll to get an update out after SteamOS 3.8 releases, Valve made changes that make modifications like this significantly easier to do and it looks like they'll be present in 3.8

Community Info Section
r/SteamDeck
deck_logo_black
Joined
Steam Deck
The Unofficial Subreddit for the Valve Steam Deck! Find discussions, games running on Deck, hardware / software mods and much more! Please read the rules, check for megathreads and search before posting! Check out the community bookmarks for useful links!

Show more
Created Jul 15, 2021
Public

Community Guide
1.3M
Weekly visitors
28K
Weekly contributions
User flair
u/supershredderdan avatar
supershredderdan
Developer
community achievements
Top 1% Poster
Top 1% Commenter
Repeat Contributor
Top 1% Poster, 
Top 1% Commenter, 
Repeat Contributor, 
+3 more
6 unlocked

View All
Community Bookmarks
Official Resources

Unofficial Guides
Games Great On Deck
Top Played Games
ProtonDB
r/SteamDeck Rules
1
Be Kind Or Get Banned
2
Posts must be about or related to the Steam Deck
3
Generic / New Steam Deck Pictures Limited To "Show Off Saturday" (GMT Timezone)
4
"Game Review On Deck" Posts Must Include Game In The Title And Steam Deck Experience
5
Requirements For "Accessory Review", "Setup" and "Hardware / Software Modding" Posts
6
“What Are You Playing?” Limited To Weekly Megathread And "Looking For Games" Post Requirements
7
Giveaways, Begging, Buying, Selling, Trading And Crowdfunding Posts Are Not Allowed
8
Avoid Overly Repetitive Content (eg. Steam Deck purchase and shipping questions)
9
No links/discussion of illegal, copyrighted or pirated content
10
Provide Context in Help Requests
11
No impersonation, claiming to have "insider knowledge", or posting intentional misinformation
12
Promotional Rules for Developers, Content Creators, and Manufacturers
13
Do not attempt to obfuscate your submission to bypass filtering
14
No Abusing the report button
Related communities
Steam Deck Specific
Technical Support and News:

r/steamdeckhq
r/DeckSupport
r/SteamDeckCheck
r/SteamDeckNews
General Discussion:

r/SteamDeck
r/ValveSteamDeck
r/SteamDeck_2
r/UnexpectedSteamDeck
r/BestOfSteamDeck
r/SteamDeckWins
Emulation and Software:

r/SteamDeckEmulation
r/SteamDeckYuzu
r/SteamDeckTricks
Mods and Customization:

r/SteamDeckMods
r/SteamDeckModded
r/SteamDeckPrints
r/SteamDeckTinker
Gaming and Applications:

r/SteamDeckGames
r/SteamDeckPirates
Video and Boot Customization:

r/SteamDeckBootVids
Linux and Operating Systems:

r/steamdeck_linux
r/SteamOS
r/HoloISO
r/WindowsOnDeck
r/linux4noobs
r/linuxmasterrace
Related Gaming Platforms and Deals
Valve and Steam Ecosystem:
r/Steam
r/Valve
r/SteamController
r/Steam_Link
r/SteamPlay
r/steamdeals
Other Competing Platforms
ROG Ally:
r/ROGAlly
Development Communities
Development
r/AMD
r/KDE
r/Gnome
r/Gentoo
r/gamedev
r/linux
r/linux_gaming
r/linux_gamedev
Moderators
Message Mods
u/sweatycat 
emoji:deck_logo: Moderator
u/House_of_Suns avatar
u/House_of_Suns 
emoji:deck_logo: Moderator
Blue Jays Fan
u/weebutt
u/babuloseo 
emoji:glados_icon: Very much a bot
u/NKkrisz 
64GB - Q3
u/BBQKITTY 
SteamDeckHQ
Noah - SteamDeckHQ
u/HighHoSilver99 
emoji:deck_logo: Moderator- 512GB
HighHoSilver
u/Servor avatar
u/Servor 
512GB
u/techbear72 avatar
u/techbear72 
256GB - Q4
u/Sylverstone14 
512GB - Q3
Sylverstone Khandr
View all moderators
Installed Apps
Modmail To Discord or Slack
Flair Scheduler
Reddit Rules
Privacy Policy
User Agreement
Accessibility
Reddit, Inc. © 2025. All rights reserved.

Collapse Navigation
