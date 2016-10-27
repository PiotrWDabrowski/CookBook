//
//  MasterTableViewCell.swift
//  TestSchb
//
//  Created by Piotr Dąbrowski on 26/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {
    
    @IBOutlet var recipeTextLabel: UILabel!
    @IBOutlet var recipeDetailedTextLabel: UILabel!
    @IBOutlet var recipeImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
