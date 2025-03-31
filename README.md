# About
Meteora was a tweak to bring back the iOS 9 lockscreen to iOS 10. This is my fork which intended to add notifications support.
This tweak was mainly created by iKilledAppl3 and Skittyblock but was never fully finished.
On iOS 10, the old Lockscreen is not completely removed from SpringBoard. See the section "Why doesn't certain things work" below. This is what makes this tweak possible.

Note: I have never developed jailbreak tweaks before. I tried my best to use best practices but so much of jailbreak tweak dev involves a lot of tribal knowledge not well documented online. Feel free to fork this repo and complete what I started if you wish.

# Known Bugs
There are a lot of bugs with my fork. While I succeeded in adding notifications, my update never made it out of WIP stage.
- Notifications cannot swipe to clear. I was close to figuring this out but didn't quite get there. The touch events aren't getting sent properly to the Bulletin cells, something else is intercepting it.
- Notifications won't swipe to open. Most of my energy was spent trying to discover why they weren't clearing so I never took a proper look at this one. Yes I did set the default action on each bulletin so idk.
- Alarms will sound but the overlay won't appear on the LS. I got around this by unlocking, then locking again or pressing power a few times.
- On rare occasion some notifications will send twice. This only happened to me with missed calls, but it may happen with other apps I'm not sure.
- Using the camera on the LS will open the camera app once you unlock.
- Memory leaks. I spent a lot of time squashing memory leaks but there is still a few I didn't get to.

-----

# Why doesn't certain things work?
- Simple the methods I use are from iOS 9 and although Apple has them in iOS 10 they're subclassed or rather the SBDashBoardViewController (and other SBDashBoard components) are the ones calling the shots here. 
- iOS 10's lockscreen mechanism is a bit weird it uses the dashboard as the main lockscreen view but still uses some old iOS 9 lockscreen components by subclassing them.
- You can basically get the old lockscreen back by disabling the dashboard but by doing so MESA (Touch ID) authentication fails and gets revoked on the "old" lockscreen (thanks to Sticktron for figuring this out).

# Licensed under MIT
You can use this source code in any of your projects as long as:    
We request that you give credit to the original project, although not legally required.    
Any redistributions of this work are required to be free, you can not sell any part of this source code without consent.    

# Donate!
This is a huge project that we took on because people requested it.  
If you would like to help us create more tweaks please donate any amount you would like.    
iKilledAppl3: http://is.gd/donate2ToxicAppl3Inc    
Skittyblock: http://paypal.me/Skittyblock

# Screenshots
![Screenshot](https://raw.githubusercontent.com/iKilledAppl3/Meteora/master/Screenshot1.jpg)
![Screenshot å2](https://raw.githubusercontent.com/iKilledAppl3/Meteora/master/Screenshot2.jpg)

# Video
See Meteora working on iOS 10: https://twitter.com/iKilledAppl3/status/892202494566203393
