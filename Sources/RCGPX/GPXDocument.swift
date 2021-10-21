//
//  GPXDocument.swift
//  
//
//  Created by Ryan Linn on 7/9/21.
//

import Foundation
import AEXML

/// The root of a GPX file representation. The basics of this are an optional
/// `creator` string, and arrays of waypoints and tracks.
public struct GPXDocument {
    /// An optional name for who or what created this GPX file
    var creator: String?
    /// An array of `GPXWaypoint` contained in this GPX file
    var waypoints: [GPXWaypoint]
    /// An array of `GPXTrack` contained in this GPX file
    var tracks: [GPXTrack]
    
    public init(creator: String? = nil,
                waypoints: [GPXWaypoint] = [],
                tracks: [GPXTrack] = []) {
        self.creator = creator
        self.waypoints = waypoints
        self.tracks = tracks
    }
}

extension GPXDocument: GPXElement {
    static var xmlTag: String {
        "gpx"
    }
    
    init(xml: AEXMLElement) throws {
        self.creator = xml.attributes["creator"]
        let waypointElements = xml.children.filter({ $0.name == GPXWaypoint.xmlTag })
        self.waypoints = try waypointElements.map({ try GPXWaypoint(xml: $0) })
        let trackElements = xml.children.filter({ $0.name == GPXTrack.xmlTag })
        self.tracks = try trackElements.map({ try GPXTrack(xml: $0) })
    }
    
    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.xmlTag)
        element.attributes["creator"] = creator
        element.addChildren(waypoints.map(\.xmlElement))
        element.addChildren(tracks.map(\.xmlElement))
        return element
    }
}

//MARK:- Accessors
public extension GPXDocument {
    /// Returns the full string representation of the GPX file.
    func gpxString() -> String {
        let xmlDoc = AEXMLDocument()
        xmlDoc.addChild(xmlElement)
        return xmlDoc.xml
    }
    
    /// Returns the file data representation of the GPX file.
    func gpxData() -> Data? {
        gpxString().data(using: .utf8)
    }
    
}

//MARK:- Initializers
extension GPXDocument {
    
    init(data: Data) throws {
        let xmlDoc = try AEXMLDocument(xml: data)
        guard let documentElement = xmlDoc.firstDescendant(where: { $0.name == Self.xmlTag }) else {
            throw GPXError.missingRequiredElement("Document")
        }
        if let xmlError = documentElement.error {
            throw xmlError
        }
        try self.init(xml: documentElement)
    }
    
    init(string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw GPXError.missingRequiredElement("xml")
        }
        try self.init(data: data)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }
    
}
