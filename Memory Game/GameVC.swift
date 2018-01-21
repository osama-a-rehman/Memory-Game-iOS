//
//  GameVC.swift
//  Memory Game
//
//  Created by Osama on 21/01/2018.
//  Copyright © 2018 Osama. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var gameViewHeightConstraint: NSLayoutConstraint!
    
    var labelsArray: NSMutableArray = []
    var centersArray: NSMutableArray = []
    
    var timeCount: Int = 0
    var gameTimer = Timer()
    
    var firstBlock: GameBlock!
    var secondBlock: GameBlock!
    
    var numOfBlocksSelected = 0
    
    let flipAnimationDuration = 0.5
    
    override func viewDidAppear(_ animated: Bool) {
        print("Width: \(gameView.layer.bounds.width)")
        
        initialize()
    }
    
    @IBAction func btnResetPressed(_ sender: AnyObject) {
        for view in gameView.subviews {
            view.removeFromSuperview()
        }
        
        labelsArray = []
        centersArray = []
        
        initialize()
    }
    
    // MY LOGIC
    /*func initialize(){
        let gameViewWidth = gameView.layer.bounds.width
        gameViewHeightConstraint.constant = gameViewWidth
        
        let padding: CGFloat = 4
        let blockSize = gameViewWidth/4 - padding
        
        var xValue: CGFloat = padding/2
        var yValue: CGFloat = padding/2
        
        var num: Int = 1
        
        for _ in 0..<4 {
            for _ in 0..<4{
                
                
                let blockFrame = CGRect(x: xValue, y: yValue, width: blockSize, height: blockSize)
                
                let block = GameBlock()
                block.frame = blockFrame
                block.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                block.number = num
                block.text = "\(block.number)"
                block.textAlignment = .center
                block.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                
                gameView.addSubview(block)
                
                xValue = xValue + blockSize + padding
                num += 1
                
                if num == 9 {
                    num = 1
                }
            }
            
            xValue = padding/2
            yValue = yValue + blockSize + padding
        }
    }*/

    func initialize(){
        let gameViewWidth = gameView.layer.bounds.width
        gameViewHeightConstraint.constant = gameViewWidth
        
        let padding: CGFloat = 4
        let blockSize = gameViewWidth/4 - padding
        
        var xCen: CGFloat = blockSize/2 + padding/2
        var yCen: CGFloat = blockSize/2 + padding/2
        
        var num: Int = 1
        
        for _ in 0..<4 {
            for _ in 0..<4{
                let blockFrame = CGRect(x: 0, y: 0, width: blockSize, height: blockSize)
                
                let blockCenterPoint = CGPoint(x: xCen, y: yCen)
                
                let block = GameBlock()
                block.frame = blockFrame
                block.center = blockCenterPoint
                block.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                block.number = num
                block.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                block.text = "?"
                block.textAlignment = .center
                block.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                block.isUserInteractionEnabled = true
                block.isFound = false
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(blockTapped(_:)))
                gestureRecognizer.numberOfTapsRequired = 1
                block.addGestureRecognizer(gestureRecognizer)
                
                gameView.addSubview(block)
                labelsArray.add(block)
                centersArray.add(blockCenterPoint)
                
                xCen = xCen + blockSize + padding
                num += 1
                
                if num == 9 {
                    num = 1
                }
                
               // print("\(centersArray[1])")
            }
            
            xCen = blockSize/2 + padding/2
            yCen = yCen + blockSize + padding
        }
        
        // Use them to print information about NSMutableArray elemets
        //dump(labelsArray)
        //dump(centersArray)
        randomize()
        
        /*for i in 0..<16 {
            (labelsArray[i] as! GameBlock).removeFromSuperview()
        }*/
        
        /*for i in 0..<16 {
            gameView.addSubview(labelsArray[i] as! GameBlock)
            print("\((labelsArray[i] as! GameBlock).number)")
        }*/
        
        initializeTimer()
        
    }
    
    func initializeTimer(){
        timerLabel.text = "0:00"
        timeCount = 0
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction(_ timer: Timer){
        timeCount += 1
        
        let secs = timeCount % 60
        let mins = timeCount / 60
        
        var secsString = ""
        
        if secs < 10 {
            secsString = "0\(secs)"
        }else{
            secsString = "\(secs)"
        }
        
        
        timerLabel.text = "\(mins):\(secsString)"
    }
    
    func blockTapped(_ gesture: UITapGestureRecognizer){
        let block = gesture.view as! GameBlock
        print(block.number)
        
        if block.isFound == false {
            UIView.transition(with: block, duration: self.flipAnimationDuration, options: .transitionFlipFromRight, animations: {
                
                block.text = "\(block.number)"
                block.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                
            }) { (true) in
                self.numOfBlocksSelected += 1
                
                if self.numOfBlocksSelected == 1 {
                    self.firstBlock = block
                }else {
                    self.secondBlock = block
                    
                    if self.firstBlock.number == self.secondBlock.number {
                        // Correct Blocks
                        UIView.transition(with: self.firstBlock, duration: self.flipAnimationDuration, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                            self.firstBlock.text = ":)"
                            self.firstBlock.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                            }, completion: nil)
                        
                        UIView.transition(with: self.secondBlock, duration: self.flipAnimationDuration, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                            self.secondBlock.text = ":)"
                            self.secondBlock.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                            }, completion: nil)
                        
                        self.firstBlock.isFound = true
                        self.secondBlock.isFound = true
                    }else{
                        UIView.transition(with: self.firstBlock, duration: self.flipAnimationDuration, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                            self.firstBlock.text = "?"
                            self.firstBlock.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                            }, completion: nil)
                        
                        UIView.transition(with: self.secondBlock, duration: self.flipAnimationDuration, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                            self.secondBlock.text = "?"
                            self.secondBlock.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                            }, completion: nil)
                    }
                    
                    self.numOfBlocksSelected = 0
                }
            }
        }
    }
    
    func randomize(){
        /*let numberOfElements = 16
        
        for i in 0..<numberOfElements {
            let randomIndex = Int(arc4random() % 16)
            
            var temp = labelsArray[i]
            labelsArray[i] = labelsArray[randomIndex]
            labelsArray[randomIndex] = temp
            
            temp = centersArray[i]
            centersArray[i] = centersArray[randomIndex]
            centersArray[randomIndex] = temp
        }*/
        
        for block in labelsArray {
            let randomIndex = Int(arc4random()) % centersArray.count
            let randomCenter = centersArray[randomIndex] as! CGPoint
            
            (block as! GameBlock).center = randomCenter
            centersArray.removeObject(at: randomIndex)
            
        }
        
        /*let randomNumber = arc4random() % 10
        
        print("Random: \(randomNumber)")*/
    }
}

