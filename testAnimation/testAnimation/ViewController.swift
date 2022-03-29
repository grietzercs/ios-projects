//
//  ViewController.swift
//  testAnimation
//
//  Created by Colden on 3/26/22.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    var difficulty = "Easy"
    var remainTime: Int = 60
    
    var animationTime: Int = 10
    var numBalloons: Int = 0
    
    var xCoords: [Int] = []
    var tempX = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.difficulty = "Hard"
        print("test")
        print("Difficulty: \(difficulty)")
        diffSettings()
        
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
        scoreLabel.center = CGPoint(x: frameWidth-100, y: 50)
        view.addSubview(scoreLabel)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.counter();
            self.generateBalloon();
            //self.genSpecBalloons()
        }
        
        print(self.view.frame.height)
        print(self.view.frame.width)
        
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
        case("Easy"):
            remainTime = 60
            animationTime = 10
            numBalloons = 0
        case("Medium"):
            remainTime = 45
            animationTime = 7
            numBalloons = 1
        case("Hard"):
            remainTime = 30
            animationTime = 5
            numBalloons = 2
        default:
            remainTime = 60
            animationTime = 10
            numBalloons = 0
        }
    }
    
    @objc func counter() {
        remainTime -= 1
        if ((timeKeeper % 20 == 0) && (timeKeeper != 0)) {
            genSpecBalloons()
            print("SpecOps Balloons generated")
        }
        timeKeeper += 1
        timerLabel.text = "Timer: \(remainTime)"
        timerLabel.frame = CGRect(x: 100, y: 50, width: timerLabel.intrinsicContentSize.width, height: 26.5)
    }
    
    func genSpecBalloons() {

        var tempFrame = CGRect(x: givePos(), y: 612, width: 100, height: 100)
        var balloon = UIButton(frame: tempFrame)
        balloon.setImage(UIImage(named: "color1-3.png"), for: .normal)
        balloon.tag = 51
        array.append(balloon)
        view.addSubview(balloon)
        buttonAnimation(button: balloon)
        
        tempFrame = CGRect(x: givePos(), y: 612, width: 100, height: 100)
        balloon = UIButton(frame: tempFrame)
        balloon.setImage(UIImage(named: "color1-4.png"), for: .normal)
        balloon.tag = 52
        array.append(balloon)
        view.addSubview(balloon)
        buttonAnimation(button: balloon)
    }
    
    func generateBalloon() {
        
        var numChance = 0
        var givenPos = 0
        if (numBalloons > 0) {
            
            numChance = Int.random(in: 0...numBalloons)
            print("numChance: \(numChance)")
            print("numBalloons: \(numBalloons)")
            for i in 0...numChance {
                
                givenPos = givePos()
                while (givenPos == tempX) {
                    givenPos = givePos()
                }
                tempX  = givenPos
                
                let tempFrame = CGRect(x: givenPos, y: 612, width: 100, height: 100)
                let balloon = UIButton.balloonButton(frame: tempFrame, buttonTitle: array.count)
                array.append(balloon)
                view.addSubview(balloon)
                buttonAnimation(button: balloon)
            }
        } else {
            
            let tempFrame = CGRect(x: givePos(), y: 612, width: 100, height: 100)
            let balloon = UIButton.balloonButton(frame: tempFrame, buttonTitle: array.count)
            array.append(balloon)
            view.addSubview(balloon)
            buttonAnimation(button: balloon)
        }
    }

    func removeBalloon(button: UIButton) {

        if let index = array.firstIndex(of: button){
            array.remove(at: index);
            print("Balloon Array: \(array.count)");
        }
        button.removeFromSuperview()
    }
    
    func buttonAnimation(button: UIButton) {
        UIView.animate(withDuration: 10.0, delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {
            
            button.frame.origin.y -= 900
            //testButton.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        }, completion: nil)
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

        let buttonTitle = sender.titleLabel?.text
        let alertController = UIAlertController(title: buttonTitle, message: "Hello, you pressed the button", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        if (sender.tag == 51) {
            self.present(alertController, animated: true, completion: nil)
        }
        if (sender.tag == 52) {
            self.present(alertController, animated: true, completion: nil)
        }
        
        score += 1
        scoreLabel.text  = "Score: \(score)"
        scoreLabel.frame = CGRect(x: 924, y: 50, width: scoreLabel.intrinsicContentSize.width, height: 26.5)
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
//        self.array.append(testButton)
//        print(self.array.count)
    }
}

extension UILabel {
    class func headerLabel(frame: CGRect, text: String) -> UILabel {
        let givenLabel = UILabel(frame: frame)
        givenLabel.textAlignment = .center
        givenLabel.font = UIFont.preferredFont(forTextStyle: .body)
        givenLabel.textColor = .purple
        givenLabel.backgroundColor = .white
        givenLabel.text = text
        givenLabel.frame = CGRect(x: 0, y: 0, width: givenLabel.intrinsicContentSize.width, height: 26.5)
        
        return givenLabel
    }
}
