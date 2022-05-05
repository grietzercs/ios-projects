

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
}
