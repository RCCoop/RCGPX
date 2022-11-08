//
//  GPXWaypoint+Internals.swift
//  
//
//  Created by Ryan Linn on 11/7/22.
//

import AEXML
import Foundation
import XMLCoder

// MARK: GPXWaypoint: GPXElement

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

extension GPXWaypoint: DynamicNodeDecoding, DynamicNodeEncoding {
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case CodingKeys.latitude, CodingKeys.longitude:
            return .attribute
        default:
            return .element
        }
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.latitude, CodingKeys.longitude:
            return .attribute
        default:
            return .element
        }
    }
    
}
