import Foundation
import MapKit
import TomTomOnlineSDKSearch
import TomTomOnlineSDKMaps
import TomTomOnlineSDKRouting
// extensions in Kotlin are simpler :(


/**
*   Extension for comparision of CLLocationCoordinate2D.
*/
extension CLLocationCoordinate2D: Equatable{

    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
}




// backdoor for testing not to perform 'normal' search (result may be diffrent in some time) -> normally TTSearchResult is read-only because it comes from server (JSON?)
extension TTSearchResult {
    convenience init(_ position: CLLocationCoordinate2D) {
        self.init()
        self.setValue(position, forKey: "position")
    }
}


// another backdoor for TTSearchResult for testing (filterThroug..)
extension TTClassification {
    convenience init(_ code: String) {
        self.init()
        self.setValue(code, forKey: "code")
    }
}
//another backdoor for
extension TTPoi {
    convenience init(_ classifications: [TTClassification]) {
        self.init()
        self.setValue(classifications, forKey: "classifications")
    }
}
// backdoor...
extension TTSearchResult {
    convenience init(_ poi: TTPoi) {
        self.init()
        self.setValue(poi, forKey: "poi")
    }
}
