//
//  GPXRoute.swift
//  
//
//  Created by Ryan Linn on 3/28/23.
//

import AEXML
import CoreLocation
import Foundation

/// A representation of a route of travel.
public struct GPXRoute: GPXFeature {
    public var name: String
    public var gpxDescription: String?
    public var routePoints: [GPXRoute.Point]
    
    public init(
        name: String,
        description: String?,
        routePoints: [GPXRoute.Point]
    ) {
        self.name = name
        self.gpxDescription = description
        self.routePoints = routePoints
    }
    
    public init(
        name: String,
        description: String?,
        coordinates: [CLLocationCoordinate2D]
    ) {
        self.name = name
        self.gpxDescription = description
        self.routePoints = coordinates.map(Point.init)
    }
}

extension GPXRoute {
    public struct Point {
        public var latitude: Double
        public var longitude: Double
        
        public var coordinate: CLLocationCoordinate2D {
            get {
                CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            set {
                latitude = newValue.latitude
                longitude = newValue.longitude
            }
        }
        
        public init(
            latitude: Double,
            longitude: Double
        ) {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        public init(_ coordinate: CLLocationCoordinate2D) {
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }
    }
}
