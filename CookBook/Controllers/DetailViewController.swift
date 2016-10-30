//
//  DetailViewController.swift
//  CookBook
//
//  Created by Piotr Dąbrowski on 27/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, RecipeSelectionDelegate {
    
    @IBOutlet var recipeTextLabel: UILabel!
    @IBOutlet var recipeDetailedTextView: UITextView!
    @IBOutlet var recipeImage: UIImageView!
    
    var recipe : Recipe?

    func selectRecipe(newRecipe: Recipe) {
        self.recipe = newRecipe
        self.refreshUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUI()
    }
    
    func refreshUI() {
        if (recipe != nil) {
            if let recipeTextLabel = self.recipeTextLabel {
                recipeTextLabel.text = recipe!.title
            }
            if let recipeDetailedTextView = self.recipeDetailedTextView {
                recipeDetailedTextView.text = recipe!.detailedDescription+"\n"+recipe!.ingredientsString
            }
            if let recipeImage = self.recipeImage {
                recipeImage.image = nil
                recipeImage.backgroundColor = UIColor.lightGrayColor()
            }
    
        if (self.recipeImage != nil) {
            let indicator : UIActivityIndicatorView = self.recipeImage.showActivityIndicatory()
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                    ImageManager.sharedInstance.fetchImage(self.recipe!.imageUrl) { (image: UIImage) in
                        dispatch_async(dispatch_get_main_queue(),{
                            indicator.stopAnimating()
                            self.recipeImage.image = image
                        })
                    }
                })
            }
        }
    }
}

