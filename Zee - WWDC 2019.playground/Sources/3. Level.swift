import Foundation
import SpriteKit
import PlaygroundSupport

public class GameScene3: SKScene, SKPhysicsContactDelegate{
    
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
        let applyRestitution = createPowerup(type: "applyRestitution", size: CGSize(width: 50, height: 50), pos: CGPoint(x: 125, y: 185))
        addChild(applyRestitution)
        
        let blank1 = createPowerup(type: "applyForce", size: CGSize(width: 50, height: 50), pos: CGPoint(x: -125, y: 185))
        blank1.alpha = 0.3
        addChild(blank1)
        
        let blank2 = createPowerup(type: "reverseGravity", size: CGSize(width: 50, height: 50), pos: CGPoint(x: 0, y: 185))
        blank2.alpha = 0.3
        addChild(blank2)
        
        //MARK: Goal
        let goal = createGoal(size: CGSize(width: 75, height: 78), pos: CGPoint(x: -312.5, y: -179))
        goal.xScale = goal.xScale * -1
        addChild(goal)
        
        //MARK: Edgy
        let edgy = createEdgy(size: CGSize(width: 50, height: 50), pos: CGPoint(x: -300, y: -77))
        addChild(edgy)
        
        //MARK: Zee
        let zee = createZee(size: CGSize(width: 50, height: 50), pos: CGPoint(x: -305, y: 57))
        addChild(zee)
        
        //MARK: Plataform 1
        let plataform1 = createPlataform(size: CGSize(width: 116, height: 15), pos: CGPoint(x: -311, y: -225.5))
        addChild(plataform1)
        
        //MARK: Plataform 2
        let plataform2 = createPlataform(size: CGSize(width: 190, height: 15), pos: CGPoint(x: -305, y: 24.5))
        addChild(plataform2)
        
        //MARK: Plataform 3
        let plataform3 = createPlataform(size: CGSize(width: 15, height: 200), pos: CGPoint(x: -32.5, y: -35))
        addChild(plataform3)
        
        //MARK: playButton Button
        let playButton = createPlayButton()
        addChild(playButton)
        
        //MARK: Level Label
        let st = startText(level: 3, array: levelTitles)
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
    
    var didClickIcon: Int = 0
    
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
            let tip = instruction(level: 3)
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
                    zee?.physicsBody?.velocity = CGVector(dx: 400, dy: 0)
                    playButton?.isHidden = true
                }
                //MARK: Crashing prevention
                if applyRestitution?.parent != nil{
                    if (applyRestitution?.contains(pos))!{
                        didClickIcon = 3
                    }
                }
                    if (applyForce?.contains(pos))!{
                        didClickIcon = 1
                    }
                    if (reverseGravity?.contains(pos))!{
                        didClickIcon = 2
                    }
            }
        }else{
            //This if only happens when the level ends either win or lose, so now i'll check it
            if win { //You won!
                let nextlevel = GameScene4(fileNamed: "GameScene")
                self.view?.presentScene(nextlevel)
                
            }else{ //You lost :(
                let nextlevel = GameScene3(fileNamed: "GameScene")
                self.view?.presentScene(nextlevel)
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            let pos = t.location(in: self)
            let applyRestitution = childNode(withName: "applyRestitution")
            let ma = childNode(withName: "notavailable")
            
            if didClickIcon == 1{
                let message = availableorlearned(control: "notavailable")
                if ma?.parent != nil{
                    ma?.removeFromParent()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    message.removeFromParent()
                }
                addChild(message)
            }else if didClickIcon == 2{
                let message = availableorlearned(control: "notavailable")
                if ma?.parent != nil{
                    ma?.removeFromParent()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    message.removeFromParent()
                }
                addChild(message)
            }else if didClickIcon == 3{
                applyRestitution?.position = pos
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
        let applyRestitution = childNode(withName: "applyRestitution")
        let goal = childNode(withName: "goal")
        let edgy = childNode(withName: "edgy")
        
        //MARK: Crashing prevention
        //This prevents the game from crashing once the powerup is poped out
        if applyRestitution?.parent != nil {
            
            if ((contact.bodyA.node! == applyRestitution && contact.bodyB.node! == zee)){
                zee?.physicsBody?.restitution = 1.8
                applyRestitution?.removeFromParent()
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
