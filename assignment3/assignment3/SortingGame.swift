
import UIKit

class SortingGame: UIViewController {
    
    var imageArray = [Int]()
    var itemArray = [UIImageView]()
    var difficulty = 0
    var numItems = 0
    
    var timer = Timer()
    var timerLabel: UILabel!
    var scoreLabel: UILabel!
    var remainTime: Int = 60
    var timeKeeper = 0
    var score = 0
    
    var xPos = 0
    var imageWH = 0
    var xIncr = 0
    
    struct touchPoint<Equatable> {
        var image: UIView!
        var timePlaced: Int!
    }
    var touchPoints = [touchPoint<Any>]()
    var sections = [UIView]()
    
    struct assocSectionStruct {
        var image: UIImageView!
        var section: Int!
    }
    var assocStructs = [assocSectionStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: UIImage(named: "air-land-water.png")!)
        let itemView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        //itemView.backgroundColor = .darkGray
        view.addSubview(itemView)
        
        let skyView = UIView(frame: CGRect(x: 0, y: 210, width: view.frame.width, height: 220))
        //skyView.backgroundColor = .brown
        skyView.alpha = 0.5
        view.addSubview(skyView)
        sections.append(skyView)
        
        let waterView = UIView(frame: CGRect(x: 0, y: 430, width: 830, height: 180))
        //waterView.backgroundColor = .brown
        waterView.alpha = 0.5
        view.addSubview(waterView)
        sections.append(waterView)
        
        let landView = UIView(frame: CGRect(x: 600, y: 610, width: 450, height: 150))
        //landView.backgroundColor = .purple
        landView.alpha = 0.5
        view.addSubview(landView)
        sections.append(landView)

        
        timerLabel = UILabel.headerLabel(xPoint: 100, text: "Time: 0")
        view.addSubview(timerLabel)
        
        scoreLabel = UILabel.headerLabel(xPoint: view.frame.width-200, text: "Score: 0")
        view.addSubview(scoreLabel)
        
