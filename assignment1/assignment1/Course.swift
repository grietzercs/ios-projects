//
//  Course.swift
//  assignment1
//
//  Created by Colden on 5/5/22.
//

import Foundation
import UIKit

class Course {
    var assignments: Assessment!
    var midTerm: Assessment!
    var finals: Assessment!
    var creditHours: Int!
    var courseName: String!
    
    init(_ name: String, _ credits: Int, _ assignment: Assessment, _ midterm: Assessment, _ final: Assessment) {
        self.courseName = name
        self.creditHours = credits
        self.assignments = assignment
        self.midTerm = midterm
        self.finals = final
    }
    
    func getGradePercent() -> Double {
        let result = self.assignments.getGrade() + self.midTerm.getGrade() + self.finals.getGrade()
        return result
    }
    
    func getPointGrade() -> Int {
        return self.creditHours * self.getGradeScale()
    }
    
    func getGradeScale() -> Int {
        let gradePercentage = self.assignments.getGrade() + self.midTerm.getGrade() + self.finals.getGrade()
        var scale = 0
        switch true {
        case gradePercentage >= 90:
            scale = 4
        case gradePercentage >= 80:
            scale = 3
        case gradePercentage >= 70:
            scale = 2
        case gradePercentage >= 60:
            scale = 1
        default:
            scale = 0
        }
        
        return scale
    }
    
    func getLetterGrade() -> UIImage {
        let images = ["grade_f", "grade_d", "grade_c", "grade_b", "grade_a"]
        let index = self.getGradeScale()
        
        return UIImage(named: "\(images[index])")!
    }
    
}
