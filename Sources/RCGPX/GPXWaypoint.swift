//
//  GPXWaypoint.swift
//  
//
//  Created by Ryan Linn on 7/9/21.
//

import Foundation
import AEXML

public struct GPXWaypoint {
    public var latitude: Double
    public var longitude: Double
    public var elevation: Double?
    public var name: String
    public var gpxDescription: String?
    public var symbol: String?
}

extension GPXWaypoint: GPXElement {
    public static var xmlTag: String {
        "wpt"
    }
    
    public init(xml: AEXMLElement) throws {
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
    
    public var xmlElement: AEXMLElement {
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
