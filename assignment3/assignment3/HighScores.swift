//
//  HighScores.swift
//  assignment3
//
//  Created by Colden on 3/30/22.
//

import UIKit

class HighScores: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        var tempArray = [String]()
        tempArray = userDefaults.stringArray(forKey: "scores")!
        if (tempArray != nil) {
            for item in tempArray {
                
            }
        }
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        headerLabel.text = "\t Order\t Game Type\t Difficulty\t Score"
        headerLabel.textColor = .black
        headerLabel.backgroundColor = .gray
        view.addSubview(headerLabel)
        
        let scoreLabel = UILabel(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 100))
        scoreLabel.text = "\t 1\t\t Sorting\t\t Hard\t\t 50.4"
        scoreLabel.textColor = .black
        scoreLabel.backgroundColor = .cyan
        view.addSubview(scoreLabel)
        // Do any additional setup after loading the view.
    }
}

extension UILabel {
    class func scoreLabel(frame: CGRect, text: String) -> UILabel {
        
        let returnLabel = UILabel(frame: frame)
        returnLabel.text = text
        returnLabel.textColor = .black
        returnLabel.backgroundColor = .cyan
        
        return returnLabel
    }
}
