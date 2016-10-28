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
}

extension String {
    func escapeHTMLCharacters() -> String
    {
        var escapedString : String
        escapedString = self.stringByReplacingOccurrencesOfString("<br >", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        escapedString = self.stringByReplacingOccurrencesOfString("<br />", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return escapedString
    }
}

class Recipe {
    var title : String
    var detailedDescription : String
    var imageUrl : String
    
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
        
        return Recipe(title: title, detailedDescription: detailedDescription, imageUrl:  imageUrl)
    }
    
    func managedObjectForRecipe(recipe: Recipe) -> NSManagedObject {
        let object = NSManagedObject()
        object.setValue(recipe.title, forKey: Property.TITLE)
        object.setValue(recipe.detailedDescription, forKey: Property.DETAIL_DESCRIPTION)
        object.setValue(recipe.imageUrl, forKey: Property.IMAGE_URL)
        return object
    }
}
