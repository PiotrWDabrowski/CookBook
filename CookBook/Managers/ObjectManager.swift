//
//  ObjectManager.swift
//  CookBook
//
//  Created by Piotr Dąbrowski on 28/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import CoreData
import Foundation
import UIKit
import SystemConfiguration

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

class ObjectManager {
    static let sharedInstance = ObjectManager()
    
    func fetchRecipes(from: Int, completion: ([Recipe]?) -> Void) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        var recipes = [Recipe]()
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            var managedObjects : [NSManagedObject] = results  as! [NSManagedObject]
            
            if (!Reachability.isConnectedToNetwork()) {
                managedObjects = Array(managedObjects[from..<min(from+Networking.LIMIT, managedObjects.count)])
            
                for object in managedObjects {
                    recipes.append(Recipe.recipeForManagedObject(object))
                }
                completion(recipes)
            }
            else {
                self.loadNewRecipes(from, completion: completion)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            self.loadNewRecipes(from, completion: completion)
        }
    }
    
    func loadNewRecipes(from: Int, completion: ([Recipe]?) -> Void) {
        
        NetworkManager.sharedInstance.fetchRecipes(from, completion: { (recipes: [Recipe]?) in
            if (from == 0) {
                self.eraseRecipyCache()
            }
            if (recipes != nil) {
                ObjectManager.sharedInstance.saveRecipes(recipes!)
            }
            completion(recipes)
        })
    }
    
    func saveRecipes(recipes: [Recipe]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Recipe", inManagedObjectContext:managedContext)
        
        for recipe in recipes {
            let recipeObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            recipeObject.setValue(recipe.title, forKey: Property.TITLE)
            recipeObject.setValue(recipe.detailedDescription, forKey: Property.DETAIL_DESCRIPTION)
            recipeObject.setValue(recipe.imageUrl, forKey: Property.IMAGE_URL)
            recipeObject.setValue(recipe.ingredientsString, forKey: Property.INGREDIENTS_STRING)
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func eraseRecipyCache() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deletedObjects
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}