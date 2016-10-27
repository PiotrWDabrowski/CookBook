//
//  Recipe.swift
//  CookBook
//
//  Created by Piotr Dąbrowski on 27/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import Foundation

class Recipe {
    var title : String
    var detailedDescription : String
    var imageUrl : String
    
    init(title: String?, detailedDescription: String?, imageUrl: String?) {
        
        self.title = ""
        self.detailedDescription = ""
        self.imageUrl = ""
        
        if title != nil {
            self.title = title!
        }
        if detailedDescription != nil {
            self.detailedDescription = detailedDescription!
        }
        if imageUrl != nil {
            self.imageUrl = imageUrl!
        }
    }
    
    func agreggatedString() -> String {
        return "\(self.title), \(self.detailedDescription)"
    }
}
