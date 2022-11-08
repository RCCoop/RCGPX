    import XCTest
    @testable import RCGPX

    final class RCGPXTests: XCTestCase {
        func testGpsVisualizerExample() {
            guard let document = getTestDocument(name: "GPSVisSample") else {
                XCTFail("Oh no! Can't open GPSVisSample file")
                return
            }
            
            //Document
            XCTAssertEqual(document.creator, "GPS Visualizer https://www.gpsvisualizer.com/")
            XCTAssertEqual(document.tracks.count, 2)
            XCTAssertEqual(document.waypoints.count, 4)
            
            //Waypoints
            let knownWaypoints: [String : (lat: Double, lon: Double, elev: Double)] = [
                "Vista Ridge Trailhead" : (45.44283, -121.72904, 1374),
                "Wy'East Basin" : (45.41000, -121.71349, 1777),
                "Dollar Lake" : (45.41124, -121.70404, 1823),
                "Barrett Spur" : (45.39260, -121.69937, 2394)
            ]
            
            let waypointNamesKnown = Set(knownWaypoints.keys)
            let waypointNamesFound = Set(document.waypoints.map(\.name))
            XCTAssertEqual(waypointNamesKnown, waypointNamesFound)
            
            let waypointsByName = document.waypoints.reduce(into: [:], { $0[$1.name] = $1 })
            for (name, gpxWpt) in waypointsByName {
                guard let knownTraits = knownWaypoints[name] else {
                    XCTFail("Couldn't find KnownWaypoint for \(name)")
                    return
                }
                XCTAssertEqual(gpxWpt.latitude, knownTraits.lat, accuracy: 0.0001)
                XCTAssertEqual(gpxWpt.longitude, knownTraits.lon, accuracy: 0.0001)
                XCTAssertEqual(gpxWpt.elevation ?? 0.0, knownTraits.elev, accuracy: 0.0001)
            }
            
            //Tracks (number of segments)
            let knownTracks: [String : Int] = [
                "Barrett Spur 1" : 2,
                "Barrett Spur 2" : 3
            ]
            let trackPointCounts: [String : Int] = [
                "Barrett Spur 1" : 99,
                "Barrett Spur 2" : 98
            ]
            let trackNamesKnown = Set(knownTracks.keys)
            let trackNamesFound = Set(document.tracks.map(\.name))
            XCTAssertEqual(trackNamesKnown, trackNamesFound)
            
            // Segments
            for foundTrack in document.tracks {
                XCTAssertEqual(knownTracks[foundTrack.name], foundTrack.segments.count)
                XCTAssertEqual(trackPointCounts[foundTrack.name], foundTrack.allTrackPoints().count)
            }
            
        }
        
        func testGpxWriting() throws {
            guard let document = getTestDocument(name: "GPSVisSample") else {
                XCTFail("Oh no! Can't open GPSVisSample file")
                return
            }

            let gpxString = document.gpxString()
            print(gpxString)
        }
        
    }

    //MARK: Helper Functions
    extension RCGPXTests {
        func getTestDocument(name:String) -> GPXDocument? {
            let bundle = Bundle.module
            guard let fileUrl = bundle.url(forResource: name, withExtension: "gpx") else {
                XCTFail("URL for GPX file could not be found")
                return nil
            }
            do {
                let data = try Data(contentsOf: fileUrl)
                let document = try GPXDocument(data)
                return document
            } catch {
                XCTFail("GPX Reader Error: \(error.localizedDescription)")
                return nil
            }
        }
    }

