//
//  GPXDocument.swift
//  
//
//  Created by Ryan Linn on 7/9/21.
//

import Foundation
import AEXML

public struct GPXDocument {
    var creator: String?
    var waypoints: [GPXWaypoint]
    var tracks: [GPXTrack]
}

extension GPXDocument: GPXElement {
    public static var xmlTag: String {
        "gpx"
    }
    
    public init(xml: AEXMLElement) throws {
        self.creator = xml.attributes["creator"]
        let waypointElements = xml.children.filter({ $0.name == GPXWaypoint.xmlTag })
        self.waypoints = try waypointElements.map({ try GPXWaypoint(xml: $0) })
        let trackElements = xml.children.filter({ $0.name == GPXTrack.xmlTag })
        self.tracks = try trackElements.map({ try GPXTrack(xml: $0) })
    }
    
    public var xmlElement: AEXMLElement {
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
