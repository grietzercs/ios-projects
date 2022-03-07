//
//  TableinViewController.swift
//  assignment2-2
//
//  Created by Colden on 3/7/22.
//

import UIKit

class TableinViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let groceryItems: [String] = ["Tomatoes", "Bananas", "Gala", "Lettuce", "Broccoli"]
    
    let clothingItems: [String] = ["T-Shirt", "Jeans", "Shoes", "Pajamas", "Polo"]
    
    let movieItems: [String] = ["Shawshank", "Lord of the Rings", "Godfather", "Bladerunner 2049", "Interstellar"]
    
    let gardenItems: [String] = ["Shovel", "Tomato Plant", "Mower", "Garden Soil", "Fruit Tree"]
    
    let electronicItems: [String] = ["Television", "Cell Phone", "Gaming Console", "Headphones", "Laptop"]
    
    let bookItems: [String] = ["Eragon", "Divergent", "The Hobbit", "A Tale of Two Cities", "The Da Vinci Code"]
    
    let applianceItems: [String] = ["Washer", "Dryer", "Dishwasher", "Oven", "Microwave"]
    
    let toyItems: [String] = ["Car", "Firetruck", "Doll", "Slinky", "Spinning Top"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }

}

extension TableinViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("tapped")
    }
}

extension TableinViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        //var image = UIImage(named: groceryImages[indexPath.row])
        
        if let listItem = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
            
            listItem.configure(with: groceryItems[indexPath.row], with: groceryImages[indexPath.row])
            
            cell = listItem
        }
        
        //cell.textLabel?.text = groceryItems[indexPath.row]
        
        //tableCellImage.image = UIImage(named: "grocery-2-bananas.png")!
        
        return cell
    }
}
