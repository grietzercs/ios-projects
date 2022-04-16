//
//  GameScene.swift
//  Assignment4
//
//  Created by Colden on 4/10/22.
//

import SpriteKit
import GameplayKit

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var baseBlock: SKSpriteNode!
    var label: SKLabelNode!
    var ground: SKNode!
    var player: SKSpriteNode!
    var timeBlock: SKLabelNode!
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var uiHeart: SKSpriteNode!
    var heartLabel: SKLabelNode!
    var uiStar: SKSpriteNode!
    var starLabel: SKLabelNode!
    var uiRock: SKSpriteNode!
    var rockLabel: SKLabelNode!
    var uiEnergy: SKSpriteNode!
    var energyLabel: SKLabelNode!
    
    //var grid = [[SKSpriteNode]]()
    var grid = [[SKSpriteNode?]](
        repeating: [SKSpriteNode?](repeating: nil, count: 16),
     count: 16
    )
    
    var timer = Timer()
    var passedTime = 0
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    
    struct PhysicsCategory {
        static let Player: UInt32 = 1
        static let Ground: UInt32 = 4
        static let Tile: UInt32 = 8
        static let Border: UInt32 = 10
        static let Obstacle: UInt32 = 12
    }
    
    override func sceneDidLoad() {
        
        label = SKLabelNode(text: "First SpriteKit Game")
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        label.fontSize = 40
        label.fontColor = .red
        addChild(label)
        self.backgroundColor = .white //changing it in gamescene
        
        addPlayer()
        generateGrid()
        
        var xIncr = 32 //used for all rows
        var yIncr = Int((self.size.height)) //used for top rows
        for _ in 0...15 {
            addBorder(xPos: xIncr, yPos: 32)
            addBorder(xPos: xIncr, yPos: (yIncr-32))
            addBorder(xPos: xIncr, yPos: (yIncr-96))
            xIncr += 64
        }
    
        addUI()
        addDinos()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
                    timer in
                    self.counter();
                    //self.generateBalloon();
                    //self.genSpecBalloons()
        }
        
        timeBlock = SKLabelNode(text: "Time: \(passedTime)")
        timeBlock.position = CGPoint(x: 96, y: (self.size.height-160))
        timeBlock.fontSize = 40
        timeBlock.fontColor = .red
        addChild(timeBlock)
    }
    
    func addDinos() {
        
        let posArray = [352, 800]
        
        let dino1 = SKSpriteNode(imageNamed: "dino1")
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("Contact detected")
         
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Obstacle) || (contact.bodyB.categoryBitMask == PhysicsCategory.Obstacle && contact.bodyA.categoryBitMask == PhysicsCategory.Player) || (contact.bodyB.categoryBitMask == PhysicsCategory.Player && contact.bodyA.categoryBitMask == PhysicsCategory.Border) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Border && contact.bodyA.categoryBitMask == PhysicsCategory.Player)) {
            
            print("Player touched block")
            player.removeAction(forKey: "playerMove")
            //gameOver()
        }
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        //let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        //swipeGR.direction = [.right]
        self.view?.addGestureRecognizer(createSwipeGestureRecognizer(for: .up))
        self.view?.addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
        self.view?.addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
        self.view?.addGestureRecognizer(createSwipeGestureRecognizer(for: .down))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let playerLoc = CGPoint(x: player.frame.midX, y: player.frame.midY)
        let rock = SKSpriteNode(imageNamed: "rock")
        rock.position = playerLoc
        rock.setScale(0.5)
    
        let touched = touches.first
        let touchLoc = touched?.location(in: self)
        //let locCoords = CGPoint(x: touchLoc!.x, y: self.size.height-touchLoc!.y)
        
        let offset = touchLoc!-rock.position
        if offset.x < 0 {return}
        addChild(rock)
        
        let direction = offset.normalized()
        let shootDist = direction * 1000
        let travelDist = shootDist + rock.position
        
