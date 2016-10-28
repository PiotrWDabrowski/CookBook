//
//  Ingredient.swift
//  CookBook
//
//  Created by Piotr Dąbrowski on 28/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import CoreData
import Foundation

class Ingredient {
    var name : String
    var amount : Int
    var unitName : String
    
    init(name: String?, amount: Int?, unitName: String?) {
        
        self.name = ""
        self.amount = 0
        self.unitName = ""
        
        if name != nil {
            self.name = name!.escapeHTMLCharacters()
        }
        if amount != nil {
            self.amount = amount!
        }
        if unitName != nil {
            self.unitName = unitName!
        }
    }
    
    func agreggatedString() -> String {
        return "\(self.name), -  \(self.amount)  \(self.unitName)"
    }
    
    static func IngredientForManagedObject(object: NSManagedObject) -> Ingredient {
        var name = object.valueForKey(Property.NAME) as? String
        name = name==nil ? "" : name
        
        var amount = object.valueForKey(Property.AMOUNT) as? Int
        amount = amount==nil ? 0 : amount
        
        var unitName =  object.valueForKey(Property.UNIT_NAME) as? String
        unitName = unitName==nil ? "" : unitName
        
        return Ingredient(name: name, amount: amount, unitName:  unitName)
    }
    
    func managedObjectForIngredient(ingredient: Ingredient) -> NSManagedObject {
        let object = NSManagedObject()
        object.setValue(ingredient.name, forKey: Property.NAME)
        object.setValue(ingredient.amount, forKey: Property.AMOUNT)
        object.setValue(ingredient.unitName, forKey: Property.UNIT_NAME)
        return object
    }
}