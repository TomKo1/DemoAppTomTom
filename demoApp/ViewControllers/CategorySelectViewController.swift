//
//  CategorySelectViewController.swift
//  demoApp
//
//  Created by Tomasz Kot on 29.04.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit

/**
 *  Controller of TableView in which we can select a category in which we want to search.
 */
//tested
class CategorySelectViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var searchQuery:String?
    // basic categories in which we can choose while category search
    let categoryList = ["Petrol Station", "Restaurant", "Cash dispenser"]
    //slsected category name or nil s
    var categoryIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /***************************************************************
    *   Methods preparing cells for TableView
    ****************************************************************/
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell1")
        cell.textLabel?.text = categoryList[indexPath.row]
        
        return cell
    }

    /**
    *   Method from UITableViewDelegate, in this case it performs a segue in
    *   order to show category search results.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.categoryIndex =  indexPath.row
        performSegue(withIdentifier: "results", sender: self)
    }
    
    /**
    *   Prepare data 'injection' for CategorySearch
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is CategorySearchViewController){
            let categorySearchViewController = segue.destination as! CategorySearchViewController
            categorySearchViewController.searchQuery = self.searchQuery
            categorySearchViewController.categoryIndex = self.categoryIndex
        }
    }

}