//            var lastPoint = CGPoint(x: locCoords.x+300, y: locCoords.y+300)
//            var dist = sqrt(pow(lastPoint.x - rock.frame.origin.x,2)+pow(lastPoint.y - rock.frame.origin.y,2))
//            let dur = dist/200
        
        let rockGo = SKAction.move(to: travelDist, duration: 2)
        let doneMoving = SKAction.removeFromParent()
        
        rock.run(SKAction.sequence([rockGo, doneMoving]))
    }
    
    @objc func swiped(_ sender: UISwipeGestureRecognizer) {
        
        var xPos = 0
        var yPos = 0
            
        switch sender.direction {
        case .up:
            yPos = 1000
        case .right:
            xPos = 1000
        case .left:
            xPos = -1000
        case .down:
            yPos = -1000
        default:
            print("No swipe direction detected")
        }
        
        let mv = SKAction.moveBy(x: CGFloat(xPos), y: CGFloat(yPos), duration: 5)
        player.run(mv, withKey: "playerMove")
    }
    
    func addUI() {
        
        uiHeart = SKSpriteNode(imageNamed: "heart")
        uiHeart.position = CGPoint(x: 160, y: 32)
        //uiHeart.zPosition = 0
        heartLabel = SKLabelNode.customLabel()
        addChild(uiHeart)
        uiHeart.addChild(heartLabel)
        
        uiRock = SKSpriteNode(imageNamed: "rock")
        uiRock.position = CGPoint(x: 96, y: 32)
        uiRock.setScale(0.8)
        //uiRock.zPosition = 0
        rockLabel = SKLabelNode.customLabel()
        uiRock.addChild(rockLabel)
        
        uiStar = SKSpriteNode(imageNamed: "star")
        uiStar.position = CGPoint(x: 32, y: 32)
        //uiStar.zPosition = 0
        starLabel = SKLabelNode.customLabel()
        uiStar.addChild(starLabel)
        
        uiEnergy = SKSpriteNode(imageNamed: "battery")
        uiEnergy.position = CGPoint(x: 224, y: 32)
        //uiEnergy.zPosition = 0
        uiEnergy.setScale(1.3)
        energyLabel = SKLabelNode.customLabel()
        uiEnergy.addChild(energyLabel)
        
        
        addChild(uiRock)
        addChild(uiStar)
        addChild(uiEnergy)
    }
    
    func genRandObstacle() {
        var cont = false
        
        while (!cont) {
            let xCoord = Int.random(in: 0..<16)
            let xPos = (xCoord*64)+32
            let yCoord = Int.random(in: 0..<12)
            let yPos = (yCoord*64)+32
            
            if (checkGrids(xCoord: xCoord, yCoord: yCoord)) {
//                print("Print Log RandGen: Grid[\(xCoord)][\(yCoord)]")
//                print(checkGrids(xCoord: xCoord, yCoord: yCoord))
                
                let obstacle = SKSpriteNode(imageNamed: "block")
                obstacle.position = CGPoint(x: xPos, y: yPos)
                obstacle.setScale(0.5)
                
                obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.frame.width/2)
                obstacle.physicsBody?.affectedByGravity = false
                obstacle.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
                obstacle.physicsBody?.collisionBitMask = PhysicsCategory.Player
                obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.Player
                obstacle.physicsBody?.isDynamic = false
                addChild(obstacle)
                
                grid[xCoord][yCoord] = obstacle
                cont = true
            }
        }
    }
    
    func counter() {
        
        passedTime += 1
        timeBlock.text = "Timer: \(passedTime)"
        if (passedTime < 16) {
            genRandObstacle()
        }
    }
    
    func generateGrid() {

        var xCoord = 32
        var yCoord = 32

        for i in 0..<12 {
            for j in 0..<16 {

                grid[i][j] = nil
                //grid[i][j]!.size = CGSize(width: 64, height: 64)
                ///grid[i][j]!.position = CGPoint(x: xCoord, y: yCoord)
                yCoord += 64
            }
            xCoord += 64
        }
    }
    
    func checkGrids(xCoord: Int, yCoord: Int) -> Bool {
        
        if (grid[xCoord][yCoord] != nil) {
            return false
            //if ((grid[xCoord][yCoord]?.position.x)! > 0) {
                //return false
            //}
        } else {
            return true
        }
        return false
    }
    
    func addPlayer() {
        
        player = SKSpriteNode(imageNamed: "caveman")
        player.position = CGPoint(x: 32, y: 96)
        player.setScale(0.1)
        //player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width/2)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.collisionBitMask = PhysicsCategory.Border | PhysicsCategory.Obstacle
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Border
        addChild(player)
        
        grid[0][1] = player
        print("Player zPosition: \(player.zPosition)")
    }
    
    
    func addBorder(xPos: Int, yPos: Int) {
        
        var brickBlock: SKSpriteNode!
        
        if ((xPos == 352 && yPos == 32) || (xPos == 800 && yPos == 32)) {
            brickBlock = SKSpriteNode(imageNamed: "water")
            brickBlock.setScale(1.3)
        } else {
            brickBlock = SKSpriteNode(imageNamed: "block")
            brickBlock.setScale(0.5)
        }
        
        brickBlock.position = CGPoint(x: xPos, y: yPos)
        
        //if (yPos < Int(self.size.height/2)) {
        brickBlock.physicsBody = SKPhysicsBody(circleOfRadius: brickBlock.frame.width/2)
        brickBlock.physicsBody?.affectedByGravity = false
        brickBlock.physicsBody?.categoryBitMask = PhysicsCategory.Border
        brickBlock.physicsBody?.collisionBitMask = PhysicsCategory.Player
        brickBlock.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        brickBlock.physicsBody?.isDynamic = false
        //}
        
        addChild(brickBlock)
        let iGrid = ((xPos-32)/64)
        let jGrid = ((yPos-32)/64)
        grid[iGrid][jGrid] = brickBlock
        //print("Block placed at grid: \(iGrid) \(jGrid)")
    }
    
    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        // Initialize Swipe Gesture Recognizer
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))

        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizer.direction = direction

        return swipeGestureRecognizer
    }
}

extension SKLabelNode {
    class func customLabel() -> SKLabelNode {
        
        let returnLabel = SKLabelNode(text: "0")
        returnLabel.position = CGPoint(x: 0, y: 0)
        //returnLabel.zPosition = 1
        returnLabel.fontSize = 24
        returnLabel.fontName = returnLabel.fontName! + "-Bold"
        returnLabel.fontColor = .black
        
        return returnLabel
    }
}
