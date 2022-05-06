

import UIKit
import CoreMotion
import MultipeerConnectivity


class SingleQuiz: UIViewController {

    @IBOutlet weak var questionBox: UITextView!
    
    @IBOutlet weak var timeTextView: UITextView!
    @IBOutlet weak var QuestionPlace: UITextView!
    @IBOutlet weak var scoreText: UITextView!
    
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    @IBOutlet weak var restartButton: UIButton!
    
    
    var coreMotion = CMMotionManager()
    var timer = Timer()
    var currentTime = 20
    
    var confirm = false
    var givenAns: String!
    var correctAns: String!
    var score = 0
    
    var processedQuestions = 0
    var totalQuestions = 0
    var dataFile = "data"
    
    var questionNum = 0
    var defaultButtonColor: UIColor!
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
        QuestionPlace.text = "Question: 1/4"
    }
    
    @IBAction func gameRestart() {
        dataFile = "data2"
        initializeValues()
    }
    
    func counter() {
        updatePos()
        if (done) {
            timer.invalidate()
        } else {
            if currentTime == 0 {
                if (givenAns == correctAns) {
                    print("Correct Answer!")
                    score += 1
                    let text = "Score: \(score)"
                    scoreText.text = text
                }
 
                questionNum += 1
                
                if (questionNum != totalQuestions) {
                    correctAns = jsonData.questions[questionNum].correctOption
                    questionBox.text = jsonData.questions[questionNum].questionSentence
                    setButtonText()
                    QuestionPlace.text = "Question: \(questionNum+1)/\(totalQuestions)"
                    clearButtons()
                    confirm = false
                } else {
                    finishGame()
                }
                
                currentTime = 20
                processedQuestions += 1
                

            } else {
                currentTime -= 1
                timeTextView.text = "Time: \(currentTime)"
            }
        }
    }
    
    func finishGame() {
        
        timer.invalidate()
        let alertController = UIAlertController(title: "Game Over", message: "Would you like to proceed to the next quiz?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action) -> Void in
            self.gameRestart()
        }))
        alertController.addAction(UIAlertAction(title: "Exit", style: .default, handler: {(action) -> Void in
            super.didMove(toParent: self.parent)
        }))
        self.present(alertController, animated: true, completion: nil)
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
        
        print("Correct Answer: \(correctAns) Given Answer: \(givenAns)")
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
}
