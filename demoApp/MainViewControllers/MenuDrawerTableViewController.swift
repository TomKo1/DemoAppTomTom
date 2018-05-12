//
//  MenuDrawerTableViewController.swift
//  demoApp
//
//  Created by Tomasz Kot on 12.05.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit

class MenuDrawerTableViewController: UITableViewController {

    let menuOptions = ["Category Search", "Map Options"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    /************************************
     * Table view managment
     ************************************/
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return menuOptions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)

        cell.textLabel?.text = menuOptions[indexPath.row]
        
        return cell
    }
 

    
    /**
    *   Do appropriate actions according to selected row.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch(indexPath.row){
        case 0:
            performSegue(withIdentifier: "menuToCategorySearchSegue", sender: self)
        case 1:
            performSegue(withIdentifier: "segueToMapsOptions", sender: self)
        default:
                print("No such option!")
              //performSegue(withIdentifier: "segueToMapsOptions", sender: self)
        }
    }
   

    
    

}
