//
//  TableViewController.swift
//  assignment2-2
//
//  Created by Colden on 3/7/22.
//

import UIKit

class TableViewController: UITableViewController {

    let groceryItems: [String] = ["Tomatoes", "Bananas", "Gala", "Lettuce", "Broccoli"]
    
    let clothingItems: [String] = ["T-Shirt", "Jeans", "Shoes", "Pajamas", "Polo"]
    
    let movieItems: [String] = ["Shawshank", "Lord of the Rings", "Godfather", "Bladerunner 2049", "Interstellar"]
    
    let gardenItems: [String] = ["Shovel", "Tomato Peeler", "Mower", "Garden Soil", "Fruit Tree"]
    
    let electronicItems: [String] = ["Television", "Cell Phone", "Gaming Console", "Headphones", "Laptop"]
    
    let bookItems: [String] = ["Eragon", "Divergent", "The Hobbit", "A Tale of Two Cities", "The Da Vinci Code"]
    
    let applianceItems: [String] = ["Washer", "Dryer", "Dishwasher", "Oven", "Microwave"]
    
    let toyItems: [String] = ["Car", "Firetruck", "Doll", "Slinky", "Spinning Top"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    

    //override func tableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
