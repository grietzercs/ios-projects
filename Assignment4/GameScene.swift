//
//  GameScene.swift
//  Assignment4
//
// 
//

import SpriteKit
import GameplayKit
import AVFoundation

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
    
    var food: SKSpriteNode!
    var energy = 300
    var hearts = 3.0
    var rocks = 10
    var score = 0
    
    var rockCounter = 0
    var gravityCounter = 0
    var randGravityCounter = 0
    
    var dino1: SKSpriteNode!
    var dino2: SKSpriteNode!
    var dino3: SKSpriteNode!
    var dino4: SKSpriteNode!
    
    var leftEdge: SKSpriteNode!
    var rightEdge: SKSpriteNode!
    
    var audioPlayer: AVAudioPlayer!
    var statusPanel: SKSpriteNode!
    var panelText: SKLabelNode!
    
    var grid = [[SKSpriteNode?]](
        repeating: [SKSpriteNode?](repeating: nil, count: 16),
     count: 16
    )
    
    var timer = Timer()
    var passedTime = 0
    
    struct PhysicsCategory {
        static let Player: UInt32 = 1
        static let Rock: UInt32 = 4
        static let Border: UInt32 = 10
        static let Obstacle: UInt32 = 12
        static let Fireball: UInt32 = 14
        static let Star: UInt32 = 16
        static let Food: UInt32 = 18
        
        static let leftEdge: UInt32 = 8
        static let rightEdge: UInt32 = 8
        
        static let Dino1: UInt32 = 20
        static let Dino2: UInt32 = 22
        static let Dino3: UInt32 = 24
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
        addEdges()
        
        var xIncr = 32 //used for all rows
        var yIncr = Int((self.size.height)) //used for top rows
        for _ in 0...15 {
            addBorder(xPos: xIncr, yPos: 32)
            addBorder(xPos: xIncr, yPos: (yIncr-32))
            addBorder(xPos: xIncr, yPos: (yIncr-96))
            xIncr += 64
        }
    
        addUI()
        addDino1()
        addDino2()
        addDino3()
        addDino4()
        addStar()
        addFood()
        
        //generate random gravity time
        randGravityCounter = Int.random(in: 40...60)
        
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
    
    func addPanel() {
        
        statusPanel = SKSpriteNode(imageNamed: "game-status-panel")
        statusPanel.size = CGSize(width: 960, height: 100)
        statusPanel.position = CGPoint(x: 512, y: 64)
        statusPanel.zPosition = 844
        addChild(statusPanel)
        
        panelText = SKLabelNode(text: "Game Panel")
        panelText.fontName = "Avenir-Bold"
        panelText.fontSize = 30
        panelText.zPosition = 846
        panelText.fontColor = SKColor.white
        
        panelText.addChild(panelText)
    }
    
    func addStar() {
        let star = SKSpriteNode(imageNamed: "star")
        var cont = false
        
        while (!cont) {
            let xCoord = Int.random(in: 0...15)
            let xPos = (xCoord*64)+32
            let yCoord = Int.random(in: 1...9)
            let yPos = (yCoord*64)+32
            
            if (checkGrids(xCoord: xCoord, yCoord: yCoord)) {
                star.position = CGPoint(x: xPos, y: yPos)
                star.physicsBody = SKPhysicsBody(circleOfRadius: star.frame.width/2)
                star.physicsBody?.affectedByGravity = false
                star.physicsBody?.isDynamic = false
                star.physicsBody?.categoryBitMask = PhysicsCategory.Star
                star.zPosition = 701
                
                grid[xCoord][yCoord] = star
                cont = true
            }
        }
        
        addChild(star)
    }
    
    func starTouched(star: SKSpriteNode) {
        
        star.removeFromParent()
        
        let tempSound = URL(fileURLWithPath: Bundle.main.path(forResource: "star", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tempSound)
            audioPlayer.play()
        } catch {
            print(error)
        }
        
        for i in 0..<12 {
            for j in 0..<16 {
                
                let tempNode = grid[i][j] ?? dino1
                if ((grid[i][j]?.frame.intersects(star.frame)) != nil) {
                    grid[i][j] = nil
                }
            }
        }
        addStar()
        score += 1
        starLabel.text = "\(score)"
    }
    
    func addFood() {
        let food = SKSpriteNode(imageNamed: "food")
        var cont = false
        
        var xCoord: Int
        var yCoord: Int
        var xPos: Int = 0
        var yPos: Int = 0
        
        while (!cont) {
            xCoord = Int.random(in: 0...15)
            xPos = (xCoord*64)+32
            yCoord = Int.random(in: 1...9)
            yPos = (yCoord*64)+32
            
            if (checkGrids(xCoord: xCoord, yCoord: yCoord)) {
                food.position = CGPoint(x: xPos, y: yPos)
                food.physicsBody = SKPhysicsBody(circleOfRadius: food.frame.width/2)
                food.physicsBody?.affectedByGravity = false
                food.physicsBody?.isDynamic = false
                food.physicsBody?.categoryBitMask = PhysicsCategory.Food
                food.physicsBody?.contactTestBitMask = PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3 | PhysicsCategory.Player
                
                grid[xCoord][yCoord] = food
                food.zPosition = 705
                cont = true
            }
        }
        addChild(food)
    }
    
    func foodContacted(eaterNode: SKSpriteNode, foodNode: SKSpriteNode) {
        
        foodNode.removeFromParent()
        let physicsCat = eaterNode.physicsBody?.categoryBitMask
        
        for i in 0..<12 {
            for j in 0..<16 {
                
                let tempNode = grid[i][j] ?? dino1
                if ((grid[i][j]?.frame.intersects(foodNode.frame)) != nil) {
                    grid[i][j] = nil
                }
            }
        }
        
        if (eaterNode.physicsBody?.categoryBitMask == PhysicsCategory.Player) {
            addStar()
            energy += 50
            energyLabel.text = "\(energy)"
        } else {
            run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(10)), SKAction.run({self.addStar()})]))
        }
    }
    
    func addDino1() {
        
        let posArray = [352, 800]
        let spawnPoint = posArray.randomElement()//may delete
        
        dino1 = SKSpriteNode.Dino(position: CGPoint(x: 352, y: 32), name: "Dino1", zPos: 759)
        addChild(dino1)
        dino1.moveUpDown(dino: dino1)
        
        var xPos = Int.random(in: 10...15)
        xPos = (xPos*64)+32
        var yPos = Int.random(in: 1...9)
        yPos = (yPos*64)+32
    }
    
    func addDino2() {
        
        var xPos = Int.random(in: 10...15)
        xPos = (xPos*64)+32
        var yPos = Int.random(in: 1...9)
        yPos = (yPos*64)+32
        
        dino2 = SKSpriteNode.Dino(position: CGPoint(x: xPos, y: yPos), name: "Dino2", zPos: 760)
        addChild(dino2)
        dino2.moveLeftRight(dino: dino2)
    }
    
    func addDino3() {
        
        dino3 = SKSpriteNode.Dino(position: CGPoint(x: 32, y: 608), name: "Dino3", zPos: 761)
        dino3.physicsBody?.collisionBitMask = PhysicsCategory.Dino2 | PhysicsCategory.Dino1 | PhysicsCategory.Border | PhysicsCategory.Player | PhysicsCategory.leftEdge | PhysicsCategory.rightEdge | PhysicsCategory.Rock
        dino3.physicsBody?.contactTestBitMask = dino3.physicsBody!.collisionBitMask
        addChild(dino3)
        dino3.moveAround(dino: dino3)
    }
    
    func addDino4() {

        dino4 = SKSpriteNode(imageNamed: "Dino4")
        dino4.position = CGPoint(x: 32, y: 672)
        dino4.name = "Dino4"
        dino4.zPosition = 730
        dino4.physicsBody = SKPhysicsBody(circleOfRadius: dino4.frame.width/2)
        dino4.physicsBody?.affectedByGravity = false
        dino4.physicsBody?.isDynamic = false
        addChild(dino4)
        dino4.moveRightLeft(dino: dino4)
        
        let wait = SKAction.wait(forDuration: TimeInterval(Int.random(in: 5...10)))
        let spitFlames = SKAction.run { self.shootFire() }
        let sequence = SKAction.sequence([spitFlames, wait])
        dino4.run(SKAction.repeatForever(sequence))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //dino1 hit by rock
        if ((contact.bodyB.categoryBitMask == PhysicsCategory.Rock && contact.bodyA.categoryBitMask == PhysicsCategory.Dino1) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Dino1 && contact.bodyA.categoryBitMask == PhysicsCategory.Rock) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Rock && contact.bodyA.categoryBitMask == PhysicsCategory.Dino2) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Dino2 && contact.bodyA.categoryBitMask == PhysicsCategory.Rock) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Rock && contact.bodyA.categoryBitMask == PhysicsCategory.Dino3) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyA.categoryBitMask == PhysicsCategory.Rock)) {
            
            if (contact.bodyA.categoryBitMask == PhysicsCategory.Rock) {
                contact.bodyA.node?.removeFromParent()
                dinoHit(dino: contact.bodyB.node! as! SKSpriteNode)
                
            } else {
                contact.bodyB.node?.removeFromParent()
                dinoHit(dino: contact.bodyA.node! as! SKSpriteNode)
            }
            //gameOver()
        }
        
        //dino hit by player
        if ((contact.bodyB.categoryBitMask == PhysicsCategory.Player && contact.bodyA.categoryBitMask == PhysicsCategory.Dino1) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Dino1 && contact.bodyA.categoryBitMask == PhysicsCategory.Player) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Player && contact.bodyA.categoryBitMask == PhysicsCategory.Dino2) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Dino2 && contact.bodyA.categoryBitMask == PhysicsCategory.Player) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Player && contact.bodyA.categoryBitMask == PhysicsCategory.Dino3) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyA.categoryBitMask == PhysicsCategory.Player)) {
            
            if (contact.bodyA.categoryBitMask == PhysicsCategory.Player) {
                playerTouchedDino(dino: contact.bodyB.node! as! SKSpriteNode)
                print("Dino hit by player")
            } else {
                playerTouchedDino(dino: contact.bodyB.node! as! SKSpriteNode)
                print("Dino hit by player")
            }
            //gameOver()
        }
        
        //dino ate food
        if ((contact.bodyB.categoryBitMask == PhysicsCategory.Food && contact.bodyA.categoryBitMask == PhysicsCategory.Dino1) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Dino1 && contact.bodyA.categoryBitMask == PhysicsCategory.Food) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Food && contact.bodyA.categoryBitMask == PhysicsCategory.Dino2) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Dino2 && contact.bodyA.categoryBitMask == PhysicsCategory.Food) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Food && contact.bodyA.categoryBitMask == PhysicsCategory.Dino3) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Dino3 && contact.bodyA.categoryBitMask == PhysicsCategory.Food)) {
            
            if (contact.bodyA.categoryBitMask == PhysicsCategory.Food) {
                foodContacted(eaterNode: contact.bodyB.node! as! SKSpriteNode, foodNode: contact.bodyA.node! as! SKSpriteNode)
            } else {
                foodContacted(eaterNode: contact.bodyA.node! as! SKSpriteNode, foodNode: contact.bodyB.node! as! SKSpriteNode)
            }
        }
        
        //player hit border or edge
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Border) || (contact.bodyB.categoryBitMask == PhysicsCategory.Border && contact.bodyA.categoryBitMask == PhysicsCategory.Player) || (contact.bodyB.categoryBitMask == PhysicsCategory.Player && contact.bodyA.categoryBitMask == PhysicsCategory.Border) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Border && contact.bodyA.categoryBitMask == PhysicsCategory.Player) ||
            (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.leftEdge) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.leftEdge && contact.bodyA.categoryBitMask == PhysicsCategory.Player) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Player && contact.bodyA.categoryBitMask == PhysicsCategory.rightEdge) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.rightEdge && contact.bodyA.categoryBitMask == PhysicsCategory.Player)) {
            
            print("Player touched grass")
            player.removeAllActions()
            if let nextMove = player.action(forKey: "playerMove") {
                print("Reached past touching grass")
                nextMove.speed = 0
            }
        }
        
        //fire hit player
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Fireball) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Fireball && contact.bodyA.categoryBitMask == PhysicsCategory.Player)) {
            
            if (contact.bodyA.categoryBitMask == PhysicsCategory.Fireball) {
                contact.bodyA.node?.removeFromParent()
                fireHitPlayer()
            } else {
                contact.bodyB.node?.removeFromParent()
                fireHitPlayer()
            }
        }
        
        //player touches star
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Star) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Star && contact.bodyA.categoryBitMask == PhysicsCategory.Player)) {
            
            if (contact.bodyA.categoryBitMask == PhysicsCategory.Star) {
                starTouched(star: contact.bodyA.node! as! SKSpriteNode)
            } else {
                starTouched(star: contact.bodyB.node! as! SKSpriteNode)
            }
        }
        
        //player touches food
        if ((contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Food) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.Food && contact.bodyA.categoryBitMask == PhysicsCategory.Player)) {
            
            if (contact.bodyA.categoryBitMask == PhysicsCategory.Player) {
                foodContacted(eaterNode: contact.bodyA.node! as! SKSpriteNode, foodNode: contact.bodyB.node! as! SKSpriteNode)
            } else {
                foodContacted(eaterNode: contact.bodyB.node! as! SKSpriteNode, foodNode: contact.bodyA.node! as! SKSpriteNode)
            }
        }
    }
    
    func dinoHit(dino: SKSpriteNode) {
        
        let cond = dino.physicsBody?.categoryBitMask
        var addDino: SKAction!
        
        dino.removeFromParent()
        let waitTime = Int.random(in: 1...5)

        switch cond {
        case(20):
            run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(waitTime)), SKAction.run({self.addDino1()})]))
        case(22):
            run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(waitTime)), SKAction.run({self.addDino2()})]))
        case(24):
            run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(waitTime)), SKAction.run({self.addDino3()})]))
        default:
            print("no dino found")
            //no dino to be called
        }
    }
    
    func fireHitPlayer() {
        
        if (energy >= 100) {
            energy -= 100
            hearts -= 1
            energyLabel.text = "\(energy)"
            heartLabel.text = "\(hearts.rounded(.up))"
        }
    }
    
    func playerTouchedDino(dino: SKSpriteNode) {
        
        let cond = dino.physicsBody?.categoryBitMask
        var addDino: SKAction!
        
        dino.removeFromParent()
        let waitTime = Int.random(in: 1...5)

        switch cond {
        case(20):
            if (energy >= 60) {
                energy -= 60
                hearts -= 0.6
                energyLabel.text = "\(energy)"
                heartLabel.text = "\(hearts.rounded(.up))"
            }
            run(SKAction.wait(forDuration: TimeInterval(waitTime)))
            addDino1()
        case(22):
            if (energy >= 80) {
                energy -= 80
                hearts -= 0.8
                energyLabel.text = "\(energy)"
                heartLabel.text = "\(hearts.rounded(.up))"
            }
            run(SKAction.wait(forDuration: TimeInterval(waitTime)))
            addDino2()
        case(24):
            if (energy >= 100) {
                energy -= 100
                hearts -= 1.0
                energyLabel.text = "\(energy)"
                heartLabel.text = "\(hearts.rounded(.up))"
            }
            run(SKAction.wait(forDuration: TimeInterval(waitTime)))
            addDino3()
        default:
            print("no dino found")
            //no dino to be called
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
        
        if (rocks > 0) {
            
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
            
            let rockGo = SKAction.move(to: travelDist, duration: 2)
            let doneMoving = SKAction.removeFromParent()
            
            rock.physicsBody = SKPhysicsBody(circleOfRadius: rock.frame.width/2)
            rock.physicsBody?.categoryBitMask = PhysicsCategory.Rock
            rock.physicsBody?.collisionBitMask = 0
            rock.physicsBody?.contactTestBitMask = PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3
            rock.physicsBody?.isDynamic = true
            rock.physicsBody?.affectedByGravity = false
            rock.physicsBody?.contactTestBitMask = rock.physicsBody!.collisionBitMask
            
            rock.run(SKAction.sequence([rockGo, doneMoving]))
            rocks -= 1
            rockLabel.text = "\(rocks)"
            
            let rockSound = URL(fileURLWithPath: Bundle.main.path(forResource: "rock", ofType: "mp3")!)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: rockSound)
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
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
        
        let mv = SKAction.moveBy(x: CGFloat(xPos), y: CGFloat(yPos), duration: 8)
        player.run(mv, withKey: "playerMove")
    }
    
    func addUI() {
        
        uiHeart = SKSpriteNode(imageNamed: "heart")
        uiHeart.position = CGPoint(x: 160, y: 32)
        uiHeart.zPosition = 801
        heartLabel = SKLabelNode.customLabel()
        heartLabel.text = "\(hearts.rounded(.up))"
        addChild(uiHeart)
        uiHeart.addChild(heartLabel)
        
        uiRock = SKSpriteNode(imageNamed: "rock")
        uiRock.position = CGPoint(x: 96, y: 32)
        uiRock.setScale(0.8)
        uiRock.zPosition = 801
        rockLabel = SKLabelNode.customLabel()
        rockLabel.text = "\(rocks)"
        uiRock.addChild(rockLabel)
        
        uiStar = SKSpriteNode(imageNamed: "star")
        uiStar.position = CGPoint(x: 32, y: 32)
        uiStar.zPosition = 801
        starLabel = SKLabelNode.customLabel()
        starLabel.text = "\(score)"
        uiStar.addChild(starLabel)
        
        uiEnergy = SKSpriteNode(imageNamed: "battery")
        uiEnergy.position = CGPoint(x: 224, y: 32)
        uiEnergy.zPosition = 801
        uiEnergy.setScale(1.3)
        energyLabel = SKLabelNode.customLabel()
        energyLabel.text = "\(energy)"
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
        rockCounter += 1
        gravityCounter += 1
        energy += 1
        
        timeBlock.text = "Timer: \(passedTime)"
        if (passedTime < 16) {
            genRandObstacle()
        }
        if (rockCounter == 30) {
            if (rocks < 20) {
                rocks += 1
            }
            rockLabel.text = "\(rocks)"
        }
        //gravity time hit
        if (gravityCounter == randGravityCounter) {
            player.physicsBody?.affectedByGravity = true
            player.run(SKAction.wait(forDuration: 1.0))
            gravityCounter = 0
            randGravityCounter = Int.random(in: 40...60)
        }
        //reset gravity after use
        if (gravityCounter == (randGravityCounter + 1)) {
            gravityCounter = 0
            randGravityCounter = Int.random(in: 40...60)
        }
        // energy low, sacrificing energy for hearts
        if ((energy == 0) && (hearts > 0)) {
            hearts -= 1
            heartLabel.text = "\(hearts.rounded(.up))"
            energy += 100
            energyLabel.text = "\(energy)"
        }
        if (hearts <= 0) {
            heartLabel.text = "\(hearts)"
            player.removeFromParent()
            gameOver()//insert gameOver
        }
    }
    
    func gameOver() {
        timer.invalidate()
        let gameOverScene = GameOverScene(size: self.size)
        let transition = SKTransition.moveIn(with: .up, duration: 1.0)
        gameOverScene.scaleMode = .aspectFill
        
        gameOverScene.score = score
        self.view?.presentScene(gameOverScene, transition: transition)
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
        player.physicsBody?.collisionBitMask = PhysicsCategory.Border | PhysicsCategory.Obstacle | PhysicsCategory.leftEdge | PhysicsCategory.rightEdge | PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Border | PhysicsCategory.Obstacle | PhysicsCategory.leftEdge | PhysicsCategory.rightEdge | PhysicsCategory.Dino1 | PhysicsCategory.Dino2 | PhysicsCategory.Dino3
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        addChild(player)
        
        grid[0][1] = player
        print("Player zPosition: \(player.zPosition)")
    }
    
    
    func addBorder(xPos: Int, yPos: Int) {
        
        var brickBlock: SKSpriteNode!
        
        if ((xPos == 352 && yPos == 32) || (xPos == 800 && yPos == 32)) {
            brickBlock = SKSpriteNode(imageNamed: "water")
            brickBlock.setScale(1.05)
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
    
    func addEdges() {
        leftEdge = SKSpriteNode()
        leftEdge.position = CGPoint(x: 0, y: 0)
        leftEdge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height:self.frame.height * 2))
        leftEdge.physicsBody?.isDynamic = false
        leftEdge.physicsBody?.categoryBitMask = PhysicsCategory.leftEdge
       
        addChild(leftEdge)
        
        rightEdge = SKSpriteNode()
        rightEdge.position = CGPoint(x: 1366, y: 0)
        rightEdge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height:self.frame.height * 2))
        rightEdge.physicsBody?.isDynamic = false
        rightEdge.physicsBody?.categoryBitMask = PhysicsCategory.rightEdge
        
        addChild(rightEdge)
    }
    
    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))

        
        swipeGestureRecognizer.direction = direction

        return swipeGestureRecognizer
    }
    
    func shootFire() {
        
        let fireball = addFire()
        addChild(fireball)
        
        let tempSound = URL(fileURLWithPath: Bundle.main.path(forResource: "fire", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: tempSound)
            audioPlayer.play()
        } catch {
            print(error)
        }
        
        //Pythagorean Thm
        var xAccel = CGFloat(player.position.x - dino4.position.x)
        var yAccel = CGFloat(player.position.y - dino4.position.y)
        let hyp = sqrt(xAccel*xAccel + yAccel*yAccel)
        
        xAccel = xAccel/hyp
        yAccel = yAccel/hyp
        
        let vector = CGVector(dx: 50.0 * xAccel, dy: 50.0 * yAccel)
        fireball.physicsBody?.applyImpulse(vector)
        
    }
        
    func addFire() -> SKSpriteNode {
        
        var fireball: SKSpriteNode!
        fireball = SKSpriteNode(imageNamed: "fire")
        fireball.size = CGSize(width: 78, height: 78)
        fireball.position = CGPoint(x: dino4.position.x, y: dino4.position.y - 50)
        fireball.physicsBody = SKPhysicsBody(circleOfRadius: (fireball.frame.width - 6)/2)
        fireball.physicsBody?.categoryBitMask = PhysicsCategory.Fireball
        fireball.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        fireball.physicsBody?.collisionBitMask = PhysicsCategory.Player
        fireball.physicsBody?.affectedByGravity = false
        fireball.physicsBody?.isDynamic = true
        return fireball
    }
}

