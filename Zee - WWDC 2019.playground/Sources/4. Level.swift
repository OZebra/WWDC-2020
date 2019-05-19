import Foundation
import SpriteKit
import PlaygroundSupport

public class GameScene4: SKScene, SKPhysicsContactDelegate{
    
    var didClickIcon: Int = 0 //This variable helps me with a state machine of 4 states that identifies which icon was clicked and updates it's position.
    var start_flag: Bool!
    var win: Bool!
    var ended: Bool!
    var editing: Bool!
    var click_pos: CGPoint!
    let fadeIO = SKAction.sequence([
        SKAction.fadeAlpha(to: 0.2, duration: 0.5),
        SKAction.fadeAlpha(to: 1, duration: 1)
        ])
    
    public override func didMove(to view: SKView) {
        
        win = false
        ended = false
        editing = false
        start_flag = false
        self.size = view.frame.size
        backgroundColor = UIColor.white
        
        //MARK: Creating background
        let background = createBG()
        addChild(background)
        
        //MARK: Setting physics world
        setPhysicsWorld()
        
        //MARK: applyRestitution
        let applyForce = createPowerup(type: "applyForce", size: CGSize(width: 30, height: 30), pos: CGPoint(x: -75, y: 185))
        applyForce.zRotation =  3.1514/2
        addChild(applyForce)
        
        let applyRestitution = createPowerup(type: "applyRestitution", size: CGSize(width: 30, height: 30), pos: CGPoint(x: 75, y: 185))
        addChild(applyRestitution)
        
        let reverseGravity = createPowerup(type: "reverseGravity", size: CGSize(width: 30, height: 30), pos: CGPoint(x: 0, y: 185))
        addChild(reverseGravity)
        
        //MARK: Goal
        let goal = createGoal(size: CGSize(width: 45, height: 47), pos: CGPoint(x: -46.91, y: 99))
        goal.zRotation = 3.1415
        goal.xScale = goal.xScale * -1
        addChild(goal)
        
        //MARK: Edgy
        let edgy = createEdgy(size: CGSize(width: 30, height: 30), pos: CGPoint(x: 179, y: -161))
        addChild(edgy)
        
        //MARK: Zee
        let zee = createZee(size: CGSize(width: 30, height: 30), pos: CGPoint(x: 100, y: -215))
        addChild(zee)
        
        //MARK: Plataform 1
        let plataform1 = createPlataform(size: CGSize(width: 190, height: 10), pos: CGPoint(x: 162.27, y: -235))
        addChild(plataform1)
        
        //MARK: Plataform 2
        let plataform2 = createPlataform(size: CGSize(width: 500, height: 10), pos: CGPoint(x: 113, y: -43.5))
        addChild(plataform2)
        
        //MARK: Plataform 3
        let plataform3 = createPlataform(size: CGSize(width: 10, height: 150), pos: CGPoint(x: -300, y: 38.5))
        addChild(plataform3)
        
        //MARK:Plataform 4
        let plataform4 = createPlataform(size: CGSize(width: 56, height: 10), pos: CGPoint(x: -47, y: 127))
        addChild(plataform4)
        
        //MARK: playButton Button
        let playButton = createPlayButton()
        addChild(playButton)
        
        //MARK: Level Label
        let st = startText(level: 4, array: levelTitles)
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
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let playButton = childNode(withName: "playButton")
        let zee = childNode(withName: "zee")
        let applyRestitution = childNode(withName: "applyRestitution")
        let applyForce = childNode(withName: "applyForce")
        let reverseGravity = childNode(withName: "reverseGravity")
        
        if !start_flag{
            start_flag = true
            editing = true
            let ClickStart = childNode(withName: "Clicktostart")
            let levelLabel = childNode(withName: "levelLabel")
            levelLabel?.removeFromParent()
            ClickStart?.removeFromParent()
            let tip = instruction(level: 4)
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
                if applyRestitution?.parent != nil{
                    if (applyRestitution?.contains(pos))!{
                        didClickIcon = 1
                    }
                }else{
                    print("Log: Apply Restitution was already used and is no longer on scene")
                }
                
                if applyForce?.parent != nil{
                    if (applyForce?.contains(pos))!{
                        didClickIcon = 2
                    }
                }else{
                    print("Log: Apply Force was already used and is no longer on scene")
                }
                
                if reverseGravity?.parent != nil{
                    if (reverseGravity?.contains(pos))!{
                        didClickIcon = 3
                    }
                }else{
                    print("Log: Reverse Gravity was already used and is no longer on scene")
                }
            }
        }else{
            //This if only happens when the level ends either win or lose, so now i'll check it
            if win { //You won!
                let nextlevel = GameScene5(fileNamed: "GameScene")
                self.view?.presentScene(nextlevel)
                
            }else{ //You lost :(
                let nextlevel = GameScene4(fileNamed: "GameScene")
                self.view?.presentScene(nextlevel)
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            let pos = t.location(in: self)
            let applyRestitution = childNode(withName: "applyRestitution")
            let applyForce = childNode(withName: "applyForce")
            let reverseGravity = childNode(withName: "reverseGravity")
            
            switch didClickIcon{
            case 1:
                applyRestitution?.position = pos
                break
            case 2:
                applyForce?.position = pos
                break
            case 3:
                reverseGravity?.position = pos
                break
            default:
                break
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        didClickIcon = 0
    }
    
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
        let goal = childNode(withName: "goal")
        let edgy = childNode(withName: "edgy")
        let applyRestitution = childNode(withName: "applyRestitution")
        let applyForce = childNode(withName: "applyForce")
        let reverseGravity = childNode(withName: "reverseGravity")
        
        //MARK: Crashing prevention
        //This prevents the game from crashing once the powerup is poped out
        if applyRestitution?.parent != nil {
            if ((contact.bodyA.node! == applyRestitution && contact.bodyB.node! == zee)){
                zee?.physicsBody?.restitution = 1.8
                applyRestitution?.removeFromParent()
            }
        }
        if applyForce?.parent != nil {
            if ((contact.bodyA.node! == applyForce && contact.bodyB.node! == zee)){
                zee?.physicsBody?.applyImpulse(CGVector(dx: -18, dy: 0))
                applyForce?.removeFromParent()
            }
        }
        if reverseGravity?.parent != nil {
            if ((contact.bodyA.node! == reverseGravity && contact.bodyB.node! == zee)){
                self.physicsWorld.gravity = CGVector(dx: 0, dy: 4)
                reverseGravity?.removeFromParent()
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
