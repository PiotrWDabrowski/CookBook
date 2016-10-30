//
//  NetworkManager.swift
//  CookBook
//
//  Created by Piotr Dąbrowski on 27/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Networking {
    static let BASE_URL = "http://www.godt.no/api/"
    static let GET_DETAILS = "getRecipesListDetailed"
    static let LIMIT = 20
    static let SIZE = "thumbnail-medium"
    static let RATIO = 1
}

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    func fetchRecipes(from: Int, completion: ([Recipe]?) -> Void) {
        Alamofire.request(
            .GET,
            Networking.BASE_URL+Networking.GET_DETAILS,
            parameters: ["tags": "", "size": Networking.SIZE, "ratio": Networking.RATIO, "limit": Networking.LIMIT, "from": from],
            encoding: .URL)
            .responseJSON { response in
                if let responseJson = response.result.value {
                    completion(NetworkManager.parseRecipe(JSON(responseJson)))
                }
                else {
                    completion([])
                }
        }
    }
    
    static func parseRecipe(json: JSON) -> [Recipe] {
        var recipes = [Recipe]()
        for (_, subJson) in json {
            if (subJson[Property.TITLE].string != nil) {
                let recipe : Recipe = Recipe(title:  subJson[Property.TITLE].string!, detailedDescription: subJson[Property.DESCRIPTION].string!, imageUrl: subJson[Property.IMAGES][0][Property.URL].string!)
                for ingredientSubJSON in subJson[Property.INGREDIENTS][0][Property.ELEMENTS] {
                    let ingredient : Ingredient = Ingredient(name: ingredientSubJSON.1[Property.NAME].string, amount: ingredientSubJSON.1[Property.AMOUNT].float, unitName: ingredientSubJSON.1[Property.UNIT_NAME].string)
                    recipe.ingredientsString = recipe.ingredientsString + "<br />" + ingredient.agreggatedString()
                }
                recipes.append(recipe)
            }
        }
        return recipes
    }
}