extension SKLabelNode {
    class func customLabel() -> SKLabelNode {
        
        let returnLabel = SKLabelNode(text: "0")
        returnLabel.position = CGPoint(x: 0, y: 0)
        returnLabel.zPosition = 802
        returnLabel.fontSize = 24
        returnLabel.fontName = returnLabel.fontName! + "-Bold"
        returnLabel.fontColor = .black
        
        return returnLabel
    }
}

extension SKSpriteNode {
    
    func moveUpDown(yPos: Int = 0, dino: SKSpriteNode) {

        var temp = yPos

        let direction = Int.random(in: 0...1)
        if (direction == 0) {
            temp = -768
        } else {
            temp = 768
        }

        let mvUp = SKAction.moveBy(x: 0, y: 768, duration: 6)
        let mvDown = SKAction.moveBy(x: 0, y: -768, duration: 6)
        let wait = SKAction.wait(forDuration: TimeInterval(Int.random(in: 1...3)))
        mvUp.timingMode = .easeIn
        mvDown.timingMode = .easeIn
        let sequence = SKAction.sequence([mvUp, wait, mvDown])
        let seqForever = SKAction.repeatForever(sequence)
        dino.run(seqForever)
    }
    
    func moveLeftRight(yPos: Int = 0, dino: SKSpriteNode) {

        var temp = yPos

        let direction = Int.random(in: 0...1)
        if (direction == 0) {
            temp = -768
        } else {
            temp = 768
        }

        let mvLeft = SKAction.moveBy(x: -1024, y: 0, duration: 6)
        let mvRight = SKAction.moveBy(x: 1024, y: 0, duration: 6)
        let flip = SKAction.scaleX(to: -1, duration: 0)
        let flip2 = SKAction.scaleX(to: 1, duration: 0)
        let wait = SKAction.wait(forDuration: TimeInterval(Int.random(in: 1...3)))
        mvLeft.timingMode = .easeIn
        mvRight.timingMode = .easeIn
        let sequence = SKAction.sequence([mvLeft, wait, flip, mvRight, flip2, wait])
        let seqForever = SKAction.repeatForever(sequence)
        dino.run(seqForever)
    }
    
