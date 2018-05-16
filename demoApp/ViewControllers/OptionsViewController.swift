import UIKit
import TomTomOnlineSDKMaps

/**
 * ViewController responsible for setting options of the map.
 *  Now it uses UserDefaults to strore options
 *  but if there were more options I would use some sort of
 *  file visible only for app to store it.
 */
class OptionsViewController: UIViewController {
    
    let projectHelper = ProjectHelpers()

    @IBOutlet weak var enableTrafficFlowSwitch: UISwitch!
    
    @IBOutlet weak var enableIncidentsSwitch: UISwitch!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialStateDependingOnNsDefaults()
    }
  
    
    @IBAction func enableTrafficFlowSwtchMoved(_ sender: UISwitch) {
        overrideSwitchUserDefaults(switchRef: enableTrafficFlowSwitch, key: AppStrings.ENABLE_TRAFFIC_FLOW_CONST_)
    }
    
    @IBAction func incidentsEnableSwitchMoved(_ sender: UISwitch) {
        overrideSwitchUserDefaults(switchRef: enableIncidentsSwitch, key: AppStrings.ENABLE_INCIDENTS_CONST_)
    }
    
    
    @IBAction func languageToggle(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex){
        case 0:
            // raw value of TTLanguage is integer
            // there are also other options
            projectHelper.putIntToUserDefaults(key: AppStrings.LANGUAGE_CONST_, value: Int(TTLanguage.polish.rawValue))
        case 1:
            projectHelper.putIntToUserDefaults(key: AppStrings.LANGUAGE_CONST_, value: Int(TTLanguage.englishUS.rawValue))
        default:
            // polish by default
            projectHelper.putIntToUserDefaults(key: AppStrings.LANGUAGE_CONST_, value: Int(TTLanguage.polish.rawValue))
        }
    }
    
    
    /**
    *   Overrides UserDefaults for specific key
    */
    private func overrideSwitchUserDefaults(switchRef: UISwitch, key: String){
        if(switchRef.isOn){
            projectHelper.putBoolToUserDefaults(key: key, value: true)
        }else{
            projectHelper.putBoolToUserDefaults(key: key, value: false)
        }
    }
    
    /**
     *  Resotres the previous state (if there was any)
     */
    public func setInitialStateDependingOnNsDefaults(){
        if(projectHelper.readBoolFromUserDefaults(key: AppStrings.ENABLE_TRAFFIC_FLOW_CONST_)){
            enableTrafficFlowSwitch.setOn(true, animated: true)
        }else{
            enableTrafficFlowSwitch.setOn(false, animated: true)
        }
     
        if(projectHelper.readBoolFromUserDefaults(key: AppStrings.ENABLE_INCIDENTS_CONST_)){
            enableIncidentsSwitch.setOn(true, animated: true)
        }else{
            enableIncidentsSwitch.setOn(false, animated: true)
        }
    }



}
