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
    func readBoolFromUserDefaults(key: String) -> Bool {
        let preferences = UserDefaults.standard
        // bo jak nie istnieje to jest false -> domyslnie wylaczone

        return  preferences.bool(forKey: key)
    }
    
    /**
    * Method puts a boolean value into UserDefaults
    *  connected with a specific key.
    */
    func putBoolToUserDefaults( key: String, value: Bool){
        let preferences = UserDefaults.standard
        preferences.set(value, forKey: key)
        didSave(preferences: preferences)
    }
    
    /**
     * Method puts a integer value into UserDefaults
     *  connected with a specific key.
     */
    // maybe any just any instead of all methods(?)
    func putIntToUserDefaults(key: String, value: Int){
        let preferences = UserDefaults.standard
        preferences.set(value, forKey: key)
        didSave(preferences: preferences)
    }
    /**
     *  Method reads integer value from UserDefaults
     *   for specific key.
     */
    func readIntegerFromUserDefaults(key: String) -> Int {
        let preferences = UserDefaults.standard
       
        return  preferences.integer(forKey: key)
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
        let duration: Double = 3
    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }

    
    

}
