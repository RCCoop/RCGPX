//
//  UTType+GPX.swift
//  
//
//  Created by Ryan Linn on 2/8/23.
//

import UniformTypeIdentifiers

@available(macOS 11.0, iOS 14.0, watchOS 7.0, *)
public extension UTType {
    static var gpx: UTType {
        let tags = UTType.types(tag: "gpx", tagClass: .filenameExtension, conformingTo: .xml)
        return tags.first(where: { $0.identifier.contains("topografix") }) ?? tags.first!
    }
}
