//
//  GPXTrack.swift
//
//
//  Created by Ryan Linn on 7/9/21.
//

import AEXML
import Foundation

// MARK: - Track

/// A representation of one or more lines on the map.
public struct GPXTrack {
    /// The unique name of the track to be displayed in a list of GPX elements.
    public var name: String
    /// An optional, user-provided description of the track
    public var gpxDescription: String?
    /// An ordered array of `GPXTrack.Segment` that make up the overall track.
    public var segments: [Segment]

    public init(
        name: String,
        description: String?,
        segments: [Segment]
    ) {
        self.name = name
        gpxDescription = description
        self.segments = segments
    }
    
    /// Returns an array of all `GPXTrackPoint` in the Track, combining
    /// all segments in the track in order.
    public func allTrackPoints() -> [Point] {
        segments
            .map(\.trackPoints)
            .reduce([]) { $0 + $1 }
    }
}

// MARK: - TrackSegment

public extension GPXTrack {
    /// A section of a GPX Track, consisting of an
    /// array of TrackPoints in directional order.
    struct Segment {
        /// An array of TrackPoints in directional order that make up this segment.
        public var trackPoints: [Point]

        public init(points: [Point]) {
            trackPoints = points
        }
    }
}

// MARK: - TrackPoint

public extension GPXTrack {
    /// A simple representation of a point along a GPX track,
    /// made up of latitude, longitude, elevation (in meters), and a time stamp.
    struct Point {
        public var latitude: Double
        public var longitude: Double
        public var elevation: Double?
        public var time: Date?

        internal static var dateFormatter: ISO8601DateFormatter? = {
            if #available(iOS 15.0, macOS 12.0, watchOS 8.0, *) {
                return nil
            } else {
                return ISO8601DateFormatter()
            }
        }()

        public init(
            latitude: Double,
            longitude: Double,
            elevation: Double? = nil,
            time: Date? = nil
        ) {
            self.latitude = latitude
            self.longitude = longitude
            self.elevation = elevation
            self.time = time
        }
    }
}
