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
            
            if (managedObjects.count > from) {
                managedObjects = Array(managedObjects[from..<from+20])
            
                for object in managedObjects {
                    recipes.append(Recipe.recipeForManagedObject(object))
                }
            }
            else {
                NetworkManager.sharedInstance.fetchRecipes(from, completion: { (recipes: [Recipe]?) in
                    if (recipes != nil) {
                        ObjectManager.sharedInstance.saveRecipes(recipes!)
                    }
                    completion(recipes)
                })
            }
            completion(recipes)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            NetworkManager.sharedInstance.fetchRecipes(from, completion: { (recipes: [Recipe]?) in
                if (recipes != nil) {
                    ObjectManager.sharedInstance.saveRecipes(recipes!)
                }
                completion(recipes)
            })
        }
    }
    
    func saveRecipes(recipes: [Recipe]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Recipe", inManagedObjectContext:managedContext)
        
        for recipe in recipes {
            let recipeObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            recipeObject.setValue(recipe.title, forKey: Property.TITLE)
            recipeObject.setValue(recipe.detailedDescription, forKey: Property.DESCRIPTION)
            recipeObject.setValue(recipe.imageUrl, forKey: Property.IMAGE)
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}