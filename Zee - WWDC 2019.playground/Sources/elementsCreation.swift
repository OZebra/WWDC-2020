import Foundation
import SpriteKit


let fadeIO = SKAction.sequence([
    SKAction.fadeAlpha(to: 0.2, duration: 0.5),
    SKAction.fadeAlpha(to: 1, duration: 1)
    ])

let fastFadeIO = SKAction.sequence([
    SKAction.fadeAlpha(to: 0, duration: 0.4),
    SKAction.fadeAlpha(to: 1, duration: 0.4)
    ])
let tipFadeIO = SKAction.sequence([
    SKAction.fadeAlpha(to: 1, duration: 1),
    SKAction.fadeAlpha(to: 1, duration: 4),
    SKAction.fadeAlpha(to: 0, duration: 1)
    ])

func createBG() -> SKSpriteNode{
    let background = SKSpriteNode(imageNamed: "background.png")
    background.name = "background"
    background.position = CGPoint(x: 0, y: 0)
    background.size = CGSize(width: 800, height: 480)
    return background
}

func createPlayButton() -> SKSpriteNode{
    let playButton = SKSpriteNode(imageNamed: "playButton.png")
    playButton.size = CGSize(width: 90, height: 36.5)
    playButton.name = "playButton"
    playButton.position.x = -302
    playButton.position.y = 183
    return playButton
}

func createZee(size: CGSize, pos: CGPoint) -> SKSpriteNode{
    let zee = SKSpriteNode(imageNamed: "zee.png")
    zee.name = "zee"
    zee.size = size
    zee.position = pos
    
    zee.physicsBody = SKPhysicsBody(circleOfRadius: zee.size.width/2)
    zee.physicsBody?.isDynamic = false
    zee.physicsBody?.usesPreciseCollisionDetection = true
    zee.physicsBody?.affectedByGravity = false
    zee.physicsBody?.restitution = 0
    zee.physicsBody?.friction = 10
    zee.physicsBody?.angularDamping = 0
    zee.physicsBody?.linearDamping = 0
    zee.physicsBody?.collisionBitMask = enemyCategory | floorCategory
    zee.physicsBody?.categoryBitMask = zeeCategory
    zee.physicsBody?.contactTestBitMask = enemyCategory | floorCategory | goalCategory | forceCategory
    
    return zee
}

func createEdgy(size: CGSize, pos: CGPoint) -> SKSpriteNode{
    let edgy = SKSpriteNode(imageNamed: "edgy.png")
    edgy.name = "edgy"
    edgy.size = size
    edgy.position = pos
    
    edgy.physicsBody = SKPhysicsBody(circleOfRadius: edgy.size.width*0.9/2)
    edgy.physicsBody?.isDynamic = false
    edgy.physicsBody?.usesPreciseCollisionDetection = true
    edgy.physicsBody?.affectedByGravity = false
    edgy.physicsBody?.restitution = 0
    edgy.physicsBody?.friction = 10
    edgy.physicsBody?.angularDamping = 0
    edgy.physicsBody?.linearDamping = 0
    edgy.physicsBody?.collisionBitMask = enemyCategory
    
    return edgy
}

func createPlataform(size: CGSize, pos: CGPoint) -> SKSpriteNode{
    let floor = SKSpriteNode(color: #colorLiteral(red: 1, green: 0.6666666667, blue: 0.8862745098, alpha: 1), size: size)
    floor.position = pos
    floor.name = "floor"
    floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
    floor.physicsBody?.isDynamic = false
    floor.physicsBody?.usesPreciseCollisionDetection = true
    floor.physicsBody?.affectedByGravity = false
    floor.physicsBody?.friction = 10
    floor.physicsBody?.categoryBitMask = floorCategory
    return floor
}

func createGoal(size: CGSize, pos: CGPoint) -> SKSpriteNode{
    let goal = SKSpriteNode(imageNamed: "goal.png")
    goal.size = size
    goal.position = pos
    goal.name = "goal"
    
    goal.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: goal.size.width*0.5, height: goal.size.height*0.5))
    goal.physicsBody?.isDynamic = false
    goal.physicsBody?.usesPreciseCollisionDetection = true
    goal.physicsBody?.affectedByGravity = false
    goal.physicsBody?.categoryBitMask = goalCategory
    
    return goal
}

