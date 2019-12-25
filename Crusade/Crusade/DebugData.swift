//
//  DebugData.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/25/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import Foundation
import CoreLocation

class DebugData {

    // MARK: - Init

    static let shared = DebugData()

    // MARK: - Populate Data

    func populateData() {
        let routeManager = RouteManager.shared
        var latitude: Double = 0
        var longitude: Double = 0
        var coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        var location = Location(streetNumber: "", streetName: "", coordinate: coordinate)

        latitude = 39.183335
        longitude = -84.426522
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6113", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.183489
        longitude = -84.426511
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6119", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.183842
        longitude = -84.426532
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6125", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184013
        longitude = -84.426479
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6131", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184570
        longitude = -84.426457
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6147", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184333
        longitude = -84.426060
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6144", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184183
        longitude = -84.426098
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6142", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.183649
        longitude = -84.426103
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6122", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.183503
        longitude = -84.426127
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6118", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.183379
        longitude = -84.426154
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6114", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.183175
        longitude = -84.426146
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6110", streetName: "Webbland Pl", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.183724
        longitude = -84.425470
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6215", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.183940
        longitude = -84.425500
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6217", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184054
        longitude = -84.425505
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6221", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184199
        longitude = -84.425486
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6225", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184336
        longitude = -84.425468
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6229", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184636
        longitude = -84.425438
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6237", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184756
        longitude = -84.425462
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6243", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184875
        longitude = -84.425435
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6245", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184769
        longitude = -84.424869
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6240", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184625
        longitude = -84.424850
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6236", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184477
        longitude = -84.424880
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6132", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.184331
        longitude = -84.424916
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "6130", streetName: "Kincaid Rd", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.185710
        longitude = -84.425827
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3239", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.185697
        longitude = -84.426018
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3237", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.185668
        longitude = -84.426176
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3235", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.185664
        longitude = -84.426357
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3233", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.185659
        longitude = -84.426539
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3229", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.185998
        longitude = -84.426351
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3230", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.186025
        longitude = -84.426193
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3232", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.186068
        longitude = -84.425778
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3238", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.186080
        longitude = -84.425571
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3242", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)

        latitude = 39.186137
        longitude = -84.425289
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location = Location(streetNumber: "3298", streetName: "Harvest Ave", coordinate: coordinate)
        routeManager.add(location: location)
    }

}
