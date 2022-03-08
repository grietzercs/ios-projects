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
    @IBOutlet weak var rightNavBarButton: UIButton!
    
    let groceryItems: [String] = ["Tomatoes", "Bananas", "Gala", "Lettuce", "Broccoli"]
    
    let clothingItems: [String] = ["T-Shirt", "Jeans", "Shoes", "Pajamas", "Polo"]
    
    let movieItems: [String] = ["Shawshank", "Lord of the Rings", "Godfather", "Bladerunner 2049", "Interstellar"]
    
    let gardenItems: [String] = ["Shovel", "Tomato Plant", "Mower", "Garden Soil", "Fruit Tree"]
    
    let electronicItems: [String] = ["Television", "Cell Phone", "Gaming Console", "Headphones", "Laptop"]
    
    let bookItems: [String] = ["Eragon", "Divergent", "The Hobbit", "A Tale of Two Cities", "The Da Vinci Code"]
    
    let applianceItems: [String] = ["Washer", "Dryer", "Dishwasher", "Oven", "Microwave"]
    
    let toyItems: [String] = ["Car", "Firetruck", "Doll", "Slinky", "Spinning Top"]
    
    var passingTag = -1
    
    var name = ""
    
//    var delegate:CanReceive?
//
//    var data = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //let rightButton: UIBarButtonItem = UIBarButtonItem(title: "testCart", style: UIBarButtonItem.Style.done, target: nil, action: nil)
        //self.navBar.rightBarButtonItem = rightButton
        //self.navBar.rightBarButtonItem?.tag = 1
    }
    
//    @IBAction func goToCart(sender: UIBarButtonItem) {
//        
//
//
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
        
        //cell.textLabel?.text = groceryItems[indexPath.row]
        
        //tableCellImage.image = UIImage(named: "grocery-2-bananas.png")!
        
        return cell
    }
}
