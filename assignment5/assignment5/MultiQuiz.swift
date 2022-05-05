

import UIKit
import MultipeerConnectivity
import CoreMotion

class MultiQuiz: UIViewController, MCSessionDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var questionBox: UITextView!
    
    @IBOutlet weak var timeTextView: UITextView!
    @IBOutlet weak var QuestionPlace: UITextView!
    @IBOutlet weak var scoreText: UITextView!
    
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    @IBOutlet weak var p1Ans: UILabel!
    @IBOutlet weak var p2Ans: UILabel!
    @IBOutlet weak var p3Ans: UILabel!
    @IBOutlet weak var p4Ans: UILabel!
    
    @IBOutlet weak var p1Score: UILabel!
    @IBOutlet weak var p2Score: UILabel!
    @IBOutlet weak var p3Score: UILabel!
    @IBOutlet weak var p4Score: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
    var coreMotion = CMMotionManager()
    var mcSession: MCSession!
    var peerID: MCPeerID!
    
    var timer = Timer()
    var currentTime = 20
    
    var confirm = false
    var givenAns: String!
    var correctAns: String!
    var score = 0
    
    var questionNum = 0
    var defaultButtonColor: UIColor!
    
    var totalQuestions = 0
    var dataFile = "data"
    var done = false
    
    struct Questions : Codable {
        var number: Int
        var questionSentence: String
        struct Options : Codable{
            var A: String
            var B: String
            var C: String
            var D: String
        }
        var options: Options
        var correctOption: String
    }
    
    struct Quiz : Codable {
        var numberOfQuestions: Int
        var questions: [Questions]
        var topic: String
    }
    
    var jsonData: Quiz!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in self.counter()
        }
        parseJson()
        initializeValues()
        coreMotion.deviceMotionUpdateInterval = 1/60
        coreMotion.startDeviceMotionUpdates(using: .xArbitraryZVertical)
        //defaultButtonColor = optionA.tintColor
        
        // Do any additional setup after loading the view.
    }
    
    func initializeValues() {
        questionNum = 0
        currentTime = 20
        totalQuestions = jsonData.numberOfQuestions
        parseJson()
        score = 0
        defaultButtonColor = optionA.tintColor
        correctAns = jsonData.questions[0].correctOption
        setButtonText()
        questionBox.text = jsonData.questions[0].questionSentence
        QuestionPlace.text = "Question: 1/\(totalQuestions)"
        
        self.p1Ans.text = "--"; self.p1Score.text = "0"
        self.p2Ans.text = "--"; self.p2Score.text = "0"
        self.p3Ans.text = "--"; self.p3Score.text = "0"
        self.p4Ans.text = "--"; self.p4Score.text = "0"
    }
    
    @IBAction func gameRestart(_ sender: Any) {
        dataFile = "data2"
        initializeValues()
    }
    
    func counter() {
        updatePos()
        if (done) {
            //restartButton.isHidden = false
            timer.invalidate()
//            for i in 0..<session.connectedPeers.count {
//                if Int(arrayOfUserScores[0].text!)! >= Int(arrayOfUserScores[i+1].text!)! {
//                    winLabel.text = "YOU WIN!"
//                    return
//                }
//            }
        } else {
            if currentTime == 0 {
                if (givenAns == correctAns) {
                    print("Correct Answer!")
                    score += 1
                    scoreText.text = "Score: \(score)"
                    p1Score.text = String("\(score)")
                    
                    let currentScore = NSKeyedArchiver.archivedData(withRootObject: score)
                    do {
                        try mcSession.send(currentScore, toPeers: mcSession.connectedPeers, with: .unreliable)
                    }
                    catch let outputError {
                        print ("Error in sending Score \(outputError)")
                    }
                }
                
                if (currentTime == 1) {
                    done = true
                }
                clearButtons()
                confirm = false
                questionNum += 1
                
                correctAns = jsonData.questions[questionNum].correctOption
                setButtonText()
                questionBox.text = jsonData.questions[questionNum].questionSentence
                QuestionPlace.text = "Question: \(questionNum+1)/\(totalQuestions)"
                
                currentTime = 20
                
            } else {
                currentTime -= 1
                timeTextView.text = "Time: \(currentTime)"
            }
        }
    }

    func parseJson() {
        
        let url = Bundle.main.url(forResource: dataFile, withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            let decoder = JSONDecoder()
            jsonData = try decoder.decode(Quiz.self, from: data!)
            print("First question answer A: \(jsonData.questions[0].options.A)")
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    
    @IBAction func APressed(_ sender: UIButton) {
        buttonSelection(sender: sender)
    }
    
    @IBAction func BPressed(_ sender: UIButton) {
        buttonSelection(sender: sender)
    }
    
    @IBAction func CPressed(_ sender: UIButton) {
        buttonSelection(sender: sender)
    }
    
    @IBAction func DPressed(_ sender: UIButton) {
        buttonSelection(sender: sender)
    }
    
    func buttonSelection(sender: UIButton) {
        print("Reached button press")
        if (!confirm) {
            if sender.tag == 1 {
                print("Current confirm value: \(confirm)")
                confirm = true
                sender.tintColor = UIColor.green
                setChoice()
            } else {
                print("Reach this?")
                clearButtons()
                sender.tintColor = UIColor.red
                sender.tag = 1
            }
        }
    }
    
    func setChoice() {
        //var givenAns = ""
        switch 1 {
        case optionA.tag:
            givenAns = "A"
        case optionB.tag:
            givenAns = "B"
        case optionC.tag:
            givenAns = "C"
        case optionD.tag:
            givenAns = "D"
        default:
            givenAns = ""
        }
        
        setPublicAns()
        print("Correct Answer: \(correctAns) Given Answer: \(givenAns)")
    }
    
    func setPublicAns() {
        p1Ans.text = givenAns
        
        let sendingAns = NSKeyedArchiver.archivedData(withRootObject: givenAns)
        do {
            try mcSession.send(sendingAns, toPeers: mcSession.connectedPeers, with: .unreliable)
        }
        catch let err {
            print ("Error in sending data \(err)")
        }
    }
    
    func setButtonText() {
        optionA.setTitle(jsonData.questions[questionNum].options.A, for: .normal)
        optionB.setTitle(jsonData.questions[questionNum].options.B, for: .normal)
        optionC.setTitle(jsonData.questions[questionNum].options.C, for: .normal)
        optionD.setTitle(jsonData.questions[questionNum].options.D, for: .normal)
    }
    
    func clearButtons() {
        optionA.tintColor = defaultButtonColor
        optionA.tag = 0
        optionB.tintColor = defaultButtonColor
        optionB.tag = 0
        optionC.tintColor = defaultButtonColor
        optionC.tag = 0
        optionD.tintColor = defaultButtonColor
        optionD.tag = 0
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        print("Reaching session function")
        
        DispatchQueue.main.async(execute: {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Deafult")
        }
        })
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        DispatchQueue.main.async(execute: {
            if let sentAns = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
                if sentAns == "Restart" {
                    self.initializeValues()
                    return
                }
                for i in 0..<session.connectedPeers.count {
                    if self.mcSession.connectedPeers[i] == self.peerID {
                        self.p1Ans.text = sentAns
                        self.p2Ans.text = sentAns
                        self.p3Ans.text = sentAns
                        self.p4Ans.text = sentAns
                    }
                }
            }

            if let sentInt = NSKeyedUnarchiver.unarchiveObject(with: data) as? Int{
                for i in 0..<session.connectedPeers.count {
                    if session.connectedPeers[i] == peerID {
                        self.p1Score.text = String(sentInt)
                        self.p2Score.text = String(sentInt)
                        self.p3Score.text = String(sentInt)
                        self.p4Score.text = String(sentInt)
                    }
                }
            }
        })
    }
    
    @objc func updatePos(){
        
        if let data = coreMotion.deviceMotion {
            let attitude = data.attitude
            let userAcceleration = data.userAcceleration
            
            if (attitude.roll > 1.0){
                buttonSelection(sender: optionD)
            }
            
            if(attitude.roll < -1.0){
                buttonSelection(sender: optionC)
            }
            
            if(attitude.pitch > 1.0){
                buttonSelection(sender: optionA)
            }
            
            if(attitude.pitch < -1.0){
                buttonSelection(sender: optionB)
            }
            
            if(userAcceleration.z < -1.0){
                setChoice()
                switch 1 {
                case optionA.tag:
                    buttonSelection(sender: optionA)
                case optionB.tag:
                    buttonSelection(sender: optionB)
                case optionC.tag:
                    buttonSelection(sender: optionC)
                case optionD.tag:
                    buttonSelection(sender: optionD)
                default:
                    givenAns = ""
                }
            }
        }
    }
    
    //Randomly choose answer when shake
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            let randChoice = Int.random(in: 0...2)
            
            switch randChoice{
            case 0:
                APressed(optionA)
            case 1:
                BPressed(optionB)
                
            case 2:
                CPressed(optionC)
                
            default:
                DPressed(optionD)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mcSession.disconnect()
    }
}
