import Foundation
import SpriteKit
import PlaygroundSupport

public class GameScene0: SKScene, SKPhysicsContactDelegate{
    
    var state: Int!
    
    public override func didMove(to view: SKView) {
        
        state = 0
        self.size = view.frame.size
        backgroundColor = UIColor.white
        
        let bg = SKSpriteNode(imageNamed: "initbackground.png")
        bg.size = CGSize(width: 800, height: 480)
        addChild(bg)
        
        let initbutton = SKSpriteNode(imageNamed: "initButton.png")
        initbutton.position = CGPoint(x: 0, y: -100)
        initbutton.size = CGSize(width: 50, height: 50)
        initbutton.name = "initbutton"
        addChild(initbutton)
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
        let button = childNode(withName: "initbutton")
        
        for t in touches{
            let pos = t.location(in: self)
            
            if (button?.contains(pos))!{
                let nextlevel = GameScene1(fileNamed: "GameScene")
                self.view?.presentScene(nextlevel)
            }
        }
    }
}
