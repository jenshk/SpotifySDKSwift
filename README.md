# SpotifySDKSwift
This code contains the conversion of the spotify SDK (Objective-C) To Swift To Be Used In XCODE 

This code will work as a swift project, but it relies on the bridging header to call the objective-C code.

Steps
1) Download this code and open it in XCODE
2) Under the “SpotifyAppSwift” directory, open the AppDelegate.swift file
3) Edit these two lines to add in your details. 
  let kClientId = "Your-Client-Id"
  let kCallbackURL = "Your-Callback-URL"
If you aren’t sure how to do this, go to https://developer.spotify.com/technologies/spotify-ios-sdk/tutorial/
4) make sure you follow the steps in that tutorial to kick off the “$ ruby spotify_token_swap.rb” process
5) If you play the app and it works, you should hear some country music!

I am now trying to get the Heroku token exchange working as per this tutorial but am having a few challenges. If anyone manages to get it working please post.

https://github.com/simontaen/SpotifyTokenSwap