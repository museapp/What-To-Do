//
//  AppDelegate.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/27/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //let us know the location of our Realm DataBase
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        do{
            _ = try Realm()
        }catch{
            print("Error initialising new realm \(error)")
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {

       
    }
    
  
}

