//
//  GPXTrack.swift
//  
//
//  Created by Ryan Linn on 7/9/21.
//

import Foundation
import AEXML

//MARK: TrackPoint
public struct GPXTrackPoint {
    public var latitude: Double
    public var longitude: Double
    public var elevation: Double?
    public var time: Date?
    
    private static var dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
}

extension GPXTrackPoint: GPXElement {
    public static var xmlTag: String {
        "trkpt"
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
                
        //elevation
        self.elevation = xml["ele"].double

        //Time
        if let timeElement = xml["time"].value {
            self.time = Self.dateFormatter.date(from: timeElement)
        }
    }
    
    public var xmlElement: AEXMLElement {
        let attributes = [
            "lat": "\(latitude)",
            "lon": "\(longitude)"
        ]
        let element = AEXMLElement(name: Self.xmlTag, attributes: attributes)

        //elevation
        if let elevation = elevation {
            element.addChild(name: "ele", value: "\(elevation)")
        }
        
        //time
        if let time = time {
            element.addChild(name: "time", value: Self.dateFormatter.string(from: time))
        }
        
        return element
    }
    
    
}

//MARK:- TrackSegment
public struct GPXTrackSegment {
    public var trackPoints: [GPXTrackPoint]
}

extension GPXTrackSegment: GPXElement {
    public static var xmlTag: String {
        "trkseg"
    }
    
    public init(xml: AEXMLElement) throws {
        let pointChildren = xml.all(withValue: GPXTrackPoint.xmlTag) ?? []
        self.trackPoints = try pointChildren.map({ try GPXTrackPoint(xml: $0) })
    }
    
    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.xmlTag)
        element.addChildren(trackPoints.map(\.xmlElement))
        return element
    }
    
    
}

//MARK:- Track
public struct GPXTrack {
    public var name: String
    public var gpxDescription: String?
    public var segments: [GPXTrackSegment]
}

extension GPXTrack: GPXElement {
    public static var xmlTag: String {
        "trk"
    }
    
    public init(xml: AEXMLElement) throws {
        guard let nameElement = xml["name"].value else {
            throw GPXError.missingRequiredElement("name")
        }
        self.name = nameElement
        
        self.gpxDescription = xml["desc"].value
        
        self.segments = try xml.all(withValue: GPXTrackSegment.xmlTag)?.map({ try GPXTrackSegment(xml: $0) }) ?? []
    }
    
    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.xmlTag)
        element.addChild(name: "name", value: name)
        element.addChild(name: "desc", value: gpxDescription)
        element.addChildren(segments.map(\.xmlElement))
        return element
    }
    
}
