//
//  TableViewCell.swift
//  assignment2-2
//
//  Created by Colden on 3/7/22.
//

import UIKit; import SwiftUI; 

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var addToCart: UIButton!
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    var sendData = TableViewController()
    
    let categoryName: [String] = ["Grocery", "Clothing", "Movie", "Garden", "Electronic", "Book", "Appliance", "Toy"]
    
    struct Category {
        var groceryImages: [String] = ["grocery-1-tomatoes", "grocery-2-bananas", "grocery-3-gala", "grocery-4-lettuce", "grocery-5-broccoli"]
        var gardenImages: [String] = ["garden-1-shovel", "garden-2-tomato", "garden-3-mower", "garden-4-garden-soil", "garden-5-fruit-tree"]
        var clothingImages: [String] = ["t-shirt", "jeans", "shoes", "Pajamas", "Polo"]
        var movieImages: [String] = ["shawshank", "lord-of-the-rings", "godfather", "bladerunner", "interstellar"]
        var electronicImages: [String] = ["television", "cell-phone", "gaming-console", "headphones", "laptop"]
        var bookImages: [String] = ["eragon", "divergent", "the-hobbit", "a-tale-of-two-cities", "da-vinci"]
        var applianceImages: [String] = ["washer", "dryer", "dishwasher", "oven", "microwave"]
        var toyImages: [String] = ["car", "firetruck", "doll", "slinky", "spinning-top"]
    }
    
    @IBOutlet weak var tableCellLabel: UILabel!
    
    func configure(with cellLabel: String, with image: String, with index: Int, with passedData: Int) {
        //let test = "Passed Tag: \(passedData)"
        
        let category = Category()
        self.addToCart.tag = index
        self.tag = index
        cellImage.image = UIImage(named: category.groceryImages[index])
        tableCellLabel.text = cellLabel
    }
    
    
    @IBAction func addToCart(_ sender: Any) {
        let vc = sendData.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
        vc?.cell = self
        sendData.navigationController?.pushViewController(vc!, animated: true)
    }

}