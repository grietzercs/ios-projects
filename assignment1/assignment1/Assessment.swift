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
    
    func initialize(points: Int, max: Int, weight: Int) {
        scoredPoints = points
        maxPoints = max
        pointWeight = weight
    }
}
