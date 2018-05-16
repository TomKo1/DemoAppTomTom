//
//  CategorySelectViewController.swift
import UIKit

/**
 *  Controller of TableView in which we can select a category in which we want to search.
 */
class CategorySelectViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var searchQuery:String?
    // basic categories in which we can choose while category search
    let categoryList = ["Petrol Station", "Restaurant", "Cash dispenser"]
    //selected category name or nil
    var categoryIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /*
     *    Methods preparing cells for TableView
     */
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppStrings.CATEGORY_SELECT_CELL_IDENTIFIER )
        cell?.textLabel?.text = categoryList[indexPath.row]
        
        return cell!
    }

    /**
    *   Method from UITableViewDelegate, in this case it performs a segue in
    *   order to show category search results.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.categoryIndex =  indexPath.row
        performSegue(withIdentifier: AppStrings.CATEGORY_SELECT_TO_RESULTS_SEGUE, sender: self)
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
