//
//  GameOverScene.swift
//  Swap
//
//  Created by Terna Kpamber on 8/15/15.
//  Copyright © 2015 Terna Kpamber. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    var won: Bool!
    var last_level: Int!
    
    override func didMoveToView(view: SKView) {
        var text: String
        if won == true {
            text = "You won"
        }
        else{
            text = "You lost"
        }
        let label = SKLabelNode(text: text)
        label.fontName = "Marker Felt Thin"
        label.fontSize = 40
        label.position = CGPoint(x: size.width/2, y: 400)
        
        addChild(label)
        
        let label2 = SKLabelNode(text: "TAP TO CONTINUE")
        label2.fontName = "Marker Felt Thin"
        label2.fontSize = 40
        label2.position = CGPoint(x: size.width/2, y: 200)
        
        addChild(label2)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let gameScene = GameScene(size: CGSize(width: 768, height: 1024))
        if won == true {
            gameScene.level = last_level + 1
        }else{
            gameScene.level = last_level - 1
        }
        gameScene.scaleMode = scaleMode
        view?.presentScene(gameScene, transition: SKTransition.flipHorizontalWithDuration(0.2))
    }
}
