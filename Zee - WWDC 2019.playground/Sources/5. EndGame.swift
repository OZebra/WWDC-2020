import Foundation
import SpriteKit
import PlaygroundSupport

public class GameScene5: SKScene, SKPhysicsContactDelegate{
    
    var state: Int!

    public override func didMove(to view: SKView) {
        
        state = 0
        self.size = view.frame.size
        backgroundColor = UIColor.white
        
        let background = createBG()
        addChild(background)
        
        let label = SKLabelNode()
        label.text = "You did it!"
        label.position = CGPoint(x: 0, y: 90)
        label.fontName = "BalooChettan-Regular"
        label.fontColor = UIColor.white
        label.fontSize = 30
        label.alpha = 0
        label.run(SKAction.fadeIn(withDuration: 3))
        addChild(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let label1 = SKLabelNode()
            label1.text = "Now is your time to build something great"
            label1.position = CGPoint(x: 0, y: 40)
            label1.fontName = "BalooChettan-Regular"
            label1.fontColor = UIColor.white
            label1.fontSize = 30
            label1.alpha = 0
            label1.run(SKAction.fadeIn(withDuration: 3))
            self.addChild(label1)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            let label2 = SKLabelNode()
            label2.text = "There's a whole new world of possibilities"
            label2.position = CGPoint(x: 0, y: -10)
            label2.fontName = "BalooChettan-Regular"
            label2.fontColor = UIColor.white
            label2.fontSize = 30
            label2.alpha = 0
            label2.run(SKAction.fadeIn(withDuration: 3))
            self.addChild(label2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
            let label2 = SKLabelNode()
            label2.text = "Explore it!"
            label2.position = CGPoint(x: 0, y: -110)
            label2.fontName = "BalooChettan-Regular"
            label2.fontColor = UIColor.white
            label2.fontSize = 60
            label2.alpha = 0
            label2.run(SKAction.fadeIn(withDuration: 3))
            self.addChild(label2)
        }
        
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
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    public override func update(_ currentTime: TimeInterval) {
    }
}
