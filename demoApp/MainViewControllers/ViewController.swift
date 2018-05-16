import UIKit
import MapKit
import TomTomOnlineSDKMaps
import TomTomOnlineSDKSearch
import TomTomOnlineSDKRouting
//https://github.com/jonkykong/SideMenu
// using only for convinience -> normally I would try to implement it on my
// own or use built-in views
import SideMenu

/**
 * Main View (map) controller. If there were more delegates(more code) I would consider removing them (by doing so you have to make a 'class variable' not to lose it from memory and then assign it in the method)
 * to separate classes.
 */
// had issue with Node.js (server on Mac -> mixing with Yoeman/Angular) and couldn't edit style JSON easily to make dark theme of the map
class ViewController: UIViewController, UISearchBarDelegate,
                        TTSearchDelegate, CLLocationManagerDelegate, TTMapViewDelegate,
                        NavigaitonBtnBalloonDelegate, TTAnnotationDelegate {

    // Fields for current user's lcoation managment.
    let locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    //  TomTom's map view
    var ttMapView:TTMapView = TTMapView()
    //  Fields 'injected' when there is a segue from category Search
    var objectFromCategorySearch: TTSearchResult?
  
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configLocManagerAndAskForPerm()
        
        self.configTomTomMapTiles()
        
        // config drawer
        self.configDrawer()
        
        // display
        self.view = ttMapView;
    }
    
    /**
    *   Configurates drawer
    */
    private func configDrawer(){
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        // futher code...

    }
    
    
    
    /**
     *   Configuration method called separately outside constructor.
     */
    //tested
    func configTomTomMapTiles() {
        
        ttMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        ttMapView.delegate = self
        
        paintResultOfCategorySearchIfPresent()
        
        ttMapView.annotationManager.delegate = self
    }
    
    private func paintResultOfCategorySearchIfPresent(){
        if(objectFromCategorySearch != nil){
            
            ttMapView.center(on: objectFromCategorySearch!.position, withZoom: 10)
            ttMapView.annotationManager.removeAllAnnotations()
            
            let annotation = createCustomAnnotation(withCoordinates: objectFromCategorySearch!.position, withName: AppStrings.MAP_ICON_JPG, withTag: "objectFound")
            
            ttMapView.annotationManager.add(annotation!)
            
        }
    }
    
    
    // because of the 'back button' from options
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         restoreUserOptions()
    }
    
    
    
    
    /**
     *   Restores user's options from UserDefaults ('shared preferences').
     */
    private func restoreUserOptions(){
        let projectHelpers = ProjectHelpers()
        
        if(projectHelpers.readBoolFromUserDefaults(key: AppStrings.ENABLE_TRAFFIC_FLOW_CONST_)){
            //vector?
            ttMapView.trafficTile = .raster
            ttMapView.trafficType = .flow
            
            ttMapView.trafficFlowOn = true
            }else{
                ttMapView.trafficFlowOn = false
            }
        if(projectHelpers.readBoolFromUserDefaults(key: AppStrings.ENABLE_INCIDENTS_CONST_)){
           
            ttMapView.trafficType = .incidents
            ttMapView.trafficIncidentsOn = true
            
            }else{
                ttMapView.trafficIncidentsOn = false
            }
    }
    
    
    /**
     * helper 'factory (not at all) method' creating TTAnnotations with specific image
     *
     */
    //tested
    func createCustomAnnotation(withCoordinates: CLLocationCoordinate2D!,withName: String!, withTag: String!) -> TTAnnotation?{
        
        let image = UIImage(named:
            withName)
        let annotation = TTAnnotation(coordinate: withCoordinates, image: image!, tag: withTag, anchor: TTAnnotationAnchor.center, type: TTAnnotationType.focal)
        
        return annotation
    }
    
    
    /**
     *  Called when the user clicks the btn responsible for launcing searching
     */
    //todo: test -> bounding & action
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
    func search(_ search: TTSearch, completedWithResult result: [TTSearchResult]) {
        
        ttMapView.annotationManager.removeAllAnnotations()
        
        if let coordintion2D = currentLocation?.coordinate{
            addCurrentUserLocation(currentLocation: coordintion2D, center: false)
        }
        
        ttMapView.center(on: CLLocationCoordinate2D(latitude: 0, longitude: 0), withZoom: 0)
        
        addAppriopriateAnnotationsFromResult(result: result)
        
    }
    
    private func addAppriopriateAnnotationsFromResult(result: [TTSearchResult]){
        for oneResult in result {
            let coordinate = oneResult.position
            
            let annotation = createCustomAnnotation(withCoordinates: coordinate, withName: AppStrings.MAP_ICON_JPG, withTag: "resultCategory")
            
            
            ttMapView.annotationManager.add(annotation!)
        }
    }
    
    
    
    /**
     *   Method from TTSearchDelegate called when there is an error
     *   while 'general' (in this case) search.
     */
    func search(_ search: TTSearch, failedWithError error: TTResponseError) {
       let projectHelpers = ProjectHelpers()
        projectHelpers.showToast(viewController: self, message: "Error while searching. Please try again.")
    }
    
   
    /**
     *   Method from CLLocationManagerDelegate protocol which is called when location is updated.
     *   I centres the map on current location or (if not available) on default location (Lodz, Poland).
     *   There is also TomTom's solution:
     *     self.ttMapView.isShowsUserLocation = true
     *       ttMapView.userLocation (...)
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        currentLocation = locations.last
            //todo: magic number
            if let coordintion2D = currentLocation?.coordinate{
                addCurrentUserLocation(currentLocation: coordintion2D, center: true)
            }else{
                
                let defaultCoordinationOfLodzPoland =  CLLocationCoordinate2D(latitude: AppValues.lodzLatitude, longitude: AppValues.lodzLongitude )
                addCurrentUserLocation(currentLocation: defaultCoordinationOfLodzPoland, center: true)
            }
    }
    
    /**
     *   Adds annotation representing current user locaiton.
     */
    private func addCurrentUserLocation(currentLocation: CLLocationCoordinate2D, center: Bool){
    
            if(self.objectFromCategorySearch == nil && center){
                ttMapView.center(on: currentLocation, withZoom: 10)
            }
            let annotation = createCustomAnnotation(withCoordinates: currentLocation, withName: AppStrings.CURRENT_LOCATION_JPG,withTag: "currentLocation")
        
        ttMapView.annotationManager.add(annotation!)
        
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
        mapView.annotationManager.add(TTAnnotation(coordinate: coordinate))
    }

    
    /**
     *   Method from NavigationBtnBallonDelegate called when
     *   user clicks naviagtion button.
     */
    func navigationBtnClickedAction(view: UIButton ){
        if let coordinates = self.selectedAnnotation?.coordinate {
            paintTheFastestWay(coordinates: coordinates)
        }else{
           ProjectHelpers().showToast(viewController: self, message: "No annotation selected!")
        }
    }

    
    /**
     *   Method builds query and determine the fastest route from
     *   user's current location to the specific point on the map.
     */
    public func paintTheFastestWay(coordinates: CLLocationCoordinate2D){
        //unwrap current (device) location
        if let currentCoordinates = currentLocation?.coordinate{
            let routeType: TTOptionTypeRoute = .fastest
            
            let query = TTRouteQueryBuilder(dest: coordinates, withOrig: currentCoordinates).withRouteType(routeType).build()
            
            let routePlanner = TTRoute()
            
            routePlanner.plan(with: query, completionHandler: {
                
                (result: TTRouteResult?, error: TTResponseError?) -> Void in
                
                if let unwrappedFullRoutes = result?.routes {
                    
                    self.loopThroughFullRoutesAndDraw(fullRoutes: unwrappedFullRoutes)
                    
                }else{
                    self.showNotAvailableToast()
                }
            })
            
        }else{
          showNotAvailableToast()
        }
        
    }
    
    private func loopThroughFullRoutesAndDraw(fullRoutes: [TTFullRoute]){
        //loop just for safety -> in this app
        // there is only one route but there are other
        // 'options' in API where there are more routes.
        for singleRoute in fullRoutes {
            self.drawResultRoute( route: singleRoute)
        }
    }
    
    
    /**
     *   Helper for paintTheFastestWay method which draws specific route.
     *   (clean code) -> short methods.
     */
    private func drawResultRoute( route: TTFullRoute){
        let dataSet = TTRouteDataImplem(coordinates: route.fullRoute())
        
        let ttMapRoute = TTMapRoute(routeData: dataSet)
        
        let routeManager = self.ttMapView.routeManager
            
            routeManager.removeAllRoutes()
            routeManager.add(ttMapRoute)
            
     
        
    }
  
    
    private func showNotAvailableToast(){
        let projectHelper = ProjectHelpers()
        projectHelper.showToast(viewController: self, message: "Result not available")
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

    
    var selectedAnnotation: TTAnnotation?
    
    /**
     *   Method from TTAnnotationDelegate called when users taps the annotation.
     */
    func annotationSelected(_ annotation: TTAnnotation) {
        selectedAnnotation = annotation
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
     *  Heleper for func view(forSelectedAnnotation selectedAnnotation:)
     *  method which configurates and returns custom callout.
     */
    // try to make it shorter
    private func createCustomCallount(selectedAnnotation: TTAnnotation) ->( TTCalloutView & CustomBalloonsView) {
        let callout = (Bundle.main.loadNibNamed(AppStrings.CUSTOM_BALLOON_NAME, owner: self, options: nil)?.first as? (CustomBalloonsView & TTCalloutView))!
        
        let coordinationOfClickedAnnotation = selectedAnnotation.coordinate
        
        var description = "No additional information"

        var coordintion2D = currentLocation?.coordinate
        if(coordintion2D == nil){
            coordintion2D = CLLocationCoordinate2D(latitude: AppValues.lodzLatitude, longitude: AppValues.lodzLongitude)
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

