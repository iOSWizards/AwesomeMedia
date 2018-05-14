//
//  AppDelegate.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 01/16/2017.
//  Copyright (c) 2017 Evandro Harrison Hoffmann. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AwesomeMediaHelper.start()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AwesomeMediaHelper.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AwesomeMediaHelper.applicationDidBecomeActive()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

