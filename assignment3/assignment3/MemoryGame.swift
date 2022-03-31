//
//  ViewController.swift
//  memoryGame
//
//  Created by Colden on 3/29/22.
//

import UIKit

class MemoryGame: UIViewController {
    
    var timer = Timer()
    var timerLabel: UILabel!
    var scoreLabel: UILabel!
    var remainTime: Int = 60
    var timeKeeper = 0
    var score = 0
    
    var xPos = 180
    var yPos = 100
    var frame: CGRect!
    var newButton: UIButton!
    var array = [UIImage]()
    var buttonArray = [UIButton]()
    
    var mode = 0
    var difficulty = 0
    
    var lastImage = 999
    var numTiles = 0
    
    struct selectImage {
        var tag = 0
        var image = 0
    }
    struct trackItem {
        var button: UIButton!
        var timeSelected: Int!
    }
    var pairedImages = [selectImage]()
    var foundMatches: Int!
    var imageToCompare: trackItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let tempButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        let tempStruct = trackItem(button: tempButton, timeSelected: nil)
        imageToCompare = tempStruct

        for i in 1...10 {
            let image = UIImage(named: "\(i).png")
            array.append(image!)
        }
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        timerLabel = UILabel.customLabel(xPoint: 100, text: "Time: 0")
        view.addSubview(timerLabel)
        
        scoreLabel = UILabel.customLabel(xPoint: view.frame.width-200, text: "Score: 0")
        view.addSubview(scoreLabel)
        
