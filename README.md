# RCGPX

![GitHub](https://img.shields.io/github/license/RCCoop/RCGPX)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRCCoop%2FRCGPX%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/RCCoop/RCGPX)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRCCoop%2FRCGPX%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/RCCoop/RCGPX)

A simple library for reading & writing GPX tracks and waypoints in Swift, specifically designed for simplicity and ease of use.


# Index

- [Installation](#installation)
- [GPXDocument](#gpxdocument)
  - [GPX Types](#gpx-types)
- [Reading GPX Files](#reading-gpx-files)
- [Writing GPX Files](#writing-gpx-files)
- [Dependencies](#dependencies)

# Installation

Swift Package Manager:
```
.package(url: "https://github.com/RCCoop/RCGPX.git", .upToNextMajor(from: "1.0.0"))
```

# GPXDocument

The root of a GPX file is represented by the `GPXDocument` struct, which is used as a container for any number of waypoints and tracks.

When creating a GPXDocument from scratch (rather than reading from an existing file), you may optionally add a name for the person or program that created the file, as well as the arrays of tracks and waypoints.

```swift
public struct GPXDocument {
    public var creator: String?
    public var waypoints: [GPXWaypoint]
    public var tracks: [GPXTrack]
    public var routes: [GPXRoute]
}
```

# GPX Types

- GPXTrack
    - .Segment
    - .Point
- GPXRoute
    - .Point
- GPXWaypoint

# Reading GPX Files

```swift
let fileUrl = ...
let fileData = try Data(contentsOf: fileUrl)
let gpxString = try? String(contentsOf: fileUrl, encoding: .utf8)

let documentFromData = try? GPXDocument(fileData)
let documentFromFileUrl = try? GPXDocument(fileUrl)
let documentFromString = try? GPXDocument(gpxString)
```

# Writing GPX Files

```swift
let gpxDoc = GPXDocument(...)

let asData = gpxDoc.gpxData()
let asString = gpxDoc.gpxString()
```

## Dependencies

- [AEXML](https://github.com/tadija/AEXML) for reading and writing XML files
