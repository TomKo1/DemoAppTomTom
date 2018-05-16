import Foundation
import UIKit

/**
 *  Custom protocol for callbacks when 'navigate' button on
 *  custom balloon is clicked (delegate pattern)
 */
@objc protocol NavigaitonBtnBalloonDelegate {
   @objc func navigationBtnClickedAction(view: UIButton)
}
