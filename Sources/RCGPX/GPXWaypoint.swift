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
    
    public init(name: String,
                latitude: Double,
                longitude: Double,
                elevation: Double? = nil,
                description: String? = nil,
                symbol: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
        self.name = name
        self.gpxDescription = description
        self.symbol = symbol
    }
}

extension GPXWaypoint: GPXElement {
    static var xmlTag: String {
        "wpt"
    }
    
    init(xml: AEXMLElement) throws {
        //longitude
        guard let longitudeString = xml.attributes["lon"],
              let longitudeDouble = Double(longitudeString)
        else {
            throw GPXError.missingRequiredElement("longitude")
        }
        self.longitude = longitudeDouble

        //latitude
        guard let latitudeString = xml.attributes["lat"],
              let latitudeDouble = Double(latitudeString)
        else {
            throw GPXError.missingRequiredElement("latitude")
        }
        self.latitude = latitudeDouble
        
        //name
        let nameElement = xml["name"]
        if let nameError = nameElement.error {
            throw nameError
        }
        self.name = nameElement.string
        
        //elevation
        self.elevation = xml["ele"].double
        
        //description
        self.gpxDescription = xml["desc"].value
        
        //symbol
        self.symbol = xml["sym"].value
    }
    
    var xmlElement: AEXMLElement {
        let attributes = [
            "lat": "\(latitude)",
            "lon": "\(longitude)"
        ]
        let element = AEXMLElement(name: Self.xmlTag, attributes: attributes)

        //name
        element.addChild(name: "name", value: name)

        //elevation
        if let elevation = elevation {
            element.addChild(name: "ele", value: "\(elevation)")
        }
        
        //description
        if gpxDescription != nil {
            element.addChild(name: "desc", value: gpxDescription)
        }
        
        //symbol
        if symbol != nil {
            element.addChild(name: "sym", value: symbol)
        }
        
        return element
    }
    
}
