//
//  GPXRoute+Internals.swift
//  
//
//  Created by Ryan Linn on 3/28/23.
//

import AEXML
import Foundation

// MARK: GPXRoute: GPXElement

extension GPXRoute: GPXElement {
    static var xmlTag: String {
        "rte"
    }

    init(xml: AEXMLElement) throws {
        guard let nameElement = xml["name"].value else {
            throw GPXError.missingRequiredElement("name")
        }
        name = nameElement

        gpxDescription = xml["desc"].value

        routePoints = try xml
            .children
            .filter { $0.name == GPXRoute.Point.xmlTag }
            .map { try GPXRoute.Point(xml: $0) }
    }

    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.xmlTag)
        element.addChild(name: "name", value: name)
        if let desc = gpxDescription {
            element.addChild(name: "desc", value: desc)
        }
        element.addChildren(routePoints.map(\.xmlElement))
        return element
    }
}

// MARK: GPXRoute.Point: GPXElement

extension GPXRoute.Point: GPXElement {
    static var xmlTag: String {
        "rtept"
    }

    init(xml: AEXMLElement) throws {
        // longitude
        guard let longitudeString = xml.attributes["lon"],
              let longitudeDouble = Double(longitudeString)
        else {
            throw GPXError.missingRequiredElement("longitude")
        }
        longitude = longitudeDouble

        // latitude
        guard let latitudeString = xml.attributes["lat"],
              let latitudeDouble = Double(latitudeString)
        else {
            throw GPXError.missingRequiredElement("latitude")
        }
        latitude = latitudeDouble
    }

    var xmlElement: AEXMLElement {
        let attributes = [
            "lat": "\(latitude)",
            "lon": "\(longitude)",
        ]
        let element = AEXMLElement(name: Self.xmlTag, attributes: attributes)

        return element
    }
}
