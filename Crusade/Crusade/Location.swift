//
//  Location.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/23/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import Foundation
import MapKit

// MARK: - Constants


let LatitudeCacheKey = "LatitudeCacheKey"
let LongitudeCacheKey = "LongitudeCacheKey"
let StreetNumberCacheKey = "StreetNumberCacheKey"
let StreetNameCacheKey = "StreetNameCacheKey"
let HasKnockedCacheKey = "HasKnockedCacheKey"

class Location: NSObject, NSCoding {

    // MARK: - Properties

    private var latitudeString = "0"
    var latitude: Double {
        return Double(latitudeString)!
    }
    private var longitudeString = "0"
    var longitude: Double {
        return Double(longitudeString)!
    }
    var annotation: MKPointAnnotation {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return MKPointAnnotation(coordinate: coordinate)
    }
    var formatedName: String {
        return "\(streetNumber) \(streetName)"
    }
    var streetNumber = ""
    var streetName = ""
    var hasKnocked = false

    // MARK: - Init

    convenience init(streetNumber: String, streetName: String, coordinate: CLLocationCoordinate2D) {
        self.init()
        self.streetNumber = streetNumber
        self.streetName = streetName
        self.latitudeString = "\(coordinate.latitude)"
        self.longitudeString = "\(coordinate.longitude)"
    }

    override init() {
        super.init()
    }

    // MARK: NSCoding

    required init?(coder decoder: NSCoder) {
        if let cachedLatitude = decoder.decodeObject(forKey: LatitudeCacheKey) as? String {
            latitudeString = cachedLatitude
        }
        if let cachedLongitude = decoder.decodeObject(forKey: LongitudeCacheKey) as? String {
            longitudeString = cachedLongitude
        }
        if let cachedNumber = decoder.decodeObject(forKey: StreetNumberCacheKey) as? String {
            streetNumber = cachedNumber
        }
        if let cachedStreet = decoder.decodeObject(forKey: StreetNameCacheKey) as? String {
            streetName = cachedStreet
        }
        hasKnocked = decoder.decodeBool(forKey: HasKnockedCacheKey)
    }

    public func encode(with coder: NSCoder) {
        coder.encode(latitudeString, forKey: LatitudeCacheKey)
        coder.encode(longitudeString, forKey: LongitudeCacheKey)
        coder.encode(streetNumber, forKey: StreetNumberCacheKey)
        coder.encode(streetName, forKey: StreetNameCacheKey)
        coder.encode(hasKnocked, forKey: HasKnockedCacheKey)
    }

}
