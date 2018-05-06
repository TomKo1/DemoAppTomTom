//
//  ViewController.swift
//  demoApp
//
//  Created by Tomasz Kot on 21.04.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit
import MapKit
import TomTomOnlineSDKMaps
import TomTomOnlineSDKSearch
import TomTomOnlineSDKRouting

//tood: Map language !!!
/**
 * Main View (map) controller. If there were more delegates(more code) I would consider removing them
 * to separate classes.
 */
class ViewController: UIViewController, UISearchBarDelegate,
                        TTSearchDelegate, CLLocationManagerDelegate,
                        TTAnnotationDelegate, TTMapViewDelegate,
                        NavigaitonBtnBalloonDelegate {
    /**
    *  Fields for current user's lcoation managment.
    */
    let locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    //currently selected annotation or nil if not sleected
    var selectedAnnotation: TTAnnotation?
    //TomTom's map view
    var ttMapView:TTMapView = TTMapView()
    //fields 'injected' when there is a segue from category Search
    var objectFromCategorySearch: TTSearchResult?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configTomTomMapTiles()
        
        configLocManagerAndAskForPerm()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    *   Adds annotation representing current user locaiton.
    */
    private func addCurrentUserLocation(){
        if let coordintion2D = currentLocation?.coordinate{
            let annotation = TTAnnotation(coordinate: coordintion2D)
            ttMapView.annotationManager?.add(annotation!)
        }
    }
    
    /**
    *   Method configurating (just) TomTomMapView.
    */
    private func configTomTomMapTiles(){
        // there are many 'options' available so I extracted it to separate class doing only config
        //(not particularly good thing)
        let configurer = ConfigTomTomMaps(mapViewToConfig: ttMapView, ttSearchResult: objectFromCategorySearch, ballonsDelegate: self, ttMapViewDelegate: self)
        self.view = configurer.config()
    }
    
    /**
     *  Called when the user clicks the btn responsible for launcing searching
     */
    @IBAction func searchBtnClicked(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true,completion:  nil)
    }
    
    /**
     *   Method from UISearchBarDelegate called when the UIBarSearchButton is
     *    clicked -> perform general search.
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchUtilities = SearchUtilities(delegateVC: self)
        searchUtilities.perfomGeneralSearch(withQuery: searchBar.text)
    }
    
    /**
     *   Method from TTSearchDelegate called when 'general' search has ended and
     *   there is result available.
     */
    func search(_ search: TTSearch!, completedWithResult result: [TTSearchResult]!) {
        
        ttMapView.annotationManager?.removeAllAnnotations()
        
        addCurrentUserLocation()
        
        ttMapView.center(on: CLLocationCoordinate2D(latitude: 0, longitude: 0), withZoom: 0)
        
        for oneResult in result {
            let coordinate = oneResult.position
            let annotation = TTAnnotation(coordinate: coordinate)
            ttMapView.annotationManager?.add(annotation!)
        }
    }
    
    /**
     *   Method from TTSearchDelegate called when there is an error
     *   while 'general' (in this case) search.
     */
    func search(_ search: TTSearch!, failedWithError error: TTResponseError!) {
        //todo: Toast
    }
    
    
    /**
     *   Method from TTAnnotationDelegate called when users taps the annotation.
     */
    func annotationSelected(_ annotation: TTAnnotation) {
        selectedAnnotation = annotation
    }
   
    /**
     *   Method from CLLocationManagerDelegate protocol which is called when location is updated.
     *   I centres the map on current location or (if not available) on default location (Lodz, Poland).
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        currentLocation = locations.last
        if(self.objectFromCategorySearch == nil){
            //todo: magic number
            if let coordintion2D = currentLocation?.coordinate{
                ttMapView.center(on: coordintion2D, withZoom: 10)
                addCurrentUserLocation()
            }else{
                //todo: magic number
                let defaultCoordinationOfLodzPoland =  CLLocationCoordinate2D(latitude: 51.759, longitude: 19.458 )
                // manually add fake user location
                ttMapView.annotationManager?.add(TTAnnotation(coordinate: defaultCoordinationOfLodzPoland))
                ttMapView.center(on: defaultCoordinationOfLodzPoland , withZoom: 10)
            }
        }else{
            addCurrentUserLocation()
        }
        
    }
    
    
    /**
     *   Methods configurates location manager and ask for permission if
     *   permission for localization is not granted.
     */
    func configLocManagerAndAskForPerm(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    /**
    *   Method from TTMapViewDelegate, called when user holds finger on the screen.
    *   It adds a new annotation it this place.
    */
    func mapView(_ mapView: TTMapView, didLongPress coordinate: CLLocationCoordinate2D){
        mapView.annotationManager?.add(TTAnnotation(coordinate: coordinate))
    }

    
    /**
     *   Method from NavigationBtnBallonDelegate called when
     *   user clicks naviagtion button.
     */
    func navigationBtnClickedAction(view: UIButton ){
        if let coordinates = self.selectedAnnotation?.coordinate {
            paintTheFastestWay(coordinates: coordinates)
        }else{
            //todo: toast informing user to select sth
            print("No annotation selected!")
        }
    }

    
    /**
     *   Method builds query and determine the fastest route from
     *   user's current location to the specific point on the map.
     */
    private func paintTheFastestWay(coordinates: CLLocationCoordinate2D){
        //unwrap current (device) location
        if let currentCoordinates = currentLocation?.coordinate{
            let routeType: TTOptionTypeRoute = .fastest
            
            let query = TTRouteQueryBuilder(dest: coordinates, withOrig: currentCoordinates).withRouteType(routeType).build()
            
            let routePlanner = TTRoute()
            
            routePlanner.plan(with: query, completionHandler: {
                
                (result: TTRouteResult?, error: TTResponseError?) -> Void in
                
                if let fullRoutes = result?.routes {
                    
                    //loop just for safety -> in this app
                    // there is only one route but there are other
                    // 'options' in API where there are more routes.
                    for singleRoute in fullRoutes {
                        self.drawResultRoute( route: singleRoute)
                    }
                    
                }else{
                    //todo: Toast informin user
                    print("Result not available")
                }
            })
            
        }else{
            //todo: toast
          print("Error. Current location not available")
        }
        
    }
    /**
     *   Helper for paintTheFastestWay method which draws specific route.
     *   (clean code) -> short methods.
     */
    private func drawResultRoute( route: TTFullRoute){
        let dataSet = TTRouteDataImplem(coordinates: route.fullRoute())
        
        let ttMapRoute = TTMapRoute(routeData: dataSet)
        
        
        if let routeManager = self.ttMapView.routeManager{
            
            routeManager.removeAllRoutes()
            routeManager.add(ttMapRoute)
            
        }else{
            //todo: Toast!
            print("Error occured with route manager!")
        }
        
    }
    
    /**
     *   'Inner' class implementing TTRouteData protocol to obtain
     *      all coordinates and draw them.
     */
    private class TTRouteDataImplem :NSObject, TTRouteData {
        func fullRoute() -> [NSValue]! {
            return coordinates
        }
        
        let coordinates: [NSValue]?
        
        init( coordinates: [NSValue] ){
            self.coordinates = coordinates
        }
    }

    /**
     *   Method from TTAnnotationDelegate, called when user taps the icon on a map.
     *   @return TTCalloutView representin custom balloon
     */
    func view(forSelectedAnnotation selectedAnnotation: TTAnnotation) -> (UIView & TTCalloutView) {
        
        
        // create custom callout
        let callout = createCustomCallount(selectedAnnotation: selectedAnnotation)
        
        return callout
    }
    
    /**
     *  Heleper for func view(forSelectedAnnotation selectedAnnotation: TTAnnotation) -> (UIView & TTCalloutView)
     *  method which configurates and returns custom callout.
     */
    private func createCustomCallount(selectedAnnotation: TTAnnotation) ->( TTCalloutView & CustomBalloonsView) {
        let callout = (Bundle.main.loadNibNamed("CustomBalloon", owner: self, options: nil)?.first as? (CustomBalloonsView & TTCalloutView))!
        
        let coordinationOfClickedAnnotation = selectedAnnotation.coordinate
        
        var description = "No additional information"
        //todo: it can be done differently & code reptition
        var coordintion2D = currentLocation?.coordinate
        if(coordintion2D == nil){
            coordintion2D = CLLocationCoordinate2D(latitude: 51.759, longitude: 19.458)
        }
        if( ( objectFromCategorySearch != nil ) && coordinationOfClickedAnnotation ==
            objectFromCategorySearch?.position){
            
            description = "\(self.objectFromCategorySearch!.poi.name) | \(self.objectFromCategorySearch!.address.freeformAddress)"
            
            }else if(coordinationOfClickedAnnotation == coordintion2D){
            
                description = "You're here!"
                callout.navigationBtn.isEnabled = false
            
                    }else{
                        description = "\(selectedAnnotation.coordinate.latitude)  \(selectedAnnotation.coordinate.longitude)"
                    }
        
        callout.delegate = self
        callout.setDescription(description: description)
        return callout
    }

 
    
}

