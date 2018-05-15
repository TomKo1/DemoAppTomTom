import UIKit

/**
 * ViewController responsible for setting options of the map.
 *  Now it uses UserDefaults to strore options
 *  but if there were more options I would use some sort of
 *  file visible only for app to store it.
 */
class OptionsViewController: UIViewController {
    
    // useful methods
    let projectHelper = ProjectHelpers()

    @IBOutlet weak var enableTrafficFlowSwitch: UISwitch!
    
    @IBOutlet weak var enableIncidentsSwitch: UISwitch!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialStateDependingOnNsDefaults()
    }
  
    
    /**
    *   Switch enables traffic flow and stores that fact in UserDefaults
    */
    @IBAction func enableTrafficFlowSwtchMoved(_ sender: UISwitch) {
        overrideUserDefaults(switchRef: enableTrafficFlowSwitch, key: AppStrings.ENABLE_TRAFFIC_FLOW_CONST_)
    }
    
    /**
    *  Switch enables incidents and stores that fact in UserDefaults
    */
    @IBAction func incidentsEnableSwitchMoved(_ sender: UISwitch) {
        overrideUserDefaults(switchRef: enableIncidentsSwitch, key: AppStrings.ENABLE_INCIDENTS_CONST_)
    }
    
    /**
    *   Overrides UserDefaults for specific key
    */
    private func overrideUserDefaults(switchRef: UISwitch, key: String){
        if(switchRef.isOn){
            projectHelper.putToUserDefaults(key: key, value: true)
        }else{
            projectHelper.putToUserDefaults(key: key, value: false)
        }
    }
    
    /**
     *  Resotres the previous state (if there was any)
     */
    public func setInitialStateDependingOnNsDefaults(){
        if(projectHelper.readFromUserDefaults(key: AppStrings.ENABLE_TRAFFIC_FLOW_CONST_)){
            enableTrafficFlowSwitch.setOn(true, animated: true)
        }else{
            enableTrafficFlowSwitch.setOn(false, animated: true)
        }
     
        if(projectHelper.readFromUserDefaults(key: AppStrings.ENABLE_INCIDENTS_CONST_)){
            enableIncidentsSwitch.setOn(true, animated: true)
        }else{
            enableIncidentsSwitch.setOn(false, animated: true)
        }
    }



}
