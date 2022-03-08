//
//  CollectionViewController.swift
//  assignment2-2
//
//  Created by Colden on 3/6/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var homeScreenImage: UIImageView!
    
    let dataSource: [String] = ["Recent Orders", "Cart", "Grocery", "Clothing", "Movies", "Garden", "Electronics", "Books", "Appliances", "Toys"]
    
    let imageSource: [String] = ["category-1-recent", "category-2-cart", "category-3-grocery", "category-4-clothing", "category-5-movies", "category-6-garden", "category-7-electronics", "category-8-books", "category-9-appliances", "category-10-toys"]
    
    var cell = UICollectionViewCell()
    
    var globalIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        globalIndex = indexPath.row
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        //return cell
        //var cell =  UICollectionViewCell()
        
        if let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            
            categoryCell.configure(with: dataSource[indexPath.row], with: UIImage(named: imageSource[indexPath.row])!, with: indexPath.row)
            
            cell = categoryCell
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        globalIndex = indexPath.row
//        let vc = storyboard?.instantiateViewController(withIdentifier: "TableinViewController") as? TableinViewController
//        vc?.name = dataSource[indexPath.row]
//        self.navigationController?.pushViewController(vc!, animated: true)
        
        print("Selected Category: \(dataSource[indexPath.row])")
    }
    
    /** Handle segue and pass data **/
    @IBAction func segueTapped(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        print("Index: \(sender.tag)")
        
        if (sender.tag < 2) {
            guard let destVC = mainStoryboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else {
                print("Couldn't find the new controller")
                return
            }
            navigationController?.pushViewController(destVC, animated: true)
        }
        
        if (sender.tag > 1) {
            guard let destVC = mainStoryboard.instantiateViewController(withIdentifier: "TableinViewController") as? TableinViewController else {
                print("Couldn't find the new controller")
                return
            }
            navigationController?.pushViewController(destVC, animated: true)
        }
        
    }
    
//    func prepare(for segue: UIStoryboardSegue, send: UIButton) {
//
//        if segue.identifier == "sendData" {
//
//            let destVC = segue.destination as! TableinViewController
//            destVC.passingTag = cell.self.tag
//        }
//    }
    /** Done handling segue **/

}
