//
//  CustomBalloonsView.swift
//  demoApp
//
//  Created by Tomasz Kot on 03.05.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit
import TomTomOnlineSDKMaps

/**
 *  Class representing and managing custom balloon view which
 *  has 'navigation' button and label.
 */
class CustomBalloonsView: UIView,TTCalloutView {
    
    var annotation: TTAnnotation!
    // delegate to be informed after navigation button was clicked
    var delegate: NavigaitonBtnBalloonDelegate!
    
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }

    
    @IBAction func navigateBtnClicked(_ sender: UIButton) {
        delegate.navigationBtnClickedAction(view: sender)
    }
    
    @IBOutlet weak var navigationBtn: UIButton!
    
    public func setDescription(description: String!){
        self.label.text = description
    }
    
    
    private func commonInit() {
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.black.cgColor
        layer.opacity = 1
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 1
    }
    
}
