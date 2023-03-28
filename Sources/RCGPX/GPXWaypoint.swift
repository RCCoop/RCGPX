//
//  GPXWaypoint.swift
//  
//
//  Created by Ryan Linn on 7/9/21.
//

import AEXML
import CoreLocation
import Foundation

/// A representation of a point on the map, with name and optional descriptors.
public struct GPXWaypoint: GPXFeature {
    public var name: String
    public var latitude: Double
    public var longitude: Double
    /// Elevation, in meters, of the waypoint, if known.
    public var elevation: Double?
    public var gpxDescription: String?
    /// A code for the type of marker shown on the map for this waypoint.
    /// Currently, no specific marker names are set in this library.
    public var symbol: String?

    public init(
        name: String,
        latitude: Double,
        longitude: Double,
        elevation: Double? = nil,
        description: String? = nil,
        symbol: String? = nil
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
        self.name = name
        self.gpxDescription = description
        self.symbol = symbol
    }
}

// MARK: - CoreLocation Helpers

public extension GPXWaypoint {
    var coordinate: CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    init(
        name: String,
        coordinate: CLLocationCoordinate2D,
        elevation: Double? = nil,
        description: String? = nil,
        symbol: String? = nil
    ) {
        self.name = name
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.elevation = elevation
        self.gpxDescription = description
        self.symbol = symbol
    }
}
