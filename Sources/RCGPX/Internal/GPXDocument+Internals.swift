//
//  GPXDocument+Internals.swift
//  
//
//  Created by Ryan Linn on 11/7/22.
//

import Foundation
import AEXML

// MARK: - GPXElement

extension GPXDocument: GPXElement {
    static var xmlTag: String {
        "gpx"
    }

    init(xml: AEXMLElement) throws {
        creator = xml.attributes["creator"]
        let waypointElements = xml.children.filter { $0.name == GPXWaypoint.xmlTag }
        waypoints = try waypointElements.map { try GPXWaypoint(xml: $0) }
        let trackElements = xml.children.filter { $0.name == GPXTrack.xmlTag }
        tracks = try trackElements.map { try GPXTrack(xml: $0) }
    }

    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.xmlTag)
        element.attributes["creator"] = creator
        element.addChildren(waypoints.map(\.xmlElement))
        element.addChildren(tracks.map(\.xmlElement))
        return element
    }
}
