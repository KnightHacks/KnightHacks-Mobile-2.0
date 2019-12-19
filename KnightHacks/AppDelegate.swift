//
//  AppDelegate.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 6/23/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applicationWillOverrideUI()
        return true
    }
    
    func applicationWillOverrideUI() {
        guard let UIConfigurationList = getPlist(withName: "UIConfigurationList") else {
            return
        }
        
        if let backgroundColorHex = UIConfigurationList[ColorSchemeName.backgroundColor.rawValue] as? String, let intValue = Int(backgroundColorHex, radix: 16) {
            BACKGROUND_COLOR = UIColor(hex: intValue, alpha: 1)
        }
        
        if let scheduleColorHex = UIConfigurationList[ColorSchemeName.scheduleMenuColor.rawValue] as? String, let intValue = Int(scheduleColorHex, radix: 16) {
            SCHEDULE_MENU_COLOR = UIColor(hex: intValue, alpha: 1)
            
        }
        
        if let liveUpdatesColorHex = UIConfigurationList[ColorSchemeName.liveUpdatesMenuColor.rawValue] as? String, let intValue = Int(liveUpdatesColorHex, radix: 16) {
            LIVE_UPDATES_MENU_COLOR = UIColor(hex: intValue, alpha: 1)
        }
        
        if let faqsColorHex = UIConfigurationList[ColorSchemeName.faqsMenuColor.rawValue] as? String, let intValue = Int(faqsColorHex, radix: 16) {
            FAQS_MENU_COLOR = UIColor(hex: intValue, alpha: 1)
        }
        
        if let workshopsColorHex = UIConfigurationList[ColorSchemeName.workshopsMenuColor.rawValue] as? String, let intValue = Int(workshopsColorHex, radix: 16) {
            WORKSHOPS_MENU_COLOR = UIColor(hex: intValue, alpha: 1)
        }
        
        if let sponsorsColorHex = UIConfigurationList[ColorSchemeName.sponsorsMenuColor.rawValue] as? String, let intValue = Int(sponsorsColorHex, radix: 16) {
            SPONSORS_MENU_COLOR = UIColor(hex: intValue, alpha: 1)
        }
        
        if let profileColorHex = UIConfigurationList[ColorSchemeName.profileMenuColor.rawValue] as? String, let intValue = Int(profileColorHex, radix: 16) {
            PROFILE_MENU_COLOR = UIColor(hex: intValue, alpha: 1)
        }
        
    }
    
    func getPlist(withName name: String) -> [String:Any]? {
        if
            let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path) {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String:Any]
        }
        
        return nil
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

