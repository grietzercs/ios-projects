//
//  Assessment.swift
//  assignment1
//
//  Created by Colden on 5/5/22.
//

import Foundation
import UIKit

class Assessment {
//    var assignmentsPoints: [Int]!
//    var assignmentsMax: [Int]!
//    var assignmentsWeight: [Int]!
//
//    var midTermPoints: [Int]!
//    var midTermMax: [Int]!
//    var midTermWeight: [Int]!
//
//    var finalPoints: [Int]!
//    var finalPointsMax: [Int]!
//    var finalPointsWeight: [Int]!
    
    var scoredPoints: Int!
    var maxPoints: Int!
    var pointWeight: Int!
    
    init(_ givenPoints: Int, _ max: Int, _ pointWeight: Int) {
        self.scoredPoints = givenPoints
        self.maxPoints = max
        self.pointWeight = pointWeight
    }
    
//    func init(assignmentPoints: Int, assignmentMax: Int, assignmentWeight: Int, midTermPoint: Int, midMax: Int, midWeight: Int, finPoints: Int, finMax: Int, finWeight: Int) {
//        assignmentsPoints = assignmentPoints
//        assignmentsMax = assignmentMax
//        assignmentsWeight = assignmentMax
//
//        midTermPoints = midTermPoint
//        midTermMax = midMax
//        midTermWeight = midWeight
//
//        finalPoints = finPoints
//        finalPointsMax = finMax
//        finalPointsWeight = finWeight
//    }
    
    func getGrade() -> Double {
        if (self.pointWeight == 0) {
            return 0
        }
        return (Double(self.scoredPoints) / Double(self.maxPoints)) * Double(self.pointWeight)
    }
}