    func moveRightLeft(yPos: Int = 0, dino: SKSpriteNode) {

        var temp = yPos

        let direction = Int.random(in: 0...1)
        if (direction == 0) {
            temp = -768
        } else {
            temp = 768
        }

        let mvLeft = SKAction.moveBy(x: -1024, y: 0, duration: 6)
        let mvRight = SKAction.moveBy(x: 1024, y: 0, duration: 6)
        let flip = SKAction.scaleX(to: -1, duration: 0)
        let flip2 = SKAction.scaleX(to: 1, duration: 0)
        let wait = SKAction.wait(forDuration: TimeInterval(Int.random(in: 1...3)))
        mvLeft.timingMode = .easeIn
        mvRight.timingMode = .easeIn
        let sequence = SKAction.sequence([mvRight, wait, flip, mvLeft, flip2, wait])
        let seqForever = SKAction.repeatForever(sequence)
        dino.run(seqForever)
    }
    
    func moveAround(dino: SKSpriteNode) {
        
        dino.removeAllActions()
        let randDirection = arc4random_uniform(4)
        
        
        let move_with_direction: SKAction
        var flipDir: SKAction
        var scale = CGFloat(0)
        
        switch (randDirection)
        {
        case 0:
            if (dino.xScale == 1 || dino.xScale == 0) {
                scale = -1
                
            } else {
                scale = dino.xScale
                
            }
            flipDir = SKAction.scaleX(to: CGFloat(scale), duration: 0)
            move_with_direction = SKAction.moveBy(x: 128, y: 0, duration: 1)
            
        case 1:
            if (dino.xScale == -1 || dino.xScale == 0) {
                scale = 1
                
            } else {
                    scale = dino.xScale
                }
            flipDir = SKAction.scaleX(to: scale, duration: 0)
            move_with_direction = SKAction.moveBy(x: -128, y: 0, duration: 1)
            
        case 2:
            if (dino.yScale == -1 || dino.yScale == 0) {
                scale = 1
                
            } else {
                scale = dino.yScale
                
            }
            flipDir = SKAction.scaleX(to: scale, duration: 0)
            move_with_direction = SKAction.moveBy(x: 0, y: 128, duration: 1)
            
        case 3:
            if (dino.yScale == 1 || dino.yScale == 0) {
                scale = -1
            } else {
                scale = dino.yScale
            }
            flipDir = SKAction.scaleX(to: scale, duration: 0)
            move_with_direction = SKAction.moveBy(x: 0, y: -128, duration: 1)
            
        default:
            if (dino.xScale == 1 || dino.xScale == 0) {
                scale = -1
            } else {
                scale = dino.xScale
            }
            flipDir = SKAction.scaleX(to: scale, duration: 0)
            move_with_direction = SKAction.moveBy(x: 128, y: 0, duration: 1)
        }
        dino.run(flipDir)
        dino.run(SKAction.repeatForever(move_with_direction), withKey: "moveDino")
    }

    
    class func Dino(position: CGPoint, name: String, zPos: CGFloat) -> SKSpriteNode {
        
