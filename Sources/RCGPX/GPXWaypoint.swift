//
//  GPXWaypoint.swift
//  
//
//  Created by Ryan Linn on 7/9/21.
//

import Foundation
import AEXML

/// A representation of a point on the map, with name and optional descriptors.
public struct GPXWaypoint {
    public var latitude: Double
    public var longitude: Double
    /// Elevation, in meters, of the waypoint, if known.
    public var elevation: Double?
    /// A unique name for the waypoint to be displayed in a list of GPX elements.
    public var name: String
    /// An optional, user-created detail description of the waypoint.
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

// MARK: GPXWaypoint : Codable

extension GPXWaypoint : Codable {
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case elevation = "ele"
        case name
        case gpxDescription = "desc"
        case symbol = "sym"
    }
}
