//
//  ProjectHelpers.swift
//  demoApp
//
//  Created by Tomasz Kot on 02.05.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit


/**
 * Class prividing useful methods used all over the project.
 *
 */
class ProjectHelpers: NSObject {
    
    /**
    *  Method reads boolean value from UserDefaults
    *   for specific key.
    */
    func readFromUserDefaults(key: String) -> Bool {
        let preferences = UserDefaults.standard
        // bo jak nie istnieje to jest false -> domyslnie wylaczone
        return  preferences.bool(forKey: key)
    }
    
    /**
    * Method puts a boolean value into UserDefaults
    *  connected with a specific key.
    */
    func putToUserDefaults( key: String, value: Bool){
        let preferences = UserDefaults.standard
        preferences.set(value, forKey: key)
        didSave(preferences: preferences)
    }
    
    
    /**
    * Helper for putToUserDefaults method which checks if
    * the UserDefault was saved correctly.
    */
    private func didSave(preferences: UserDefaults){
        let didSave = preferences.synchronize()
        if !didSave{
            //todo: toast/exception
            print("Preferences could not be saved!")
        }
    }
    
    /**
    * Method to show a Anroid-like Toast.
    */
    public func showToast(viewController: UIViewController!, message: String!){
        
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        viewController.present(alert, animated: true)
        
        // duration in seconds
        let duration: Double = 5
    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }

    
    

}