func createPowerup(type: String, size: CGSize, pos: CGPoint) -> SKSpriteNode{
    let aux: String
    
    if type == "applyForce"{
        aux = "applyForce.png"
    }else if type == "reverseGravity"{
        aux = "reverseGravity.png"
    }else if type == "applyRestitution"{
        aux = "applyRestitution.png"
    }else{
        aux = "jonas"
        print("YOU PRETTY MUCH JUST SCREWED UP")
    }
    
    let powerUp = SKSpriteNode(imageNamed: aux)
    powerUp.size = size
    powerUp.position = pos
    powerUp.name = type
    powerUp.physicsBody = SKPhysicsBody(circleOfRadius: powerUp.size.width/2)
    powerUp.physicsBody?.isDynamic = false
    powerUp.physicsBody?.usesPreciseCollisionDetection = true
    powerUp.physicsBody?.affectedByGravity = false
    powerUp.physicsBody?.categoryBitMask = forceCategory
    
    return powerUp
}

func createBlank(type: String, size: CGSize, pos: CGPoint) -> SKSpriteNode{
    let aux: String
    
    aux = "unknown.png"
    
    let blank = SKSpriteNode(imageNamed: aux)
    blank.size = size
    blank.position = pos
    blank.name = type
    return blank
}

func winText(state: Bool) -> SKLabelNode{
    let message = SKLabelNode()
    if state {
        message.name = "won"
        message.text = "Congratulations!"
        
    }else{
        message.name = "lost"
        message.text = "You lost :/"
    }
    message.position.x = 0
    message.position.y = 0
    message.fontName = "BalooChettan-Regular"
    message.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    message.fontSize = 80.0
    message.alpha = 0
    message.run(SKAction.fadeIn(withDuration: 2))
    return message
}

func startText(level: Int, array: [String]) -> SKLabelNode{
    let levelLabel = SKLabelNode(text: array[level-1])
    levelLabel.name = "levelLabel"
    levelLabel.position.x = 0
    levelLabel.position.y = 140
    levelLabel.fontName = "BalooChettan-Regular"
    levelLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    levelLabel.fontSize = 22.0
    levelLabel.alpha = 0
    levelLabel.run(SKAction.fadeIn(withDuration: 1.5))
    return levelLabel
}

func ClickText(text: String) -> SKLabelNode{
    let label = SKLabelNode(text: text)
    if text == "Click to start editing!"{
        label.name = "Clicktostart"
    }else if text == "Click to continue!"{
        label.name = "Clicktocontinue"
    }else{
        label.name = "Clicktoretry"
    }
    label.position.x = 0
    label.position.y = -30
    label.fontName = "BalooChettan-Regular"
    label.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    label.fontSize = 20.0
    label.run(SKAction.repeatForever(fadeIO))
    return label
}

func availableorlearned(control: String) -> SKLabelNode{
    let label = SKLabelNode()
    if control == "notavailable"{
        //Unavailable
        label.text = "Not available"
        label.name = "notavailable"
    }else{
        label.text = "Not learned"
        label.name = control
    }
    label.position.x = 0
    label.position.y = 135
    label.fontName = "BalooChettan-Regular"
    label.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    label.fontSize = 13.0
    label.run(SKAction.repeat(fastFadeIO, count: 3))
    return label
}

func instruction(level: Int) -> SKLabelNode{
    let instruction = SKLabelNode()
    switch level {
    case 1:
        instruction.text = "The green powerup applies force to zee in the arrow direction"
    case 2:
        instruction.text = "The yellow powerup reverses gravity"
    case 3:
        instruction.text = "The purple powerup makes Zee bounce more than usual"
    case 4:
        instruction.text = "You're on your on. Use what you learned to overcome this!"
    default:
        instruction.text = "error"
    }
    instruction.name = "levelLabel"
    instruction.position.x = 0
    instruction.position.y = 140
    instruction.fontName = "BalooChettan-Regular"
    instruction.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    instruction.fontSize = 15.0
    instruction.alpha = 0
    instruction.run(tipFadeIO)
    return instruction
}
