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
        return "\(self.name) -  \(self.amount)  \(self.unitName)"
    }
}