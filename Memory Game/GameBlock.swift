//
//  GameBlock.swift
//  Memory Game
//
//  Created by Osama on 21/01/2018.
//  Copyright © 2018 Osama. All rights reserved.
//

import UIKit

class GameBlock: UILabel {
    private var _number: Int!
    private var _isFound: Bool!
    
    var number: Int {
        set {
            self._number = newValue
        }
        
        get{
            return _number
        }
    }
    
    var isFound: Bool{
        set {
            self._isFound = newValue
        }
        
        get{
            return _isFound
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
