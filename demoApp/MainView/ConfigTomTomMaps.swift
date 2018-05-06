//
//  ConfigTomTomMaps.swift
//  demoApp
//
//  Created by Tomasz Kot on 28.04.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit
import MapKit
import TomTomOnlineSDKMaps
import TomTomOnlineSDKSearch
import TomTomOnlineSDKRouting
/**
 *  Class just for configurating TomTomMapView.
 *  Controller shouldn't do ('long') things that are not conected with displaying things/results.
 *
 */
class ConfigTomTomMaps: NSObject {
    
    let ttMapView:TTMapView
    let ttSearchResult: TTSearchResult?
    let ballonsDelegate: ViewController
    
    init(mapViewToConfig mapView: TTMapView,
            ttSearchResult: TTSearchResult?,ballonsDelegate: ViewController,
            ttMapViewDelegate: TTMapViewDelegate){
        
        //init what needs to be initialized
        ttMapView = mapView
        self.ttSearchResult = ttSearchResult
        self.ballonsDelegate = ballonsDelegate;
        self.ttMapView.delegate = ttMapViewDelegate
        
    }
    
    /**
    *   Configuration method called separately outside constructor.
    */
    func config() -> TTMapView{
        ttMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     
        restoreUserOptions()
        
        if(ttSearchResult != nil){
           
            ttMapView.center(on: ttSearchResult!.position, withZoom: 10)
            ttMapView.annotationManager?.removeAllAnnotations()
            let annotation = TTAnnotation(coordinate: ttSearchResult!.position)
            ttMapView.annotationManager?.add(annotation!)
            
        }
        
        self.ttMapView.annotationManager?.delegate = ballonsDelegate;
        
        return ttMapView
    }
    
    
    /**
    *   Restores user's options from UserDefaults ('shared preferences').
    */
    private func restoreUserOptions(){
        let projectHelpers = ProjectHelpers()
        
        if(projectHelpers.readFromUserDefaults(key: AppStrings.ENABLE_TRAFFIC_FLOW_CONST_)){
            // where is vector ?! -> default flow doesn't work with vector?
            ttMapView.trafficTile = .raster
            ttMapView.trafficType = .flow
        }
        if(projectHelpers.readFromUserDefaults(key: AppStrings.ENABLE_INCIDENTS_CONST_)){
            ttMapView.trafficType = .incidents
        }
    }
    
    
    
}