        for i in 1...15 {
            imageArray.append(i)
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.counter();
        }
        diffSettings()
        genImages()

    }
    
    func genImages() {
        
        //xPos = 30
        var tempArray = imageArray
        let numRemove = 15-numItems
        for _ in 0..<numRemove {
            let rand = Int.random(in: 0..<tempArray.count)
            tempArray.remove(at: rand)
        }
        for i in 1...numItems {
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
            let rand = Int.random(in: 0..<tempArray.count)

            let image = UIImageView(frame: CGRect(x: xPos, y: 100, width: imageWH, height: imageWH))
            image.image = UIImage(named: "\(tempArray[rand])-1.png")
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(gesture)
            image.tag = i
            itemArray.append(image)
            view.addSubview(image)
            
            if (tempArray[rand] < 6) {
                assocStructs.append(assocSectionStruct(image: image, section: 0))
            }
            if (tempArray[rand] > 5 && tempArray[rand] < 11) {
                assocStructs.append(assocSectionStruct(image: image, section: 1))
            }
            if (tempArray[rand] > 10) {
                assocStructs.append(assocSectionStruct(image: image, section: 2))
            }
            
            tempArray.remove(at: rand)

            xPos += xIncr
        }
    }
    
    func diffSettings() {
        
        switch difficulty {
        case 1:
            numItems = 8
            remainTime = 60
            xPos = 50
            imageWH = 100
            xIncr = 120
        case 2:
            numItems = 10
            remainTime = 45
            xPos = 20
            imageWH = 80
            xIncr = 100
        case 3:
            numItems = 12
            remainTime = 30
            xPos = 50
            imageWH = 60
            xIncr = 80
        default:
            numItems = 8
            remainTime = 60
            xPos = 30
            imageWH = 60
        }
    }
    
    @objc func counter() {
        
        if (remainTime <= 0) {
            
            self.timer.invalidate()
            let alertController = UIAlertController(title: "Ran out of time!", message: "GAME OVER", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Play Again?", style: .default, handler: {action in
                //self.startOver()
                //self.timer.invalidate()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        checkTouch()
        
        remainTime -= 1
        timeKeeper += 1
        timerLabel.text = "Timer: \(remainTime)"
        timerLabel.frame = CGRect(x: 100, y: 700, width: timerLabel.intrinsicContentSize.width, height: timerLabel.intrinsicContentSize.height)
    }
    
    func checkTouch() {
        var assocSection = -1
        
        for item in touchPoints {
            let timeDiff = timeKeeper - item.timePlaced
            if (timeDiff > 0 && timeDiff < 2) { //user has placed an answer
                for item2 in assocStructs {
                    if (item.image.tag == item2.image.tag) {
                        assocSection = item2.section
                    }
                }
                for i in 0..<sections.count {
                    if (i == assocSection) {
                        if (sections[i].frame.intersects(item.image.frame) || item.image.frame.intersects(sections[i].frame)) {
                            score += 5
                            scoreLabel.text = "Score: \(score)"
                            scoreLabel.frame = CGRect(x: view.frame.width-200, y: 700, width: scoreLabel.intrinsicContentSize.width, height: scoreLabel.intrinsicContentSize.height)
                        }
                    }
                }
                
            }
//            print("Items placed: \(item.image.tag)")
//            print("Total items in array: \(touchPoints.count)")
        }
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        var recognizerFrame = recognizer.view?.frame
        var tempFrame = recognizerFrame
        recognizerFrame?.origin.x += translation.x
        recognizerFrame?.origin.y += translation.y
        // Check if UIImageView is completely inside its superView
        if view.bounds.contains(recognizerFrame!) {
            recognizer.view?.frame = recognizerFrame!
        }
        else {
            // Check vertically
            if (recognizerFrame?.origin.y)! < view.bounds.origin.y {
                recognizerFrame?.origin.y = 0
            }
            else if (recognizerFrame?.origin.y)! + (recognizerFrame?.size.height)! > view.bounds.size.height {
                tempFrame?.origin.y = view.bounds.size.height - (recognizerFrame?.size.height)!
                recognizerFrame?.origin.y = (tempFrame?.origin.y)!
            }

            // Check horizantally
            if (recognizerFrame?.origin.x)! < view.bounds.origin.x {
                recognizerFrame?.origin.x = 0
            }
            else if (recognizerFrame?.origin.x)! + (recognizerFrame?.size.width)! > view.bounds.size.width {
                tempFrame?.origin.x = view.bounds.size.width - (recognizerFrame?.size.width)!
                recognizerFrame?.origin.y = (tempFrame?.origin.y)!
            }
        }

        // Reset translation so that on next pan recognition
        // we get correct translation value
        recognizer.setTranslation(CGPoint(x: CGFloat(0), y: CGFloat(0)), in: view)
//        if ((recognizerFrame!.intersects(recognizer.view!.frame)) || (recognizer.view!.frame.intersects(recognizerFrame!))) {
//            print("They intersect! ")
//        }
        var itemAlreadyExists = false
        for i in 0..<touchPoints.count {
            if (touchPoints[i].image == recognizer.view!) {
                touchPoints.remove(at: i)
                touchPoints.append(touchPoint(image: recognizer.view!, timePlaced: timeKeeper))
                itemAlreadyExists = true
            }
        }
        if (!itemAlreadyExists) {
            let tempTouch = touchPoint<Any>(image: recognizer.view!, timePlaced: timeKeeper)
            touchPoints.append(tempTouch)
        }
        
    }
}

extension UILabel {
    class func headerLabel(xPoint: CGFloat, text: String) -> UILabel {
        let givenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 26.5))
        givenLabel.textAlignment = .center
        givenLabel.font = UIFont.preferredFont(forTextStyle: .body)
        givenLabel.font = givenLabel.font.withSize(30)
        givenLabel.textColor = .purple
        givenLabel.text = text
        givenLabel.frame = CGRect(x: xPoint, y: 700, width: givenLabel.intrinsicContentSize.width, height: givenLabel.intrinsicContentSize.height)
        
        return givenLabel
    }
}

