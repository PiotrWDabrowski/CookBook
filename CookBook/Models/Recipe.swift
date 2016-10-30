//
//  Recipe.swift
//  CookBook
//
//  Created by Piotr Dąbrowski on 27/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import CoreData
import Foundation

struct Property {
    static let TITLE = "title"
    static let DESCRIPTION = "description"
    static let DETAIL_DESCRIPTION = "detailedDescription"
    static let IMAGES = "images"
    static let IMAGE_URL = "imageUrl"
    static let RECIPE = "Recipe"
    static let URL = "url"
    static let INGREDIENTS = "ingredients"
    static let INGREDIENTS_STRING = "ingredientsString"
    static let ELEMENTS = "elements"
    static let NAME = "name"
    static let AMOUNT = "amount"
    static let UNIT_NAME = "unitName"
}

extension String {
    func escapeHTMLCharacters() -> String
    {
        var escapedString : String = self
        escapedString = escapedString.stringByReplacingOccurrencesOfString("<br >", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        escapedString = escapedString.stringByReplacingOccurrencesOfString("<br />", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        escapedString = escapedString.stringByReplacingOccurrencesOfString("<a >", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        escapedString = escapedString.stringByReplacingOccurrencesOfString("</a>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

        return escapedString
    }
}

class Recipe {
    var title : String
    var detailedDescription : String
    var imageUrl : String
    var ingredients : [Ingredient]
    var ingredientsString : String
    
    init(title: String?, detailedDescription: String?, imageUrl: String?) {
        
        self.title = ""
        self.detailedDescription = ""
        self.imageUrl = ""
        
        if title != nil {
            self.title = title!.escapeHTMLCharacters()
        }
        if detailedDescription != nil {
            self.detailedDescription = detailedDescription!.escapeHTMLCharacters()
        }
        if imageUrl != nil {
            self.imageUrl = imageUrl!
        }
        self.ingredients = [Ingredient]()
        self.ingredientsString = ""
    }
    
    func agreggatedString() -> String {
        return "\(self.title), \(self.detailedDescription)"
    }
    
    static func recipeForManagedObject(object: NSManagedObject) -> Recipe {
        var title = object.valueForKey(Property.TITLE) as? String
        title = title==nil ? "" : title
        
        var detailedDescription = object.valueForKey(Property.DETAIL_DESCRIPTION) as? String
        detailedDescription = detailedDescription==nil ? "" : detailedDescription
        
        var imageUrl =  object.valueForKey(Property.IMAGE_URL) as? String
        imageUrl = imageUrl==nil ? "" : imageUrl
        
        var ingredientString = object.valueForKey(Property.INGREDIENTS_STRING) as? String
        ingredientString = ingredientString==nil ? "" : ingredientString
        
        let recipe : Recipe = Recipe(title: title, detailedDescription: detailedDescription, imageUrl:  imageUrl)
        recipe.ingredientsString = ingredientString!
        return recipe
    }
    
    func managedObjectForRecipe(recipe: Recipe) -> NSManagedObject {
        let object = NSManagedObject()
        object.setValue(recipe.title, forKey: Property.TITLE)
        object.setValue(recipe.detailedDescription, forKey: Property.DETAIL_DESCRIPTION)
        object.setValue(recipe.imageUrl, forKey: Property.IMAGE_URL)
        object.setValue(recipe.ingredientsString, forKey: Property.INGREDIENTS_STRING)
        return object
    }
}
