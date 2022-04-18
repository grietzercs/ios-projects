//
//  GameOverScene.swift
//  Assignment4
//
//  
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    var highestScores: [Int]?
    var score: Int?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Avenir-Bold")
        gameOverLabel.text = ("Game Over")
        gameOverLabel.fontSize = 60
        
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(gameOverLabel)
    }
    
    override func didMove(to view: SKView) {
        
        let scoreLabel = SKLabelNode(fontNamed: "Avenir-Bold")
        scoreLabel.text = ("Your Score is: \(score!)")
        scoreLabel.fontSize = 35
        
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        self.addChild(scoreLabel)
        
        let tempScore = score
        highestScores = self.addScore(score: tempScore!, intArray: highestScores ?? [0, 0, 0])
        
//        if ((grid[i][j]?.frame.intersects(star.frame)) != nil) {
//            grid[i][j] = nil
//        }

        for i in 0..<highestScores!.count {
            let keptScores = SKLabelNode(fontNamed: "Avenir-Bold")
            let scorePos = i+1
            keptScores.text = ("Score \(scorePos): \(highestScores![i])")
            keptScores.fontSize = 25

            keptScores.position = CGPoint(x: size.width/2, y: scoreLabel.position.y - 40 - CGFloat(30*i))
            self.addChild(keptScores)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let transition = SKTransition.moveIn(with: .right, duration: 1)
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = .aspectFill
        self.view?.presentScene(newScene, transition: transition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addScore(score: Int, intArray: [Int]) -> [Int] {
        
        var returnArray = intArray
        var added = false
        if(returnArray.count == 0) {
            returnArray.append(score)
        } else {
            for i in stride(from: 0, to: returnArray.count, by: 1) {
                if (score > returnArray[i]) {
                    returnArray.insert(score, at: i) //insert and shift the rest of the scores (O(n))
                    added = true
                }
            }
            if (returnArray.count < 3 && added == false) {
                returnArray.append(score)
                added = true
            }
        }
        
        return returnArray
    }
    
}
