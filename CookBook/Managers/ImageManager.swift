//
//  ImageManager.swift
//  CookBook
//
//  Created by Piotr Dąbrowski on 27/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class ImageManager {
    static let sharedInstance = ImageManager()
    
    let imageCache = AutoPurgingImageCache()
    
    func fetchImage(url: String, completion: (UIImage) -> Void) {
        // Verifying image existance in imageCache
        if let cachedImage = self.imageCache.imageWithIdentifier(url) {
            completion(cachedImage)
            return
        }
        // Due to failure above: Downloading the new image
        else if let urlObject = NSURL(string: url) {
            if let data = NSData(contentsOfURL: urlObject) {
                if let image = UIImage(data: data) {
                    // Append cache and return it
                    self.imageCache.addImage(image, withIdentifier: url)
                    completion(image)
                    return
                }
            }
        }
        else {
            completion(UIImage())
        }
    }
}