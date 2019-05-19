import Foundation
import SpriteKit
import PlaygroundSupport

public class GameScene2: SKScene, SKPhysicsContactDelegate{
    
    var start_flag: Bool!
    var editing: Bool!
    var win: Bool! //Indicates a win or a lose
    var ended: Bool!
    var click_pos: CGPoint!
    
    public override func didMove(to view: SKView) {
        
        editing = false
        win = false
        ended = false
        start_flag = false
        self.size = view.frame.size
        backgroundColor = UIColor.white
        
        //MARK: Creating background
        let background = createBG()
        addChild(background)
        
        //MARK: Setting physics world
        setPhysicsWorld()
        
        //MARK: reverseGravity
        let reverseGravity = createPowerup(type: "reverseGravity", size: CGSize(width: 50, height: 50), pos: CGPoint(x: 0, y: 185))
        addChild(reverseGravity)
        
        let blank1 = createPowerup(type: "applyForce", size: CGSize(width: 50, height: 50), pos: CGPoint(x: -125, y: 185))
        blank1.alpha = 0.3
        addChild(blank1)
        
        let blank2 = createBlank(type: "unknown", size: CGSize(width: 50, height: 50), pos: CGPoint(x: 125, y: 185))
        addChild(blank2)
        
        //MARK: Goal
        let goal = createGoal(size: CGSize(width: 75, height: 78), pos: CGPoint(x: 312.5, y: 187))
        goal.zRotation = 3.1415
        goal.xScale = goal.xScale * -1
        addChild(goal)
        
        //MARK: Edgy
        let edgy = createEdgy(size: CGSize(width: 50, height: 50), pos: CGPoint(x: 37, y: 50))
        addChild(edgy)
        
        //MARK: Zee
        let zee = createZee(size: CGSize(width: 50, height: 50), pos: CGPoint(x: -338, y: -79))
        addChild(zee)
        
        //MARK: Goal reverse plataform
        let reverseFloor = createPlataform(size: CGSize(width: 260, height: 15), pos: CGPoint(x: 270, y: 233.5))
        addChild(reverseFloor)
        
        //MARK: Floor
        let floor = createPlataform(size: CGSize(width: 370, height: 15), pos: CGPoint(x: -215, y: -111))
        addChild(floor)
        
        //MARK: playButton Button
        let playButton = createPlayButton()
        addChild(playButton)
        
        //MARK: Level Label
        let st = startText(level: 2, array: levelTitles)
        addChild(st)
        
        //MARK: Start Label
        let tp = ClickText(text: "Click to start editing!")
        addChild(tp)
        
        //MARK: End of variables declaration
    }
    
    @objc public static override var supportsSecureCoding: Bool {
        // It just came with the basic template, so i thought it as
        // a good idea to let it stay
        get {
            return true
        }
    }
    
    public var didClickIcon: Int = 0
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let playButton = childNode(withName: "playButton")
        let zee = childNode(withName: "zee")
        let reverseGravity = childNode(withName: "reverseGravity")
        let applyForce = childNode(withName: "applyForce")
        let unknown = childNode(withName: "unknown")
        
