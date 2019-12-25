//
//  RouteManager.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/23/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Constants

let RouteCacheKey = "RouteCacheKey"

class RouteManager {

    // MARK: - Properties

    private var locations = [String : Location]()
    var locationCount: Int {
        return locations.count
    }
    var knockedCount: Int {
        var result = 0
        for curKey in Array(locations.keys) {
            if locations[curKey]?.hasKnocked == true {
                result += 1
            }
        }
        return result
    }
    var allKeys: [String] {
        return Array(locations.keys)
    }
    var allValues: [Location] {
        return Array(locations.values)
    }
    var locationsSortedByAddress: [Location] {
        return Array(locations.values).sorted(by: { $0.formatedName < $1.formatedName })
    }

    // MARK: - Init

    static let shared = RouteManager()

    init() {
        loadRoute()
    }

    // MARK: - Saving / Loading

    func saveRoute() {
        let routeData = NSKeyedArchiver.archivedData(withRootObject: locations)
        UserDefaults.standard.set(routeData, forKey: RouteCacheKey)
        UserDefaults.standard.synchronize()
    }

    func loadRoute() {
         if let routeData = UserDefaults.standard.data(forKey: RouteCacheKey) {
            if let cachedRoute = NSKeyedUnarchiver.unarchiveObject(with: routeData) as? [String : Location] {
                locations = cachedRoute
            }
        }
    }

    // MARK: - Location Management

    func add(location: Location) {
        let guid = RouteManager.guidFor(location: location)
        locations[guid] = location
    }

    func remove(location: Location) {
        let guid = RouteManager.guidFor(location: location)
        locations.removeValue(forKey: guid)
    }

    func removeAll() {
        locations.removeAll()
    }

    func locationFor(guid: String) -> Location? {
        return locations[guid]
    }

    // MARK: - Helpers

    class func guidFor(annotation: MKAnnotation) -> String {
        return RouteManager.guidFor(coordinate: annotation.coordinate)
    }

    class func guidFor(location: Location) -> String {
        return "\(location.latitude),\(location.longitude)"
    }

    class func guidFor(coordinate: CLLocationCoordinate2D) -> String {
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }

}
