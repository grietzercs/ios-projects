//
//  ViewController.swift
//  NumberGuess_2022
//
//  Created by Eyuphan Bulut on 2/3/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var minTF: UITextField!
    
    @IBOutlet weak var maxTF: UITextField!
    
    @IBOutlet weak var guessTF: UITextField!
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var firstGroup: [UIView]!
    
    
    @IBOutlet var secondGroup: [UIView]!
    
    
    var numberOfTries = 0
    
    
    var targetNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScreen(isFirstOn: true)
        
        minTF.keyboardType = .numberPad
        
        guessTF.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        submitGuess(submitButton)
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        
        if let minNum = Int(minTF.text!), let maxNum = Int(maxTF.text!), minNum < maxNum{
            
            targetNumber = Int.random(in: minNum...maxNum)
            
            print("target is \(targetNumber)")
            
            
            updateScreen(isFirstOn: false)
            
        }
        else {
            
            var ac2 = UIAlertController(title: "Error", message: "Check your entry", preferredStyle: .alert)
        
            
            var action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            ac2.addAction(action2)
            
            
            present(ac2, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func submitGuess(_ sender: UIButton) {
        
        numberOfTries += 1
        
        if let guessNum = Int(guessTF.text!) {
            
            if guessNum < targetNumber {
                print("Increase your guess")
                
                imgView.image = UIImage(named: "higher")
            }
            else if guessNum > targetNumber {
                print("Decrease your guess")
                
                imgView.image = UIImage(named: "lower")
            }
            else{
                //print("Congrats! You found it in \(numberOfTries) tries.")
                
                var ac2 =  UIAlertController(title: "Congrats", message: "Congrats! You found it in \(numberOfTries) tries.", preferredStyle: .actionSheet)
                
                var action2 = UIAlertAction(title: "New game", style: .default){
                    
                    _ in self.updateScreen(isFirstOn: true)
                }
                
                ac2.addAction(action2)
                
                present(ac2, animated: true, completion: nil)
                
                
                
                numberOfTries = 0
                
                
            }
        }
    }
    
    func updateScreen(isFirstOn: Bool){
        
        for each in firstGroup {
            each.isHidden = !isFirstOn
        }
        
        for each in secondGroup {
            each.isHidden = isFirstOn
        }
        
    }
    
    


}

