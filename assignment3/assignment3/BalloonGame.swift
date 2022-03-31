//
//  ViewController.swift
//  testAnimation
//
//  Created by Colden on 3/26/22.
//
import AVFoundation
import UIKit

class BalloonGame: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    
    var newPos = 0
    var array: [UIButton] = []
    let frameWidth = 1024
    let frameHeight = 768
    var arrayCount: Int = 0
    
    var score: Int = 0
    var timer = Timer()
    var timeKeeper = 0
    
    var timerLabel: UILabel!
    var scoreLabel: UILabel!
    
    var difficulty = 0
    var remainTime: Int = 60
    
    var animationTime: Int = 10
    var numBalloons: Int = 0
    
    var xCoords: [Int] = []
    var tempX = 0
    
    var bonusTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.difficulty = 0

        diffSettings()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "sky-background.png")!)
        
        var xPos = 240
        
        let frameWidth = self.view.frame.width/2
        let frameHeight = self.view.frame.height/2
        let fullFrameWidth = self.view.frame.width
        let defaultFrame = CGRect(x: 0, y: 0, width: 300, height: 26.5)
        
        //Create labels for game
        timerLabel = UILabel.headerLabel(frame: defaultFrame, text: "Time: 0")
        timerLabel.center = CGPoint(x: 100, y: 50)
        view.addSubview(timerLabel)
        
        scoreLabel = UILabel.headerLabel(frame: defaultFrame, text: "Score: 0")
        scoreLabel.center = CGPoint(x: view.frame.width-200, y: 50)
        view.addSubview(scoreLabel)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.counter();
            self.generateBalloon();
            //self.genSpecBalloons()
        }

        
        self.view = view
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        if self.isMovingFromParent {
            timer.invalidate();
        }
    }
    
    func diffSettings() {
        
        
        switch difficulty {
        case 1:
            remainTime = 60
            animationTime = 10
            numBalloons = 0
        case 2:
            remainTime = 45
            animationTime = 7
            numBalloons = 1
        case 3:
            remainTime = 30
            animationTime = 5
            numBalloons = 2
        default:
            remainTime = 60
            animationTime = 10
            numBalloons = 0
        }
    }
    
    func postScore() {
        let userDefaults = UserDefaults.standard
        
        var order: String!
        let gameType = "BalloonGame"
        var diff: String!
        switch difficulty {
        case 1:
            diff = "Easy"
        case 2:
            diff = "Medium"
        case 3:
            diff = "Hard"
        default:
            diff = "Easy"
        }
        
        var tempArray = [String]()
        tempArray = userDefaults.stringArray(forKey: "scores")!
        if (tempArray != nil) {
            
            let tempInt = tempArray.count
            order = String(tempInt)
            let inputString = "\t \(order)\t\t \(gameType)\t\t \(diff)\t\t \(score)"
            tempArray.append(inputString)
            userDefaults.set(tempArray, forKey: "scores")
        } else {
            
            let inputString = "\t 1\t\t \(gameType)\t\t \(diff)\t\t \(score)"
            var newArray = [String]()
            newArray.append(inputString)
            userDefaults.set(newArray, forKey: "scores")
        }
        
    }
    
    @objc func counter() {
        if (remainTime <= 0) {
            
            postScore()
            let alertController = UIAlertController(title: "Ran out of time!", message: "GAME OVER", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Play Again?", style: .default, handler: {action in
                self.startOver()
                self.timer.invalidate()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        remainTime -= 1
        if ((timeKeeper % 20 == 0) && (timeKeeper != 0)) {
            genSpecBalloons()
        }
        if (bonusTime > 0) {
            bonusTime -= 1
        }
        cleanBalloons()
        timeKeeper += 1
        timerLabel.text = "Timer: \(remainTime)"
        timerLabel.frame = CGRect(x: 100, y: 50, width: timerLabel.intrinsicContentSize.width, height: 26.5)
    }
    
    func genSpecBalloons() {

        var tempFrame = CGRect(x: givePos(), y: 612, width: 100, height: 100)
        var balloon = UIButton(frame: tempFrame)
        balloon.setImage(UIImage(named: "color1-4.png"), for: .normal)
        balloon.tag = 998
        balloon.titleLabel!.text = String(timeKeeper)
        array.append(balloon)
        view.addSubview(balloon)
        var tempAnimationTime = animationTime
        
        animationTime = 3
        buttonAnimation(button: balloon)
        
        tempFrame = CGRect(x: givePos(), y: 612, width: 100, height: 100)
        balloon = UIButton(frame: tempFrame)
        balloon.setImage(UIImage(named: "color1-3.png"), for: .normal)
        balloon.tag = 997
        balloon.titleLabel!.text = String(timeKeeper)
        array.append(balloon)
        view.addSubview(balloon)
        
        animationTime = 12
        buttonAnimation(button: balloon)
        animationTime = tempAnimationTime
    }
    
    func generateBalloon() {
        
        var numChance = 0
        var givenPos = 0
        if (numBalloons > 0) {
            
            numChance = Int.random(in: 0...numBalloons)

            for i in 0...numChance {
                
                givenPos = givePos()
                while (givenPos == tempX) {
                    givenPos = givePos()
                }
                tempX  = givenPos
                
                let tempFrame = CGRect(x: givenPos, y: 612, width: 100, height: 100)
                let balloon = UIButton.balloonButton(frame: tempFrame, buttonTitle: timeKeeper)
                array.append(balloon)
                view.addSubview(balloon)
                buttonAnimation(button: balloon)
            }
        } else {
            
            let tempFrame = CGRect(x: givePos(), y: 612, width: 100, height: 100)
            let balloon = UIButton.balloonButton(frame: tempFrame, buttonTitle: timeKeeper)
            array.append(balloon)
            view.addSubview(balloon)
            buttonAnimation(button: balloon)
        }
    }

    func removeBalloon(button: UIButton) {

        if let index = array.firstIndex(of: button){
            array.remove(at: index);

        }
        button.removeFromSuperview()
    }
    
    func cleanBalloons() {

        for balloon in array {

            let timeDiff = timeKeeper - balloon.tag
            if (timeDiff > animationTime) {
                removeBalloon(button: balloon)
            }
        }
    }
    
    func slowBalloons() {
        
        for balloon in array {
            
            if (balloon.tag != 997) {
                
                UIView.animate(withDuration: TimeInterval(15), delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {
                    
                    balloon.frame.origin.y -= 900
                }, completion: nil)
            }
        }
    }
    
    func sanitizeScreen() {

        for balloon in array {

            if let removeIndex = array.firstIndex(of: balloon){
                array.remove(at: removeIndex)
                balloon.removeFromSuperview()
            }
        }
        timeKeeper = 0
        bonusTime = 0
        diffSettings()
        //viewDidLoad()
    }
    
    func startOver() {
        
        for balloon in array {

            if let removeIndex = array.firstIndex(of: balloon){
                array.remove(at: removeIndex)
                balloon.removeFromSuperview()
            }
        }
        timeKeeper = 0
        bonusTime = 0
        diffSettings()
        viewDidLoad()
    }
    
    func buttonAnimation(button: UIButton) {
        
        print("Bonus Time: \(bonusTime)")
        print("Time Keeper")
        
        if (bonusTime > 0) {
            
            UIView.animate(withDuration: TimeInterval(15), delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {
                
                button.frame.origin.y -= 900
                //testButton.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
            }, completion: nil)
        } else {
            
            UIView.animate(withDuration: TimeInterval(animationTime), delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {
                
                button.frame.origin.y -= 900
                //testButton.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
            }, completion: nil)
        }
    }
    
    func givePos() -> Int {
        
        var minX = 100
        let maxY = 924
        
        for i in 0...8 {
            if (minX < maxY) {
                xCoords.append(minX)
                minX += 100
            }
        }
        xCoords.append(100)
        
        //let x = Int.random(in: 100...frameWidth-100)
        let x = Int.random(in: 0...9)
        return xCoords[x]
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        
        let bubblePopSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bubblepop", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: bubblePopSound)
            audioPlayer.play()
        } catch {
            print(error)
        }

        let buttonTitle = sender.titleLabel?.text
        let alertController = UIAlertController(title: buttonTitle, message: "GAME OVER", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Play Again?", style: .default, handler: {action in
            self.startOver()
            self.timer.invalidate()
        }))
        
        if (sender.tag == 998) { //bonus balloon
            bonusTime = 6
            slowBalloons()
        }
        if (sender.tag == 997) { //bad balloon
            self.present(alertController, animated: true, completion: nil)

        }
        
        score += 1
        scoreLabel.text  = "Score: \(score)"
        scoreLabel.frame = CGRect(x: view.frame.width-200, y: 50, width: scoreLabel.intrinsicContentSize.width, height: scoreLabel.intrinsicContentSize.height)
        removeBalloon(button: sender)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = (touches as NSSet).anyObject() as? UITouch else {
            return
        }
       
        let touchLocation = touch.location(in: self.view)
        
        for balloon in array {
            
            if (balloon.layer.presentation()?.hitTest(touchLocation) != nil) {
               buttonPressed(balloon)
            }
        }
    }
}

