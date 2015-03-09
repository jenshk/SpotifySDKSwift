//
//  AppDelegate.swift
//  Spotify Swift
//
//  Created by Vedran Ozir on 09/02/15.
//  Copyright (c) 2015 Vedran Ozir. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var player: SPTAudioStreamingController?
    var session: SPTSession?
    
    let kClientId = "Your-Client-Id"
    let kCallbackURL = "Your-Callback-URL"
    let kTokenSwapURL = "http://localhost:1234/swap"
    
    // let kTokenSwapURL = "http://mysterious-inlet-1629.herokuapp.com/swap"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create SPTAuth instance; create login URL and open it
        let auth = SPTAuth.defaultInstance()
        let loginURL = auth.loginURLForClientId(kClientId, declaredRedirectURL: NSURL(string: kCallbackURL), scopes: [SPTAuthStreamingScope])
        
        // Opening a URL in Safari close to application launch may trigger
        // an iOS bug, so we wait a bit before doing so.
        
        //        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("openURL:"), userInfo: NSURL(string: "http://m.google.com"), repeats: false)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("openURL:"), userInfo: loginURL, repeats: false)
        
        return true
    }
    
    func openURL(timer: NSTimer) {
        
        let loginURL : NSURL = timer.userInfo! as NSURL
        let application = UIApplication.sharedApplication()
        
        application.openURL(loginURL)
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        println("made it to 3")
        
        // Ask SPTAuth if the URL given is a Spotify authentication callback
        if SPTAuth.defaultInstance().canHandleURL(url, withDeclaredRedirectURL: NSURL(string: kCallbackURL))
        {
            // Call the token swap service to get a logged in session
            let t : SPTAuth = SPTAuth.defaultInstance()
            
            
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, tokenSwapServiceEndpointAtURL: NSURL(string: kTokenSwapURL), callback: { ( error: NSError!, session: SPTSession!) -> Void in
                
                if (error != nil) {
                    NSLog("*** Auth error: \(error)");
                    return;
                }
                
                // Call the -playUsingSession: method to play a track
                self.playUsingSession(session!)
            })
            
            return true
        }
        
        return false
    }
    
    func playUsingSession(session: SPTSession)
    {
        // Create a new player if needed
        if player == nil {
            player = SPTAudioStreamingController(clientId: kClientId)
        }
        
        player?.loginWithSession(session, callback: { (error : NSError!) -> Void in
            
            if error != nil {
                println("*** Enabling playback got error: \(error)");
                return;
            }
            
            SPTRequest.requestItemAtURI(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), withSession: nil, callback: { (error: NSError!, album_: AnyObject!) -> Void in
                
                if error != nil {
                    println("*** Album lookup got error: \(error)");
                    return;
                }
                
                // check if this cast work
                let album: SPTTrackProvider = album_ as SPTTrackProvider
                
                self.player?.playTrackProvider( album, callback: nil)
                
            })
        })
        
    }
}

