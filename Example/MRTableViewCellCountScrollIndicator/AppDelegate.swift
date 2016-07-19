//
//  AppDelegate.swift
//  MRTableViewCellCountScrollIndicator
//
//  Created by Mojca Rojko on 07/13/2016.
//  Copyright (c) 2016 Mojca Rojko. All rights reserved.
//

import UIKit
import RestKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let baseUrl = NSURL(string:"http://trinch.dev.tovarnaidej.com")!
        let objectManager = RKObjectManager(baseURL: baseUrl)
        
        // Initialize managed object model from bundle
        let managedObjectModel:NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)!
        // Initialize managed object store
        let managedObjectStore:RKManagedObjectStore = RKManagedObjectStore(managedObjectModel:managedObjectModel)
        objectManager.managedObjectStore = managedObjectStore
        
        // Complete Core Data stack initialization
        managedObjectStore.createPersistentStoreCoordinator()
        var error:NSError?
        let success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
        if (!success) {
            print("Failed to create Application Data Directory at path" + RKApplicationDataDirectory());
        } else {
            print(error.debugDescription)
        }
        
        let storePath:String = RKApplicationDataDirectory().stringByAppendingString("/ArticlesDB.sqlite")
        do {
            let persistentStore:NSPersistentStore = try managedObjectStore.addSQLitePersistentStoreAtPath(storePath, fromSeedDatabaseAtPath:nil, withConfiguration:nil, options:nil)
        } catch {
            print("Failed to add persistent store")
        }
        
        // Create the managed object contexts
        managedObjectStore.createManagedObjectContexts()
        
        // Configure a managed object cache to ensure we do not create duplicate objects
        managedObjectStore.managedObjectCache = RKInMemoryManagedObjectCache(managedObjectContext: managedObjectStore.persistentStoreManagedObjectContext);
        
        // ENTITY MAPPING
        
        let articleListMapping = RKEntityMapping(forEntityForName: "ArticleList", inManagedObjectStore: managedObjectStore)
        articleListMapping.identificationAttributes = ["title"]
        articleListMapping.addAttributeMappingsFromDictionary([
            "title"     : "title",
            "syndication_url"      : "url",
            "description"      : "article_description",
        ])
        
        let articleMapping = RKEntityMapping(forEntityForName: "Article", inManagedObjectStore: managedObjectStore)
        articleMapping.identificationAttributes = ["title"]
        articleMapping.addAttributeMappingsFromDictionary([
            "publish_date" : "publish_date",
            "source" : "source",
            "source_url" : "source_url",
            "summary" : "summary",
            "title" : "title",
            "url" : "url"
        ])
        
        articleListMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "articles", toKeyPath: "articles", withMapping: articleMapping))
        
        let articleListResponseDescriptor:RKResponseDescriptor = RKResponseDescriptor(mapping:articleListMapping,
        method:RKRequestMethod.GET,
        pathPattern:"/articles.json",
        keyPath:nil,
        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful))
        
        objectManager.addResponseDescriptor(articleListResponseDescriptor)

        // Enable Activity Indicator Spinner
        //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        // Override point for customization after application launch.
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