        struct PhysicsCategory {
            static let Player: UInt32 = 1
            static let Rock: UInt32 = 4
            static let Border: UInt32 = 10
            static let Obstacle: UInt32 = 12
            static let Fireball: UInt32 = 14
            static let Star: UInt32 = 16
            static let Food: UInt32 = 18
            
            static let leftEdge: UInt32 = 8
            static let rightEdge: UInt32 = 8
            
            static let Dino1: UInt32 = 20
            static let Dino2: UInt32 = 22
            static let Dino3: UInt32 = 24
        }
        
        
        let dino = SKSpriteNode(imageNamed: name)
        dino.setScale(1.0)
        dino.position = position
        dino.physicsBody = SKPhysicsBody(circleOfRadius: dino.frame.width/2)
        dino.physicsBody?.affectedByGravity = false
        dino.physicsBody?.collisionBitMask = PhysicsCategory.Rock
        dino.physicsBody?.contactTestBitMask = PhysicsCategory.Rock | PhysicsCategory.Food
        dino.physicsBody?.isDynamic = false
        dino.physicsBody?.allowsRotation = false
        
        switch name {
        case "Dino1":
            dino.physicsBody?.categoryBitMask = PhysicsCategory.Dino1
        case "Dino2":
            dino.physicsBody?.categoryBitMask = PhysicsCategory.Dino2
        case "Dino3":
            dino.physicsBody?.categoryBitMask = PhysicsCategory.Dino3
        default:
            dino.physicsBody?.categoryBitMask = PhysicsCategory.Dino1
        }
        
        return dino
    }
}
