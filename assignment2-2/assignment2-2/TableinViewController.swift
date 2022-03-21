//
//  TableinViewController.swift
//  assignment2-2
//
//  Created by Colden on 3/7/22.
//

import UIKit

//protocol CanReceive {
//    func passDataBack(data: Int)
//}

class TableinViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    let groceryItems: [String] = ["Tomatoes", "Bananas", "Gala", "Lettuce", "Broccoli"]
    let groceryImages: [String] = ["grocery-1-tomatoes", "grocery-2-bananas", "grocery-3-gala", "grocery-4-lettuce", "grocery-5-broccoli"]
    
    let clothingItems: [String] = ["T-Shirt", "Jeans", "Shoes", "Pajamas", "Polo"]
    let clothingImages: [String] = ["t-shirt", "jeans", "shoes", "Pajamas", "Polo"]
    
    let movieItems: [String] = ["Shawshank", "Lord of the Rings", "Godfather", "Bladerunner 2049", "Interstellar"]
    let movieImages: [String] = ["shawshank", "lord-of-the-rings", "godfather", "bladerunner", "interstellar"]
    
    let gardenItems: [String] = ["Shovel", "Tomato Plant", "Mower", "Garden Soil", "Fruit Tree"]
    let gardenImages: [String] = ["garden-1-shovel", "garden-2-tomato", "garden-3-mower", "garden-4-garden-soil", "garden-5-fruit-tree"]
    
    let electronicItems: [String] = ["Television", "Cell Phone", "Gaming Console", "Headphones", "Laptop"]
    let electronicImages: [String] = ["television", "cell-phone", "gaming-console", "headphones", "laptop"]
    
    let bookItems: [String] = ["Eragon", "Divergent", "The Hobbit", "A Tale of Two Cities", "The Da Vinci Code"]
    let bookImages: [String] = ["eragon", "divergent", "the-hobbit", "a-tale-of-two-cities", "da-vinci"]
    
    let applianceItems: [String] = ["Washer", "Dryer", "Dishwasher", "Oven", "Microwave"]
    let applianceImages: [String] = ["washer", "dryer", "dishwasher", "oven", "microwave"]
    
    let toyItems: [String] = ["Car", "Firetruck", "Doll", "Slinky", "Spinning Top"]
    let toyImages: [String] = ["car", "firetruck", "doll", "slinky", "spinning-top"]
    
    var passingTag = -1
    
    var name = ""
    
    struct cellData {
        
        var image = UIImage(named: "grocery-2-bananas")
        var cellLabel = UILabel()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
//    @IBAction func goToCart(sender: UIBarButtonItem) {

//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//        print("buttonPressed")
//
//        if (sender.tag != 10) {
//            guard let destVC = mainStoryboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else {
//                print("Couldn't find the new controller")
//                return
//            }
//            navigationController?.pushViewController(destVC, animated: true)
//        }
//    }
    
    
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
        
        print(self.passingTag)

        var cell = UITableViewCell()
        //var image = UIImage(named: groceryImages[indexPath.row])
        
        if let listItem = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
            
            listItem.configure(with: groceryItems[indexPath.row], with: groceryItems[indexPath.row], with: indexPath.row, with: passingTag)
            
            cell = listItem
        }
        
        if let cell = TableViewCell.dequeueReusableCell(withIdentifier: "CartViewCell", for: indexPath) as? CartViewCell {
            cell.tableCellLabel.text = groceryItems[indexPath.row]
            cell.cellImage.image = UIImage(named: groceryImages[indexPath.row])
        }
        
        return cell
    }
}
