//
//  CategorySearchViewController.swift
//  demoApp
//
//  Created by Tomasz Kot on 28.04.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit
import TomTomOnlineSDKSearch

//todo:  extract delegate : )
class CategorySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TTSearchDelegate {

    var searchQuery:String? = String()
    var resultArray: Array = Array<TTSearchResult>()
    
    var categoryIndex: Int = -1 //todo: consider Optional
    var selectedResult: TTSearchResult = TTSearchResult()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categorySearchUtilities = SearchUtilities(delegateVC: self)
        categorySearchUtilities.performCategorySearch(withQuery: searchQuery)
    
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /**
    * Receives results of category search and displays them or displays
    * UIAlertDialog ('Toast') informing that there are no data.
    */
    func search(_ search: TTSearch!, completedWithResult result: [TTSearchResult]!) {
        let categorySearchUtilities = SearchUtilities(delegateVC: self)
        resultArray = categorySearchUtilities.filterThroughResultArray(resultArray: result, categoryIndex: categoryIndex)
        if(resultArray.isEmpty){
            let projectHelpers = ProjectHelpers()
                projectHelpers.showToast(viewController: self, message: "No results available!")
            }else{
                tableView.reloadData()
            }
    }
    
    /**
    *   Called when there is an error while category search.
    */
    func search(_ search: TTSearch!, failedWithError error: TTResponseError!) {
        let projectHelpers = ProjectHelpers()
        projectHelpers.showToast(viewController: self, message: "Error while castegory search occured! Please try later.")
    }

    /************************************
    * Table view managment
    ************************************/
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //todo:implement my own UITableView
        //todo: add reusable table view
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let result = resultArray[indexPath.row]
        //todo: give name, address and distance :) -> custom view
        let textToShow = "\(result.poi.name) \(result.distance.rounded()) meters"
        cell.textLabel?.text = textToShow
        return cell
    }
    
    /**
    *   Performs a segue when user taps the result & and shows it.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedResult = resultArray[indexPath.row]
        performSegue(withIdentifier: "segueFromCategoryToMap", sender: self)
    }
    
    /**
    *   Passes data to be displayed on the map after category search.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // !!!! forced type converstion may be dangerous !!!!
        if(segue.destination is ViewController){
            let mapViewController = segue.destination as! ViewController
            mapViewController.objectFromCategorySearch = self.selectedResult
        }
    }
    
  
    
}
