//
//  ViewController.swift
//  assignment1
//
//  Created by Colden on 2/18/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var course1Num: UILabel!
    @IBOutlet weak var course2Num: UILabel!
    @IBOutlet weak var course3Num: UILabel!
    @IBOutlet weak var course4Num: UILabel!
    
    @IBOutlet weak var course1Name: UILabel!
    @IBOutlet weak var course2Name: UILabel!
    @IBOutlet weak var course3Name: UILabel!
    @IBOutlet weak var course4Name: UILabel!
    
    @IBOutlet weak var course1Grade: UIImageView!
    @IBOutlet weak var course2Grade: UIImageView!
    @IBOutlet weak var course3Grade: UIImageView!
    @IBOutlet weak var course4Grade: UIImageView!
    
    @IBOutlet weak var totalGPA: UILabel!
    @IBOutlet weak var addCourse: UIButton!
    
    var courseNumbers: [UILabel]!
    var courseNames: [UILabel]!
    var courseGrades: [UIImageView]!
    var assessmentPoints: [UITextField]!
    var assessmentMax: [UITextField]!
    
    @IBOutlet weak var weight1: UITextField!
    @IBOutlet weak var weight2: UITextField!
    @IBOutlet weak var weight3: UITextField!
    
    @IBOutlet weak var maxPoints1: UITextField!
    @IBOutlet weak var maxPoints2: UITextField!
    @IBOutlet weak var maxPoints3: UITextField!
    
    @IBOutlet weak var scoredPoints1: UITextField!
    @IBOutlet weak var scoredPoints2: UITextField!
    @IBOutlet weak var scoredPoints3: UITextField!
    
    @IBOutlet weak var deleteCourseButton: UIButton!
    @IBOutlet weak var courseNameText: UITextField!
    @IBOutlet weak var creditHoursText: UITextField!
    @IBOutlet weak var deleteCourseID: UITextField!
    
    var course: Course!
    var courses: [Course]!
    var assignmentsArray: [Assessment]!
    
    var firstRow: [Any]!
    var secondRow: [Any]!
    var thirdRow: [Any]!
    var fourthRow: [Any]!
    
    var rowArray: [Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseNumbers = [course1Num, course2Num, course3Num, course4Num]
        courseNames = [course1Name, course2Name, course3Name, course4Name]
        courseGrades = [course1Grade, course2Grade, course3Grade, course4Grade]
        assessmentPoints = [scoredPoints1, scoredPoints2, scoredPoints3]
        assessmentMax = [maxPoints1, maxPoints2, maxPoints3]
        
        firstRow = [course1Num, course1Num, course1Grade]
        secondRow = [course2Num, course2Num, course2Grade]
        thirdRow = [course3Num, course3Num, course3Grade]
        fourthRow = [course4Num, course4Num, course4Grade]
        rowArray = [firstRow, secondRow, thirdRow, fourthRow]
        
        for item in courseNumbers {
            item.isHidden = true
        }
        for item in courseNames {
            item.isHidden = true
        }
        for item in courseGrades {
            item.isHidden = true
        }
        totalGPA.isHidden = false
        
        totalGPA.text = "GPA: "
        deleteCourseButton.isUserInteractionEnabled = false
    }
    
    @IBAction func addingCourse(_ sender: UIButton) {
        checkPercentage()
        checkMaxPoints()
        
        if (courses.count == 4) {
            let alertController = UIAlertController(title: "USER ERROR", message: "Four courses are the max input, please delete some existing course(s)", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        } else {
            var assignments: Assessment!
            assignments.initialize(points: Int(scoredPoints1.text!)!, max: Int(maxPoints1.text!)!, weight: Int(scoredPoints1.text!)!)
            var midTerm: Assessment!
            midTerm.initialize(points: Int(scoredPoints2.text!)!, max: Int(maxPoints2.text!)!, weight: Int(scoredPoints2.text!)!)
            var finals: Assessment!
            finals.initialize(points: Int(scoredPoints3.text!)!, max: Int(maxPoints3.text!)!, weight: Int(scoredPoints3.text!)!)
            self.assignmentsArray = [assignments!, midTerm!, finals!]
            course.assessments = assignmentsArray
            course.creditHours = Int(creditHoursText.text!)!
            course.courseName = courseNameText.text!
            pushArray(course: course)
        }
    }
    
    @IBAction func deleteCourse(_ sender: UIButton) {
        var courseID = Int(deleteCourseID.text!)!
        courseID -= 1
        if (courseID > 0 && courseID < 4) {
            popArray(courseID: Int(deleteCourseID.text!)!)
        } else {
            let alertController = UIAlertController(title: "USER ERROR", message: "Please enter course ID between 1 and 4", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func popArray(courseID: Int) {
        switch courseID {
        case 0:
            courses[0] = courses[1]
            courses[1] = courses[2]
            courses[2] = courses[3]
            courses.popLast()
        case 1:
            courses[1] = courses[2]
            courses[2] = courses[3]
            courses.popLast()
        case 2:
            courses[2] = courses[3]
            courses.popLast()
        case 3:
            //let tempCourse = Course
            courses.popLast()
        default:
            print("default switch case reached")
        }
        
    }
    
    func pushArray(course: Course) {
        courses.append(course)
    }
    
//    func updateBoard() {
//        for i in 0...courses.count {
//            for item in rowArray[i] {
//                item.isHidden
//            }
//        }
//    }
    
    func
    
    func checkPercentage() {
        let totalPercentage = Int(weight1.text!)! + Int(weight2.text!)! + Int(weight3.text!)!
        if (totalPercentage != 100) {
            let alertController = UIAlertController(title: "USER ERROR", message: "Percentages do not sum to 100", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func checkMaxPoints() {
        let alertController = UIAlertController(title: "USER ERROR", message: "Input scored points for assessment exceed inputted max points", preferredStyle: .alert)
        
        if (assessmentPoints[0].text! > assessmentMax[0].text! || Int(assessmentPoints[0].text!)! < 0) {
            self.present(alertController, animated: true, completion: nil)
        }
        if (assessmentPoints[1].text! > assessmentMax[1].text! || Int(assessmentPoints[1].text!)! < 0) {
            self.present(alertController, animated: true, completion: nil)
        }
        if (assessmentPoints[2].text! > assessmentMax[2].text! || Int(assessmentPoints[2].text!)! < 0) {
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

