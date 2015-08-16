//
//  GameScene.swift
//  Swap
//
//  Created by Terna Kpamber on 8/14/15.
//  Copyright (c) 2015 Terna Kpamber. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var grid: Grid!
    var playableRect: CGRect!
    var playableMargin: CGFloat
    var x_offset: CGFloat!
    var y_offset: CGFloat!
    
    var level: Int!
    
    enum GameState {
        case Starting
        case Playing
        case Choosing
    }
    
    var gameState: GameState = .Starting
    
    //cell moves
    var cell1_move_finished = true
    var cell2_move_finished = true
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16/9
        let playableWidth = size.height / maxAspectRatio
        playableMargin = (size.width - playableWidth) / 2
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
        
    }
    
    
    func drawPlayableRect(){
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.redColor()
        shape.lineWidth = 4
        addChild(shape)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        let backgroundNode = SKSpriteNode(imageNamed: "stickynote_yellow")
        backgroundNode.size = CGSize(width: size.width * 0.8, height: size.height * 0.75)
//        backgroundNode.size = frame.size
//        backgroundNode.anchorPoint = CGPointZero
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        backgroundColor = SKColor.whiteColor()
        
        if level < 0 {
            level = 0
        }else if level > 4{
            level = 4
        }
        
        grid = Grid(level: level, easy: false)
        drawGrid()
//        drawPlayableRect()
        
        self.name = "PARENT"
    }
    
    func swap(){
        
//        runAction(SKAction.runBlock({ () -> Void in
        self.cell1_move_finished = false
        self.cell2_move_finished = false
        
        let val = Int( arc4random() % 2 )
        let swap_correct = val == 1
        
        
        let swapped = self.grid.swapCell(swap_correct)
        
        let cell_1_point = swapped[0][0]
        let cell_2_point = swapped[0][1]
        
        let cell1 = self.childNodeWithName("cell_\(cell_1_point.row)\(cell_1_point.col)") as? SKSpriteNode
        let cell2 = self.childNodeWithName("cell_\(cell_2_point.row)\(cell_2_point.col)") as? SKSpriteNode
        
        let cell1_pos = CGPoint(x: CGFloat(cell_1_point.col) * 100 + playableMargin + x_offset + 50 , y: CGFloat(cell_1_point.row) * 100 + y_offset)
        let cell2_pos = CGPoint(x: CGFloat(cell_2_point.col) * 100 + playableMargin + x_offset + 50, y: CGFloat(cell_2_point.row) * 100 + y_offset)
        
        let temp_name = cell2?.name
        cell2?.name = cell1?.name
        cell1?.name = temp_name
        
        
        var adjustedLevel = level
        if adjustedLevel == 4 {
            adjustedLevel = 3
        }
        
        let halfMove = 0.3 + (3.0 - Double(adjustedLevel)) * 0.1
        let halfScale = (halfMove * 0.6) / 2.0
        let difference = halfMove * 0.4
        
        let move_cell1 = SKAction.moveTo(cell2_pos, duration: halfMove)
        let downScale = SKAction.scaleTo(0.5, duration: halfScale)
        let upScale = SKAction.scaleTo(1, duration: halfScale)
        let move_cell2 = SKAction.moveTo(cell1_pos, duration: halfMove)
        
        cell1?.runAction(SKAction.group([move_cell1, SKAction.sequence([ downScale, SKAction.waitForDuration(difference), upScale ])]), completion: { self.cell1_move_finished = true})
        cell2?.runAction(move_cell2, completion: { self.cell2_move_finished = true})
        //        }))
        
    }
    
    func simulate(count: Int) {
        var actions = [SKAction]()
        
        
        let swapAction = SKAction.runBlock(swap)
        
        var adjustedLevel = level
        if adjustedLevel == 4 {
            adjustedLevel = 3
        }
        
        let wait = SKAction.waitForDuration(0.12 + Double(3 - adjustedLevel) * 0.027)
        for _ in 0..<count{
            actions.append(swapAction)
            actions.append(wait)
        }
        runAction(SKAction.sequence(actions),
            completion: { self.gameState = .Choosing })
//        runAction(SKAction.repeatAction(SKAction.sequence([swapAction, wait]), count: count), completion: {
//            self.gameState = .Choosing
//        })
    }
    
    func drawGrid() {
        x_offset = (playableRect.width - (100 * CGFloat(grid.getSize().col)))/2.0
        y_offset = (playableRect.height - (100 * CGFloat(grid.getSize().row)))/2.0
        for (row, cell_row) in grid.getGrid().enumerate(){
            for (col, cell) in cell_row.enumerate() {
                
                let color = cell == .Closed ? SKColor.clearColor() : SKColor.clearColor()
                let node = SKSpriteNode(color: color, size: CGSize(width: 100, height: 100))
//                print(cell)
//                let texture = cell == .Closed ? SKTexture(imageNamed: "stickynote_red") : SKTexture(imageNamed: "stickynote_yellow")
//                let node = SKSpriteNode(texture: texture, size: CGSize(width: 100, height: 100))
                
                let testnode = SKLabelNode(text: "😆")
                testnode.fontSize = 80
                testnode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
//                testnode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
//                testnode.position = CGPoint(x: node.size.width/2, y: node.size.width/2)
                if cell == .Closed {
                    testnode.text = "😶"
                }
                node.addChild(testnode)
                node.name = "cell_\(row)\(col)"
//                node.anchorPoint = CGPointZero
                node.position = CGPoint(x: playableMargin + x_offset + CGFloat(col) * 100 + 50, y: y_offset + CGFloat(row) * 100)
                addChild(node)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if gameState == .Starting{
            
            gameState = .Playing
            
            let scaleAction = SKAction.scaleBy(0.5, duration: 0.3)
            
            let showAction = SKAction.repeatAction(SKAction.sequence([ scaleAction, scaleAction.reversedAction() ]), count: 5)
            
            let point = grid.getCorrectCell()
            let correct_node = childNodeWithName("cell_\(point.row)\(point.col)")
            
            correct_node?.runAction(showAction, completion: {
                
                if self.cell1_move_finished && self.cell2_move_finished {
                    var adjustedLevel = self.level
                    if adjustedLevel == 4 {
                        adjustedLevel = 3
                    }
                    self.simulate( 25 + (adjustedLevel) * 10)
                }
            })
            return
        }
        
        let selectedLocation = touches.first?.locationInNode(self)
        let selectedNode = nodeAtPoint(selectedLocation!)
        if selectedNode.name == "PARENT"{
            return
        }
        
        if gameState == .Choosing {
            
            
            let point = grid.getCorrectCell()
            let correct_node = childNodeWithName("cell_\(point.row)\(point.col)")
            
            var won = false
            won =  CGRectContainsPoint((correct_node?.frame)!, selectedLocation!)
            
            let gameOverScene = GameOverScene(size: CGSize(width: 768, height: 1024))
            gameOverScene.won = won
            gameOverScene.last_level = level
            gameOverScene.scaleMode = scaleMode
            view?.presentScene(gameOverScene, transition: SKTransition.flipHorizontalWithDuration(0.2))
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
