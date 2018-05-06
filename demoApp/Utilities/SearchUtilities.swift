//
//  CategorySearchUtilities.swift
//  demoApp
//
//  Created by Tomasz Kot on 29.04.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit
import TomTomOnlineSDKSearch

/**
 * Class which shares method for category and general search.
 *
 */
class SearchUtilities: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    // the delegate to which results of the general/category search are returned
    var  callBackDelegate: TTSearchDelegate
    var categorySelected = String()
    
     init(delegateVC delegate: TTSearchDelegate){
        self.callBackDelegate = delegate
        super.init()
        self.configLocManagerAndAskForPerm()
    }
    
    /**
    *   Method filters the results of category search and returns only results
    *   which are suitable to given category string.
    */
    func filterThroughResultArray(resultArray: Array<TTSearchResult>, categoryName category: String) -> Array<TTSearchResult>{
        
        let categoryLower = category.lowercased()
        //todo: comparing strings may be ineffective -> another way?
        switch categoryLower{
        case "cash dispenser":
            self.categorySelected = categoryLower
        case "petrol station":
            self.categorySelected = categoryLower
        case "restaurant":
             // dla uproszczenia pomijam steak housy... thai i inne
            self.categorySelected = categoryLower
        default:
            return resultArray
        }
       
        return resultArray.filter(predicate)
    }

    /**
     *  Predicate (Java) used to filter throug result array in
     *  filterThroughResultArray method.
     */
    private func predicate(singleResult: TTSearchResult) -> Bool{
        //todo: think over this strange construction
        for classification in singleResult.poi.classifications{
            for classificationName in classification.classificationNames{
                if(classificationName.name == self.categorySelected){
                    return true
                }
            }
        }
        return false
    }
    
    /**
    * Method for configurating location manager.
    *  For simplicity this has to be here.
    */
    private func configLocManagerAndAskForPerm(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /**
    * Method for performing category search.
    */
    func performCategorySearch(withQuery query: String?) {
        let queryBuilder = TTSearchQueryBuilder.create(withTerm: query)
        let search = TTSearch()
        queryBuilder?.withCategory(true)
        queryBuilder?.withPosition((locationManager.location?.coordinate)!)
        let searchQuery: TTSearchQuery? = queryBuilder?.build()
        search.search(with: searchQuery, withAsyncDelegate: callBackDelegate)
    }
    
    /**
    * Method for performing general(not limited by current location) search.
    */
    func perfomGeneralSearch(withQuery query: String?){
        // this is just general searching not limited in any way
        // for 'category search' please use btn in main menu
        let search = TTSearch()
        let queryBuilder = TTSearchQueryBuilder.create(withTerm: query)
        let searchQuery: TTSearchQuery? = queryBuilder?.build()
        search.search(with: searchQuery, withAsyncDelegate: callBackDelegate)
    }

    
}
