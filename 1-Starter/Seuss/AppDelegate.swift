//
//  AppDelegate.swift
//  Seuss
//
//  Created by Richard Turton on 13/11/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    
    var keyboardAppearObserver : AnyObject?
    var keyboardDisappearObserver : AnyObject?

    let coreDataStack = CoreDataStack()
    
    weak var keyboardDismissingOverlay : KeyboardDismissingOverlay?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    if let booksVC = (window?.rootViewController as? UINavigationController)?.topViewController as? BooksTableViewController {
        booksVC.coreDataStack = coreDataStack
    }
    
    keyboardAppearObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object:nil, queue:NSOperationQueue.mainQueue(), usingBlock:{
        notification in
        
        let overlay = KeyboardDismissingOverlay(frame:CGRectZero)
        overlay.backgroundColor = UIColor.clearColor()
        self.window?.rootViewController?.view.addSubview(overlay)
        overlay.frame = overlay.superview!.bounds
        if let userInfo = notification.userInfo {
            overlay.keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        }
        self.keyboardDismissingOverlay = overlay
    })
    
    keyboardDisappearObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object:nil, queue:NSOperationQueue.mainQueue(), usingBlock:{
        notification in
        self.keyboardDismissingOverlay?.removeFromSuperview()
        self.keyboardDismissingOverlay = nil
    })
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}
