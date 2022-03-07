//
//  TableViewCell.swift
//  assignment2-2
//
//  Created by Colden on 3/7/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    let categoryName: [String] = ["Grocery", "Clothing", "Movie", "Garden", "Electronic", "Book", "Appliance", "Toy"]
    
    
    struct Category {
        var groceryImages: [String] = ["grocery-1-tomatoes", "grocery-2-bananas", "grocery-3-gala", "grocery-4-lettuce", "grocery-5-broccoli"]
        var gardenImages: [String] = ["garden-1-shovel", "garden-2-tomato", "garden-3-mower", "garden-4-garden-soil", "garden-5-fruit-tree"]
        
    }
    
    
    
    @IBOutlet weak var tableCellImage: UIImageView!
    
    @IBOutlet weak var tableCellLabel: UILabel!
    
    func configure(with cellLabel: String, with image: String) {
        
        tableCellImage.image = UIImage(named: "grocery-2-bananas")
        tableCellLabel.text = cellLabel
    }
}
