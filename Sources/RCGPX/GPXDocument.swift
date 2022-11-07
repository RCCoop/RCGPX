//
//  GPXDocument.swift
//
//
//  Created by Ryan Linn on 7/9/21.
//

import AEXML
import Foundation

/// The root of a GPX file representation. The basics of this are an optional
/// `creator` string, and arrays of waypoints and tracks.
public struct GPXDocument {
    /// An optional name for who or what created this GPX file
    public var creator: String?
    /// An array of `GPXWaypoint` contained in this GPX file
    public var waypoints: [GPXWaypoint]
    /// An array of `GPXTrack` contained in this GPX file
    public var tracks: [GPXTrack]

    public init(
        creator: String? = nil,
        waypoints: [GPXWaypoint] = [],
        tracks: [GPXTrack] = []
    ) {
        self.creator = creator
        self.waypoints = waypoints
        self.tracks = tracks
    }
}

// MARK: - Accessors

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

// MARK: - Initializers

public extension GPXDocument {
    init(_ data: Data) throws {
        let xmlDoc = try AEXMLDocument(xml: data)
        guard let documentElement = xmlDoc.firstDescendant(where: { $0.name == Self.xmlTag }) else {
            throw GPXError.missingRequiredElement("Document")
        }
        if let xmlError = documentElement.error {
            throw xmlError
        }
        try self.init(xml: documentElement)
    }

    init(_ string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw GPXError.missingRequiredElement("xml")
        }
        try self.init(data)
    }

    init(_ url: URL) throws {
        let data = try Data(contentsOf: url)
        try self.init(data)
    }
}
