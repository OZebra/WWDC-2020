import Foundation
import SpriteKit
import PlaygroundSupport


public class GameScene1: SKScene, SKPhysicsContactDelegate{
    
    var start_flag: Bool!
    var editing: Bool!
    var win: Bool! //Indicates a win or a lose
    var ended: Bool!
    var click_pos: CGPoint!
    
    public override func didMove(to view: SKView) {
        
        win = false //Checks if you won the game
        ended = false //Checks if the level ended, either win or loss
        editing = false //Checks if you're editing
        start_flag = false //Checks if the level began
        self.size = view.frame.size
        backgroundColor = UIColor.white
        
        //MARK: Creating background
        let background = createBG()
        addChild(background)
        
        //MARK: Setting physics world
        setPhysicsWorld()
        
        //MARK: Floor
        let floor = createPlataform(size: CGSize(width: 800, height: 25), pos: CGPoint(x: 0, y: -228.5))
        addChild(floor)
        
        //MARK: applyForce
        let applyForce = createPowerup(type: "applyForce", size: CGSize(width: 50, height: 50), pos: CGPoint(x: -125, y: 185))
        addChild(applyForce)
        
        let blank1 = createBlank(type: "unknown1", size: CGSize(width: 50, height: 50), pos: CGPoint(x: 125, y: 185))
        addChild(blank1)
        
        let blank2 = createBlank(type: "unknown2", size: CGSize(width: 50, height: 50), pos: CGPoint(x: 0, y: 185))
        addChild(blank2)
        
        //MARK: Goal
        let goal = createGoal(size: CGSize(width: 112, height: 116), pos: CGPoint(x: 306, y: -158))
        //I'm setting goal's position here because it's relative to the floor
        addChild(goal)
        
        //MARK: Edgy
        let edgy = createEdgy(size: CGSize(width: 75, height: 75), pos: CGPoint(x: 57.5, y: -147.5))
        addChild(edgy)
        
        //MARK: Zee
        let zee = createZee(size: CGSize(width: 75, height: 75), pos: CGPoint(x: -302.5, y: -177))
        addChild(zee)
        
        //MARK: playButton Button
        let playButton = createPlayButton()
        addChild(playButton)
        
        //MARK: Level Label
        let st = startText(level: 1, array: levelTitles)
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
        let applyForce = childNode(withName: "applyForce")
        let unknown1 = childNode(withName: "unknown1")
        let unknown2 = childNode(withName: "unknown2")
        
        if !start_flag{
            start_flag = true
            editing = true
            let ClickStart = childNode(withName: "Clicktostart")
            let levelLabel = childNode(withName: "levelLabel")
            levelLabel?.removeFromParent()
            ClickStart?.removeFromParent()
            let tip = instruction(level: 1)
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
                if applyForce?.parent != nil{
                    if (applyForce?.contains(pos))!{
                        didClickIcon = 1
                    }
                }
                if (unknown1?.contains(pos))!{
                    didClickIcon = 2
                }
                if (unknown2?.contains(pos))!{
                    didClickIcon = 3
                }

            }
        }else{
            //This if only happens when the level ends either win or lose, so now i'll check it
            if win { //You won!
                let nextlevel = GameScene2(fileNamed: "GameScene")
                self.view?.presentScene(nextlevel)
                
            }else{ //You lost :(
                let nextlevel = GameScene1(fileNamed: "GameScene")
                self.view?.presentScene(nextlevel)
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            let pos = t.location(in: self)
            let applyForce = childNode(withName: "applyForce")
            let ml = childNode(withName: "notlearned")
            
            switch didClickIcon{
            case 1:
                applyForce?.position = pos
                break
            case 2:
                let message = availableorlearned(control: "notlearned")
                if ml?.parent != nil{
                    ml?.removeFromParent()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    message.removeFromParent()
                }
                addChild(message)
                break
            case 3:
                let message = availableorlearned(control: "notlearned")
                addChild(message)
                if ml?.parent != nil{
                    ml?.removeFromParent()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    message.removeFromParent()
                }
                break
            default:
                break
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
            let tp = ClickText(text: "Click to retry!")
            addChild(tp)
            self.ended = true
        }
    }
    //MARK: Physical contact handling
    public func didBegin(_ contact: SKPhysicsContact) {
        
        let zee = childNode(withName: "zee")
        let edgy = childNode(withName: "edgy")
        let applyForcee = childNode(withName: "applyForce")
        let goal = childNode(withName: "goal")
        
        //MARK: Crashing prevention
        //This prevents the game from crashing once the powerup is poped out
        if applyForcee?.parent != nil {
            //This if controls if zee got to the goal
            if ((contact.bodyA.node! == applyForcee && contact.bodyB.node! == zee)){
                zee?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
                //self.run(SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false))
                applyForcee?.removeFromParent()
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
