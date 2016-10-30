//
//  CookBookTests.swift
//  CookBookTests
//
//  Created by Piotr Dąbrowski on 27/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import CookBook

class CookBookTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecipeParse() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource("getSingleRecipeDetailed", ofType: "json")
        if let data = NSData(contentsOfFile: path!) {
            XCTAssertNotNil(data)
            let json = JSON(data: data)
            let recipes: [Recipe] = NetworkManager.parseRecipe(json)
            XCTAssertNotNil(recipes)
            XCTAssertNotNil(recipes.first?.title)
            XCTAssertNotNil(recipes.first?.detailedDescription)
            XCTAssertNotNil(recipes.first?.imageUrl)
            XCTAssertNotNil(recipes.first?.ingredientsString)
        }
    }
    
}
