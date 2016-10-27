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

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    let baseUrl = "http://www.godt.no/api/"
    
    func fetchRecipes(from: Int, completion: ([Recipe]?) -> Void) {
        var recipes = [Recipe]()
        Alamofire.request(
            .GET,
            self.baseUrl+"getRecipesListDetailed",
            parameters: ["tags": "", "size": "thumbnail-medium", "ratio": 1, "limit": 20, "from": from],
            encoding: .URL)
            .responseJSON { response in
                if let responseJson = response.result.value {
                    let json = JSON(responseJson)
                    for (_, subJson) in json {
                        if (subJson["title"].string != nil) {
                            let recipe : Recipe = Recipe(title:  subJson["title"].string!, detailedDescription: subJson["description"].string!, imageUrl: subJson["images"][0]["url"].string!)
                            recipes.append(recipe)
                        }
                        completion(recipes)
                    }
                }
                else {
                    completion([])
                }
        }
    }
}