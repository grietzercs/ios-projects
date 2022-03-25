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
    
    let labelOptions: [String] = ["Easy", "Medium", "Hard", "Balloon Pop", "Sorting Game", "Memory Game"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        easyButton.tag = 1
        mediumButton.tag = 2
        hardButton.tag = 3
        balloonsButton.tag = 4
        sortingButton.tag = 5
        memoryButton.tag = 6
        
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
    }
    @IBAction func sortingPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
    }
    @IBAction func balloonsPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
    }
    
    //Difficulty Options
    @IBAction func easyPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
    }
    @IBAction func mediumPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
    }
    @IBAction func hardPressed(_ sender: UIButton) {
        gameMutex(itemTag: sender.tag)
    }
    
    
    @IBAction func playPressed(_ sender: Any) {
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
    }
}

