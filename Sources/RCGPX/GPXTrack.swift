//
//  GPXTrack.swift
//  
//
//  Created by Ryan Linn on 7/9/21.
//

import Foundation
import AEXML

//MARK:- Track
/// A representation of one or more lines on the map.
public struct GPXTrack {
    /// The unique name of the track to be displayed in a list of GPX elements.
    public var name: String
    /// An optional, user-provided description of the track
    public var gpxDescription: String?
    /// An ordered array of `GPXTrackSegment` that make up the overall track.
    public var segments: [GPXTrackSegment]
    
    public init(name: String,
                description: String?,
                segments: [GPXTrackSegment]) {
        self.name = name
        self.gpxDescription = description
        self.segments = segments
    }
}

extension GPXTrack: GPXElement {
    static var xmlTag: String {
        "trk"
    }
    
    init(xml: AEXMLElement) throws {
        guard let nameElement = xml["name"].value else {
            throw GPXError.missingRequiredElement("name")
        }
        self.name = nameElement
        
        self.gpxDescription = xml["desc"].value
        
        self.segments = try xml.all(withValue: GPXTrackSegment.xmlTag)?.map({ try GPXTrackSegment(xml: $0) }) ?? []
    }
    
    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.xmlTag)
        element.addChild(name: "name", value: name)
        element.addChild(name: "desc", value: gpxDescription)
        element.addChildren(segments.map(\.xmlElement))
        return element
    }
    
}


//MARK:- TrackSegment
/// A section of a GPX Track, consisting of an
/// array of TrackPoints in directional order.
public struct GPXTrackSegment {
    /// An array of TrackPoints in directional order that make up this segment.
    public var trackPoints: [GPXTrackPoint]
    
    public init(points: [GPXTrackPoint]) {
        self.trackPoints = points
    }
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

//MARK: TrackPoint
/// A simple representation of a point along a GPX track,
/// made up of latitude, longitude, elevation (in meters), and a time stamp.
public struct GPXTrackPoint {
    public var latitude: Double
    public var longitude: Double
    public var elevation: Double?
    public var time: Date?
    
    private static var dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    
    public init(latitude: Double,
                longitude: Double,
                elevation: Double? = nil,
                time: Date? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
        self.time = time
    }
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
