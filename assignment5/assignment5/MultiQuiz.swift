

import UIKit
import MultipeerConnectivity

class MultiQuiz: UIViewController, MCSessionDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var questionBox: UITextView!
    
    @IBOutlet weak var timeTextView: UITextView!
    @IBOutlet weak var QuestionPlace: UITextView!
    @IBOutlet weak var scoreText: UITextView!
    
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    @IBOutlet var userAnswers: [UILabel]!
    @IBOutlet var userScores: UILabel!
    
    @IBOutlet weak var p1Ans: UILabel!
    @IBOutlet weak var p2Ans: UILabel!
    @IBOutlet weak var p3Ans: UILabel!
    @IBOutlet weak var p4Ans: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
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
        //defaultButtonColor = optionA.tintColor
        
        // Do any additional setup after loading the view.
    }
    
    func initializeValues() {
        defaultButtonColor = optionA.tintColor
        correctAns = jsonData.questions[0].correctOption
        setButtonText()
        questionBox.text = jsonData.questions[0].questionSentence
        QuestionPlace.text = "Question: 1/4"
        
        for i in 0..<mcSession.connectedPeers.count {
            userAnswers[i+1].text = "0"
        }
    }
    
    func counter() {
        if (currentTime == 0 && questionNum == 3) {
            //restartButton.isHidden = false
            timer.invalidate()
        } else {
            if currentTime == 0 {
                clearButtons()
                confirm = false
                questionNum += 1
                
                correctAns = jsonData.questions[questionNum].correctOption
                setButtonText()
                questionBox.text = jsonData.questions[questionNum].questionSentence
                QuestionPlace.text = "Question: \(questionNum+1)/4"
                
                currentTime = 20
                
                if (givenAns == correctAns) {
                    print("Correct Answer!")
                    score += 1
                    scoreText.text = "Score: \(score)"
                    userAnswers[0].text = String("\(score)")
                    
                    let currentScore = NSKeyedArchiver.archivedData(withRootObject: score)
                    do {
                        try mcSession.send(currentScore, toPeers: mcSession.connectedPeers, with: .unreliable)
                    }
                    catch let outputError {
                        print ("Error in sending Score \(outputError)")
                    }
                }
            } else {
                currentTime -= 1
                timeTextView.text = "Time: \(currentTime)"
            }
        }
    }

    func parseJson() {
        
        let url = Bundle.main.url(forResource: "data", withExtension: "json")
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
        userAnswers[0].text = givenAns
        
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
                        self.userAnswers[i+1].text = sentAns

                    }
                }
            }

            if let sentInt = NSKeyedUnarchiver.unarchiveObject(with: data) as? Int{
                for i in 0..<session.connectedPeers.count {
                    if session.connectedPeers[i] == peerID {
                        self.userAnswers[i+1].text = String(sentInt)
                    }
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mcSession.disconnect()
    }
}
