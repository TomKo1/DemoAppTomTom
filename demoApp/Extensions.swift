//
//  Extensions.swift
//  demoApp
//
//  Created by Tomasz Kot on 30.04.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import Foundation
import MapKit
// extensions in Kotlin are simpler :(


/**
*   Extension for comparision of CLLocationCoordinate2D.
*/
extension CLLocationCoordinate2D: Equatable{

    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
}

