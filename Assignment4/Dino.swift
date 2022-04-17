////
////  Dino.swift
////  Assignment4
////
////  Created by Colden on 4/16/22.
////
//
//import Foundation
//import UIKit
//import SpriteKit
//
//class Dino: SKSpriteNode -> SKSpriteNode () {
//
////    var scale = 1.0
////    var name: String?
////    var position = CGPoint(x: 0, y: 0)
//
//    init() {
//        let texture = SKTexture(imageNamed: "Dino1")
//        super.init(texture: texture, color: .clear, size: texture.size())
//    }
//
//    struct PhysicsCategories {
//        static let Dino1: UInt32 = 20
//        static let Dino2: UInt32 = 22
//        static let Dino3: UInt32 = 24
//        static let Dino4: UInt32 = 26
//
//        static let Player: UInt32 = 1
//        static let Rock: UInt32 = 4
//        static let Border: UInt32 = 10
//        static let Obstacle: UInt32 = 12
//    }
//
//    var dino: SKSpriteNode!
//    var category: PhysicsCategories!
//    var spriteName = ""
//
//    convenience init(position: CGPoint, scale: Double = 1.0, givenName: String) {
//        self.init()
//
////        var num = name[name.index(name.startIndex, offsetBy: 4)]
////        dinoName = "Dino\(num)"
//        //super.init(imageNamed: "\(givenName)")
//        //super.init(imageNamed: givenName)
//
//        spriteName = givenName
//        print("Dino name: \(givenName)")
//
//        dino = SKSpriteNode(imageNamed: "\(spriteName)")
//        dino.setScale(scale)
//        dino.position = position
//        dino.physicsBody = SKPhysicsBody(circleOfRadius: dino.frame.width/2)
//        dino.physicsBody?.affectedByGravity = false
//        dino.physicsBody?.collisionBitMask = PhysicsCategories.Border | PhysicsCategories.Player
//        dino.physicsBody?.contactTestBitMask = dino.physicsBody!.collisionBitMask
//
//        switch spriteName {
//        case "Dino1":
//            dino.physicsBody?.categoryBitMask = PhysicsCategories.Dino1
//        case "Dino2":
//            dino.physicsBody?.categoryBitMask = PhysicsCategories.Dino2
//        case "Dino3":
//            dino.physicsBody?.categoryBitMask = PhysicsCategories.Dino3
//        case "Dino4":
//            dino.physicsBody?.categoryBitMask = PhysicsCategories.Dino4
//        default:
//            dino.physicsBody?.categoryBitMask = PhysicsCategories.Dino1
//        }
//        
//        //super.init(imageNamed: "\(givenName).png")
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func moveUpDown(yPos: Int = 0) {
//
//        var temp = yPos
//
//        let direction = Int.random(in: 0...1)
//        if (direction == 0) {
//            temp = -1000
//        } else {
//            temp = 1000
//        }
//
//        let mv = SKAction.moveBy(x: 0, y: CGFloat(temp), duration: 6)
//        dino.run(mv, withKey: "\(spriteName)")
//    }
//
//    func moveLeftRight(xPos: Int = 0) {
//
//        var temp = xPos
//
//        let direction = Int.random(in: 0...1)
//        if (direction == 0) {
//            temp = -1000
//        } else {
//            temp = 1000
//        }
//
//        let mv = SKAction.moveBy(x: CGFloat(temp), y: 0, duration: 6)
//        dino.run(mv, withKey: "\(spriteName)")
//    }
//
//    func moveAllDir(xPos: Int, yPos: Int) {
//
//        var tempX = xPos
//        var tempY = yPos
//
//        let directionX = Int.random(in: 0...1)
//        let directionY = Int.random(in: 0...1)
//        if (directionX == 0) {
//            tempX = -1000
//        } else {
//            tempX = 1000
//        }
//        if (directionY == 0) {
//            tempY = -1000
//        } else {
//            tempY = 1000
//        }
//
//        let mv = SKAction.moveBy(x: CGFloat(tempX), y: CGFloat(tempY), duration: 6)
//        dino.run(mv, withKey: "\(spriteName)")
//    }
//}
//
