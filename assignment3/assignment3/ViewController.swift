//
//  ViewController.swift
//  assignment3
//
//  Created by Colden on 3/22/22.
//

import UIKit

class ViewController: UIViewController {


    
    @IBOutlet weak var balloonsButton: UIButton!
    @IBOutlet weak var sortingButton: UIButton!
    @IBOutlet weak var memoryButton: UIButton!
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var diffLabel: UILabel!

    var diffSemaphore = 0
    var gameSemaphore = 0
    
    var chosenGame = 0
    var chosenDifficulty = 0
    
    let labelOptions: [String] = ["Easy", "Medium", "Hard", "Balloon Pop", "Sorting Game", "Memory Game"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        easyButton.tag = 1
        mediumButton.tag = 2
        hardButton.tag = 3
        balloonsButton.tag = 4
        sortingButton.tag = 5
        memoryButton.tag = 6
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "back-main.png")!).withAlphaComponent(0.5)
        
//        balloonsButton.frame = CGRect(x: 785, y: 80, width: balloonsButton.intrinsicContentSize.width, height: balloonsButton.intrinsicContentSize.height)
//        let point = view.frame.width - (view.frame.width/2)
//        balloonsButton.center = CGPoint(x: 900, y: 164)
//
//        sortingButton.frame = CGRect(x: 785, y: 80, width: sortingButton.intrinsicContentSize.width, height: sortingButton.intrinsicContentSize.height)
//        sortingButton.center = CGPoint(x: 512, y: 164)
        
    }
    
    func gameMutex(itemTag: Int) {
        
        let alertController = UIAlertController(title: "Could Not Select Option", message: "More than one option selected", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        if (itemTag > 0 && itemTag < 4) {
            diffSemaphore = itemTag
            diffLabel.text = "Game: " + labelOptions[itemTag - 1]
        } else {
            gameSemaphore = itemTag
            gameLabel.text = "Difficulty: " + labelOptions[itemTag - 1]
        }
    }
  
    //Game Options
    @IBAction func memoryPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
        chosenGame = 1
    }
    @IBAction func sortingPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
        chosenGame = 2
    }
    @IBAction func balloonsPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
        chosenGame = 3
    }
    
    //Difficulty Options
    @IBAction func easyPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
        chosenDifficulty = 1
    }
    @IBAction func mediumPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
        chosenDifficulty = 2
    }
    @IBAction func hardPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
        chosenDifficulty = 3
    }
    
    
    @IBAction func playPressed(_ sender: UIButton) {
        var alertController = UIAlertController(title: "Missing option", message: "More than one option selected", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        if (diffSemaphore == 0) {
            alertController.message = "No difficulty selected"
            self.present(alertController, animated: true, completion: nil)
        }
        if (gameSemaphore == 0) {
            alertController.message = "No game selected"
            self.present(alertController, animated: true, completion: nil)
        }
        
        if (chosenGame == 3) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            guard let resultVC = storyBoard.instantiateViewController(withIdentifier: "BalloonGame") as? BalloonGame else {
                print("Could not find controller")
                return
            }
            resultVC.difficulty = chosenDifficulty
            //self.performSegue(withIdentifier: "BalloonGame", sender: self)
            //self.present(resultVC, animated:true, completion:nil)
            navigationController?.pushViewController(resultVC, animated: true)
        }
        if (chosenGame == 2) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            guard let resultVC = storyBoard.instantiateViewController(withIdentifier: "SortingGame") as? SortingGame else {
                print("Could not find controller")
                return
            }
            resultVC.difficulty = chosenDifficulty
            //self.performSegue(withIdentifier: "BalloonGame", sender: self)
            //self.present(resultVC, animated:true, completion:nil)
            navigationController?.pushViewController(resultVC, animated: true)
        }
        
//        if (sender.tag == 0) {
//            guard let destVC = mainStoryboard.instantiateViewController(withIdentifier: "RecentOrdersViewController") as? RecentOrdersViewController else {
//                print("Couldn't find the new controller")
//                return
//            }
//            navigationController?.pushViewController(destVC, animated: true)
//        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Test" {
//            if let destination = segue.destination as? Test {
//                
//                destination.data = chosenDifficulty
//            }
//        }
//    }
}