        if !start_flag{
            start_flag = true
            editing = true
            let ClickStart = childNode(withName: "Clicktostart")
            let levelLabel = childNode(withName: "levelLabel")
            levelLabel?.removeFromParent()
            ClickStart?.removeFromParent()
            let tip = instruction(level: 2)
            self.addChild(tip)
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                tip.removeFromParent()
            }
        }else if !ended{
            for t in touches{
                let pos = t.location(in: self)
                
                if (playButton?.contains(t.location(in: self)))! && editing{
                    zee?.physicsBody?.isDynamic = true
                    zee?.physicsBody?.affectedByGravity = true
                    zee?.physicsBody?.velocity = CGVector(dx: 250, dy: 0)
                    playButton?.isHidden = true
                }
                //MARK: Crashing prevention
                if reverseGravity?.parent != nil{
                    if (reverseGravity?.contains(pos))!{
                        didClickIcon = 2
                    }
                }
                if (applyForce?.contains(pos))!{
                    didClickIcon = 1
                }
                if (unknown?.contains(pos))!{
                    didClickIcon = 3
                }
            }
        }else{
            //This if only happens when the level ends either win or lose, so now i'll check it
            if win { //You won!
                let nextlevel = GameScene3(fileNamed: "GameScene")
                self.view?.presentScene(nextlevel)
                
            }else{ //You lost :(
                let nextlevel = GameScene2(fileNamed: "GameScene")
                self.view?.presentScene(nextlevel)
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            let pos = t.location(in: self)
            let reverseGravity = childNode(withName: "reverseGravity")
            let ml = childNode(withName: "notlearned")
            let ma = childNode(withName: "notavailable")
            
            if didClickIcon == 2{
                reverseGravity?.position = pos
            }else if didClickIcon == 1{
                let message = availableorlearned(control: "notavailable")
                if ml?.parent != nil{
                    ml?.removeFromParent()
                }
                addChild(message)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    message.removeFromParent()
                }
            }else if didClickIcon == 3{
                if ma?.parent != nil{
                    ma?.removeFromParent()
                }
                let message = availableorlearned(control: "notlearned")
                addChild(message)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    message.removeFromParent()
                }
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        didClickIcon = 0
    }
    //
    //    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for t in touches { touchUp(atPoint: t.location(in: self)) }
    //    }
    //
    public override func update(_ currentTime: TimeInterval) {
        let zee = childNode(withName: "zee")
        let background = childNode(withName: "background")
        
        if !(background?.contains((zee?.position)!))!{
            let wt = winText(state: false)
            addChild(wt)
            zee?.physicsBody?.isDynamic = false
            zee?.physicsBody?.isResting = true
            zee?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            zee?.run(SKAction.fadeOut(withDuration: 1.5))
            let tp = ClickText(text: "Click to continue!")
            addChild(tp)
            self.ended = true
        }
    }
    //MARK: Physical contact handling
    public func didBegin(_ contact: SKPhysicsContact) {
        
        let zee = childNode(withName: "zee")
        let edgy = childNode(withName: "edgy")
        let reverseGravitye = childNode(withName: "reverseGravity")
        let goal = childNode(withName: "goal")
        
        //MARK: Crashing prevention
        //This prevents the game from crashing once the powerup is poped out
        if reverseGravitye?.parent != nil {
            //This if controls if zee got to the goal
            if ((contact.bodyA.node! == reverseGravitye && contact.bodyB.node! == zee)){
                self.physicsWorld.gravity = CGVector(dx: 0, dy: 4)
                //self.run(SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false))
                reverseGravitye?.removeFromParent()
            }
        }
        
        //MARK: Contact with the goal
        if((contact.bodyA.node! == goal && contact.bodyB.node! == zee) || (contact.bodyA.node! == zee && contact.bodyB.node! == goal)){
            
            let wt = winText(state: true)
            addChild(wt)
            win = true
            zee?.physicsBody?.isDynamic = false
            zee?.physicsBody?.isResting = true
            zee?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            zee?.run(SKAction.fadeOut(withDuration: 1.5))
            let tp = ClickText(text: "Click to continue!")
            addChild(tp)
            self.ended = true
        }
        //MARK: Contact with the edgy
        if((contact.bodyA.node! == edgy && contact.bodyB.node! == zee) || (contact.bodyA.node! == zee && contact.bodyB.node! == edgy)){
            let wt = winText(state: false)
            addChild(wt)
            zee?.physicsBody?.isDynamic = false
            zee?.physicsBody?.isResting = true
            zee?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            zee?.run(SKAction.fadeOut(withDuration: 1.5))
            let tp = ClickText(text: "Click to retry!")
            addChild(tp)
            self.ended = true
            
        }
    }
    func setPhysicsWorld(){
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -4)
    }
}

