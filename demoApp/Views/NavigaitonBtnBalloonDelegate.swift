//
//  NavigaitonBtnClickedDelegate.swift
//  demoApp
//
//  Created by Tomasz Kot on 06.05.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import Foundation
import UIKit

/**
 *  Custom protocol for callbacks when 'navigate' button on
 *  custom balloon is clicked
 */
protocol NavigaitonBtnBalloonDelegate {
    func navigationBtnClickedAction(view: UIButton)
}
