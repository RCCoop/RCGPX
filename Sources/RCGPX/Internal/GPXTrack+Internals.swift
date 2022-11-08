//
//  GPXTrack+Internals.swift
//  
//
//  Created by Ryan Linn on 11/7/22.
//

import AEXML
import Foundation
import XMLCoder

// MARK: GPXTrack: GPXElement

extension GPXTrack: GPXElement {
    static var xmlTag: String {
        "trk"
    }

    init(xml: AEXMLElement) throws {
        guard let nameElement = xml["name"].value else {
            throw GPXError.missingRequiredElement("name")
        }
        name = nameElement

        gpxDescription = xml["desc"].value

        segments = try xml
            .all(withValue: Segment.xmlTag)?
            .map { try Segment(xml: $0) }
            ?? []
    }

    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.xmlTag)
        element.addChild(name: "name", value: name)
        element.addChild(name: "desc", value: gpxDescription)
        element.addChildren(segments.map(\.xmlElement))
        return element
    }
}

// MARK: GPXTrack.Segment: GPXElement

extension GPXTrack.Segment: GPXElement {
    static var xmlTag: String {
        "trkseg"
    }

    init(xml: AEXMLElement) throws {
        let pointChildren = xml.all(withValue: GPXTrack.Point.xmlTag) ?? []
        trackPoints = try pointChildren.map { try GPXTrack.Point(xml: $0) }
    }

    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.xmlTag)
        element.addChildren(trackPoints.map(\.xmlElement))
        return element
    }
}

// MARK: GPXTrack.Point: GPXElement

extension GPXTrack.Point: GPXElement {
    static var xmlTag: String {
        "trkpt"
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

        // elevation
        elevation = xml["ele"].double

        // Time
        if let timeElement = xml["time"].value {
            if #available(iOS 15.0, macOS 12.0, watchOS 8.0, *) {
                self.time = try? Date(timeElement, strategy: .iso8601)
            } else {
                time = Self.dateFormatter!.date(from: timeElement)
            }
        }
    }

    var xmlElement: AEXMLElement {
        let attributes = [
            "lat": "\(latitude)",
            "lon": "\(longitude)",
        ]
        let element = AEXMLElement(name: Self.xmlTag, attributes: attributes)

        // elevation
        if let elevation = elevation {
            element.addChild(name: "ele", value: "\(elevation)")
        }

        // time
        if let time = time {
            let dateString: String
            if #available(iOS 15.0, macOS 12.0, watchOS 8.0, *) {
                dateString = time.ISO8601Format()
            } else {
                dateString = Self.dateFormatter!.string(from: time)
            }
            element.addChild(name: "time", value: dateString)
        }

        return element
    }
}

extension GPXTrack.Point: DynamicNodeEncoding, DynamicNodeDecoding {
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.latitude, CodingKeys.longitude:
            return .attribute
        default:
            return .element
        }
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case CodingKeys.latitude, CodingKeys.longitude:
            return .attribute
        default:
            return .element
        }
    }
    
}
