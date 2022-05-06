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
    var courses = [Course?]()
    var grades = [UIImageView?]()
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
    
        grades.append(course1Grade)
        grades.append(course2Grade)
        grades.append(course3Grade)
        grades.append(course4Grade)
        
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
    
    func alert(givenTitle: String, givenMessage: String) {
        let alertController = UIAlertController(title: givenTitle, message: givenMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addingCourse(_ sender: UIButton) {
        
        for item in courses {
            if (item?.courseName == courseNameText.text!) {
                alert(givenTitle: "Input Error", givenMessage: "Course name already exists")
                return
            }
        }
        
        if (courses.count == 4) {
            alert(givenTitle: "Max Courses Reached", givenMessage: "Four courses are the max input, please delete some existing course(s)")
            return
        } else {
            let assignments = Assessment(Int(scoredPoints1.text!)!, Int(maxPoints1.text!)!, Int(weight1.text!)!)
            let midTerm = Assessment(Int(scoredPoints2.text!)!, Int(maxPoints2.text!)!, Int(weight2.text!)!)
            let finals = Assessment(Int(scoredPoints3.text!)!, Int(maxPoints3.text!)!, Int(weight3.text!)!)
            let tempCourse = Course(courseNameText.text!, Int(creditHoursText!.text!)!, assignments, midTerm, finals)
            
            let sum = assignments.pointWeight + midTerm.pointWeight + finals.pointWeight
            if (sum != 100) {
                alert(givenTitle: "Input Error", givenMessage: "Entered percentages do not add to 100")
                return
            }
            let result1 = assignments.maxPoints - assignments.scoredPoints
            let result2 = midTerm.maxPoints - midTerm.scoredPoints
            let result3 = finals.maxPoints - finals.scoredPoints
            let resultArray = [result1, result2, result3]
            for item in resultArray {
                if (item < 0) {
                    alert(givenTitle: "Input Error", givenMessage: "One of the entered Max points is less than a Point value")
                    return
                }
            }
            
            courses.append(tempCourse)
            populateChalkboard()
            if (courses.count > 0) {
                deleteCourseButton.isUserInteractionEnabled = true
                deleteCourseButton.isHidden = false
            }
        }
    }
    
    @IBAction func deleteCourse(_ sender: UIButton) {
        var index = Int(deleteCourseID!.text!)
        index! -= 1
        if (courses.count > index! && index!>=0) {
            courses.remove(at: index!)
        }
        if (courses.count > 0) {
            deleteCourseButton.isHidden = false
        } else {
            deleteCourseButton.isHidden = true
        }
        populateChalkboard()
    }
    
    func populateChalkboard() {
        for i in 0...3 {
            if (courses.count > i) {
                courseNumbers[i].isHidden = false
                let testOutput = courses[i]!.courseName!
                print("Test output: \(testOutput)")
                courseNames[i].text = "\(courses[i]!.courseName!)"
                courseNames[i].isHidden = false
                courseGrades[i].image = courses[i]?.getLetterGrade()
                courseGrades[i].isHidden = false
            } else {
                courseNumbers[i].isHidden = true
                courseNames[i].isHidden = true
                courseGrades[i].isHidden = true
            }
        }
    }
    
    func updateGPA() -> Double {
        var totalPoints = 0
        var totalCredits = 0
        if (courses.count > 0) {
            for item in courses {
                totalPoints += (item?.getGradeScale())!
                totalCredits += (item?.creditHours)!
            }
        }
        let tempGPA = Double(totalPoints) / Double(totalCredits)
        switch true {
        case tempGPA > 3.0:
            totalGPA.textColor = .green
        case tempGPA > 2.0:
            totalGPA.textColor = .orange
        default:
            totalGPA.textColor = .red
        }
        
        return tempGPA
    }

}

