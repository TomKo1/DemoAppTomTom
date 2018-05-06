//
//  SystemNavigationUtilities.swift
//  demoApp
//
//  Created by Tomasz Kot on 30.04.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit
import MapKit

class SystemNavigationUtilities: NSObject {

    // to avoid repetition
    static func configLocManagerAndAskForPerm(locationManagerDelegate: CLLocationManagerDelegate?) -> CLLocationManager{
        let locationManager: CLLocationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if(locationManagerDelegate != nil ){
            locationManager.delegate = locationManagerDelegate
        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        return locationManager
    }
    
    

}
