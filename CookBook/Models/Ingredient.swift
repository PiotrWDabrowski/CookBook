//
//  Ingredient.swift
//  CookBook
//
//  Created by Piotr Dąbrowski on 28/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import CoreData
import Foundation

extension Float {
    var pureFraction: String {
        return self < 0 ? "" : self % 1 == 0 ? String(format: "%.0f", self) : String(self)
    }
}

class Ingredient {
    var name : String
    var amount : Float
    var unitName : String
    
    init(name: String?, amount: Float?, unitName: String?) {
        
        self.name = ""
        self.amount = -1
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
        return "\(self.name) -  \(self.amount.pureFraction) \(self.unitName)"
    }
}