        diffSettings()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.counter();
            //self.generateBalloon();
            //self.genSpecBalloons()
        }
        
        genTile(mode: mode)
        //genEasy(diff: 1)
    }
    
    @objc func counter() {
        
        if (remainTime <= 0) {
            self.timer.invalidate()
            let alertController = UIAlertController(title: "Ran out of time!", message: "GAME OVER", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Play Again?", style: .default, handler: {action in
                //self.startOver()
                self.timer.invalidate()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        
        remainTime -= 1
        timeKeeper += 1
        timerLabel.text = "Timer: \(remainTime)"
        timerLabel.frame = CGRect(x: 100, y: 50, width: timerLabel.intrinsicContentSize.width, height: 26.5)
    }
    
    func diffSettings() {
        
        switch difficulty {
        case 1:
            remainTime = 120
            mode = 1
            numTiles = 12
            
        case 2:
            remainTime = 105
            mode = 2
            numTiles = 16
            
        case 3:
            remainTime = 90
            mode = 3
            numTiles = 20
            
        default:
            remainTime = 60
            
        }
    }
    
    func genTile(mode: Int) {
        
        var xIncr = 160
        var yIncr = 200
        var ix = 0
        var nextPic = 0
        var buttonTag = 0
        
        switch mode {
        case 1:
            xPos = 200
            yPos = 100
            xIncr = 200
            yIncr = 160
            ix = 2
        case 2:
            xPos = 140
            yPos = 100
            xIncr = 200
            yIncr = 160
            ix = 3
        case 3:
            xPos = 110
            yPos = 100
            xIncr = 160
            yIncr = 160
            ix = 4
        default:
            xPos = 200
            yPos = 100
            xIncr = 200
            yIncr = 160
            ix = 3
        }
        
        let tempX = xPos
        
        for _ in 0...3 {

            for _ in 0...ix {
                frame = CGRect(x: xPos, y: yPos, width: 150, height: 150)
                newButton = UIButton.customButton(frame: frame)
                //newButton.setImage(array[nextPic], for: .normal)
                newButton.addTarget(self, action: #selector(self.tilePressed(_:)), for: .touchUpInside)
                newButton.tag = buttonTag
                view.addSubview(newButton)
                buttonArray.append(newButton)
                xPos += xIncr
                nextPic += 1
                if (nextPic > 9) {
                    nextPic = 0
                }
                buttonTag += 1
            }
            yPos += yIncr
            xPos = tempX
        }
        randImage()
    }
    
    func randImage() {
        var imageArray = [Int]()
        let pairs = (numTiles/2)
        let numRemove = 10-pairs
        var tempArray = buttonArray
        
        for i in 1...10 {
            
            imageArray.append(i)
        }
        
        for _ in 0..<numRemove {
            
            let randX = Int.random(in: 0..<imageArray.count)
            imageArray.remove(at: randX)
        }
        for _ in 0..<pairs {
            
            var randPick = Int.random(in: 0..<tempArray.count)
            var imageToTile = selectImage(tag: tempArray[randPick].tag, image: imageArray[0])
            tempArray.remove(at: randPick)
            pairedImages.append(imageToTile)
            
            randPick = Int.random(in: 0..<tempArray.count)
            imageToTile = selectImage(tag: tempArray[randPick].tag, image: imageArray[0])
            tempArray.remove(at: randPick)
            pairedImages.append(imageToTile)
            imageArray.remove(at: 0)
        }
        
    }
    
    func compare(item1: UIButton, item2: UIButton) -> Bool {
        
        var returnImage1: Int!
        var returnImage2: Int!

//        for image in pairedImages {
//            if (image.tag == item1.tag) {
//                //print("Image tag: \(image.image)")
//                returnImage1 = image.image
//            }
//            if (image.tag == item2.tag) {
//                print("Image2 tag: ")
//                returnImage2 = image.image
//            }
//        }
        returnImage1 = getImage(buttonTag: item1.tag)
        returnImage2 = getImage(buttonTag: item2.tag)

        if (returnImage1 == returnImage2) {
            return true
        }
        return false
    }
    
    @objc func tilePressed(_ sender: UIButton) {
        
        let imageInt = getImage(buttonTag: sender.tag)
        sender.setImage(UIImage(named: "\(imageInt).png"), for: .normal)
        print("Sender tag: \(sender.tag)")
//        imageToCompare.timeSelected = 0
//        imageToCompare.button = sender
        
        if (imageToCompare.timeSelected == nil) {
            //print("Sender tag: \(sender.tag)")
            imageToCompare.button = sender
            imageToCompare.timeSelected = timeKeeper
        } else {
            if (compare(item1: imageToCompare.button, item2: sender)) {
                let timeDiff = timeKeeper - imageToCompare.timeSelected
                if (timeDiff <= 3) {
                    score += 5
                }
                if (timeDiff < 3 && timeDiff <= 7) {
                    score += 4
                }
                if (timeDiff > 7) {
                    score += 3
                }
                scoreLabel.text = "Score: \(score)"
                scoreLabel.frame = CGRect(x: view.frame.width-200, y: 50, width: scoreLabel.intrinsicContentSize.width, height: scoreLabel.intrinsicContentSize.height)
                decreaseArraySize(buttonTag: imageToCompare.button.tag)
                decreaseArraySize(buttonTag: sender.tag)
            } else {
                
                let seconds = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                    // Put your code which should be executed with a delay here
                    sender.setImage(UIImage(named: "question.png"), for: .normal)
                    
                    
                    if let index = buttonArray.firstIndex(of: imageToCompare.button){
                        buttonArray[index].setImage(UIImage(named: "question.png"), for: .normal)
                    }
//                    for button in self.buttonArray {
//                        if (button.tag == self.imageToCompare.button.tag) {
//                            button.setImage(UIImage(named: "question.png"), for: .normal)
//                        }
//                    }

                    self.imageToCompare.button = nil
                    self.imageToCompare.timeSelected = nil
                }
            }
        }
    }
    
    func getImage(buttonTag: Int) -> Int {
        for image in pairedImages {
            if (image.tag == buttonTag) {
                return image.image
            }
        }
        return -1
    }
    
    func decreaseArraySize(buttonTag: Int) {
        for i in 0..<pairedImages.count-1 {
            if (pairedImages[i].tag == buttonTag) {
                pairedImages.remove(at: i)
            }
        }
    }
}

extension UIButton {
    class func customButton(frame: CGRect) -> UIButton {
        
        let tempButton = UIButton(frame: frame)
        tempButton.setImage(UIImage(named: "question.png"), for: .normal)
        tempButton.layer.cornerRadius = 25

        return tempButton
    }
}
extension UILabel {
    class func customLabel(xPoint: CGFloat, text: String) -> UILabel {
        let givenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 26.5))
        givenLabel.textAlignment = .center
        givenLabel.font = UIFont.preferredFont(forTextStyle: .body)
        givenLabel.font = givenLabel.font.withSize(30)
        givenLabel.textColor = .purple
        givenLabel.text = text
        givenLabel.frame = CGRect(x: xPoint, y: 50, width: givenLabel.intrinsicContentSize.width, height: givenLabel.intrinsicContentSize.height)
        
        return givenLabel
    }
}

