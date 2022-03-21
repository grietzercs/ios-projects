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
    
    @IBOutlet weak var categoryNavBar: UINavigationItem!
    @IBOutlet weak var rightNavBarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: "testCart", style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.categoryNavBar.rightBarButtonItem = rightButton
        self.categoryNavBar.rightBarButtonItem?.tag = 1
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