extension UIButton {
    class func balloonButton(frame: CGRect, buttonTitle: Int) -> UIButton {
        
        let testButton = UIButton(type: .system)
        testButton.frame = frame
        testButton.tag = buttonTitle
        //testButton.tintColor = .brown
        testButton.layer.cornerRadius = 12
        let overlay = UIImage(named: "star.png")
        let overLayImage = UIImageView(image:overlay)
        testButton.setImage(UIImage(named: "color1.png"), for: .normal)
        
        testButton.clipsToBounds = true
        
        let colorPicker = Int.random(in:1...4)
        switch colorPicker {
        case 1:
            testButton.tintColor = .black;
        case 2:
            testButton.tintColor = .blue;
        case 3:
            testButton.tintColor = .green;
        case 4:
            testButton.tintColor = .systemPink;
        default:
            testButton.tintColor = .red;
        }
        
        return testButton
    }
}

extension UILabel {
    class func headerLabel(frame: CGRect, text: String) -> UILabel {
        let givenLabel = UILabel(frame: frame)
        givenLabel.textAlignment = .center
        givenLabel.font = UIFont.preferredFont(forTextStyle: .body)
        givenLabel.font = givenLabel.font.withSize(30)
        givenLabel.textColor = .purple
        givenLabel.text = text
        givenLabel.frame = CGRect(x: 0, y: 0, width: givenLabel.intrinsicContentSize.width, height: givenLabel.intrinsicContentSize.height)
        
        return givenLabel
    }
}
