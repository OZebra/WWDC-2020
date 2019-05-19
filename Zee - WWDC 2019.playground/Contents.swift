/*:
 
 # Zee Adventure!
 ## A quick travel through the physics of SpriteKit
 ![The cutest little ball?](markupbg.png)
 
 
 ## What is Zee Adventure?
 Zee is a brief experience into the physics world of SpriteKit. With some simples levels and a basic mechanic, the player gets to know better some of the most powerful tools of the SpriteKit, diving into a whole new world of possibilities.
 
 ## Why Zee Adventure?
 I made Zee thinking about how powerful SpriteKit really is and I wanted to show that even with simple coding you can make something great. This playground is focused on people like me, who want to explore and learn new things, I want them to pass through this experience and feel encouraged to use SpriteKit just as I did. I want them to be like, "Hey, look at these mechanics and properties. I could make something great out of it" and yet fell like they're able to do so because it's not rocket science.
 
 ## Walking through Zee Adventure!
 Zee Adventure! is composed of 4 levels. The first three levels will teach you the different powerup mechanics of the game, and the last one will defy you to solve a fun puzzle using the previous mechanics that you've learned. Drag and drop the powerups into Zee's path to make it through.
 
 ## Elements
 ![Zee's elements?](elementsbg.png)
 
 ## Final Considerations
 It's been a very rewarding experience to work in this project and I'm very proud of what I did. I really hope that this playground reached its purpose and I also hope it'll be able to inspire people to explore their ideas and potential to the top.
 
 */

import PlaygroundSupport
import SpriteKit
import AVFoundation

let fontURL = Bundle.main.url(forResource: "BalooChettan-Regular", withExtension: "ttf")
//Setting BalooChettan font, the font has openlicense and can be found at https://fonts.google.com/specimen/Baloo+Chettan
CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)

var player: AVAudioPlayer?

func playSound() {
    guard let url = Bundle.main.url(forResource: "backgroundmusic", withExtension: "mp3") else { return }
    /*
     backgroundmusic.mp3 is Positive Happy by PeriTune https://soundcloud.com/sei_peridot Creative Commons — Attribution 3.0 Unported — CC BY 3.0 http://creativecommons.org/licenses/by/3.0/ Music promoted by Audio Library https://youtu.be/TutcA4JPa7Q. Royality free music.
     */
    do{
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = player else {
            return
        }
        
        player.numberOfLoops = -1 // Makes it loop

        player.play()
        
    }catch let error {
        print(error.localizedDescription)
    }
}

playSound()
// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 800, height: 480))
if let scene = GameScene0(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    // Present the scene
    
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
