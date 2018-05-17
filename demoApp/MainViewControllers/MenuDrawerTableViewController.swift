import UIKit

class MenuDrawerTableViewController: UITableViewController {

    let menuOptions = ["Category Search", "Map Options"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    /*
     * Table view managment
     */
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return menuOptions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppStrings.DRAWER_CELL_IDENTIFIER_, for: indexPath)

        cell.textLabel?.text = menuOptions[indexPath.row]
        
        return cell
    }
 

    
    /**
    *   Do appropriate actions according to selected row.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch(indexPath.row){
        case 0:
            performSegue(withIdentifier: AppStrings.MENU_TO_CATEGORY_SEGUE_, sender: self)
        case 1:
            performSegue(withIdentifier: AppStrings.MENU_TO_OPTIONS_SEGUE, sender: self)
        default:
                print("No such option!")
        }
    }
   

    
    

}
