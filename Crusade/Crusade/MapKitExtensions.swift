//
//  MapKitExtensions.swift
//

import Foundation
import MapKit
import CoreLocation

// MARK: - MKMultiPoint

public extension MKMultiPoint {

    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }

}

extension MKPointAnnotation {

    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }

}
