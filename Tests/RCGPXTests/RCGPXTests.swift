import XCTest
@testable import RCGPX

@available(macOS 12.0, *)
final class RCGPXTests: XCTestCase {
    enum InitializerType {
        case aeXML
        case xmlCoder
    }
    
    enum RemoteTestFile: String {
        case roscoff = "1_Roscoff_Morlaix_A_parcours.gpx"
        case lannion = "Lannion_Plestin_parcours24.4RE.gpx"
        case perros = "Perros-Guirec_Trebeurden_parcours23.6RE.gpx"
        case plougasou = "Plougasou-plestin-parcours.gpx"
        case roscoffPerros = "Roscoff_Perros-Guirec.gpx"
        case trebeurdan = "Trebeurden_Lannion_parcours13.2RE.gpx"
        case morlaix = "parcours-morlaix-plougasnou.gpx"
        case pois = "poi/archies_fr.filtered.gpx"
        
        var url: URL {
            URL(string: "https://raw.githubusercontent.com/gps-touring/sample-gpx/master/RoscoffCoastal")!
                .appendingPathComponent(rawValue)
        }
    }
    
    private var remoteFileData: Data?
    
    private var fileName: String {
        "GPSVisSample"
    }
    
    override func setUp() async throws {
        let remoteLink: RemoteTestFile = .morlaix
        let request = URLRequest(url: remoteLink.url)
        let (data, _) = try await URLSession.shared.data(for: request)
        remoteFileData = data
    }
    
    func testGpsVisualizerExample() {
        guard let document = getLocalTestDocument(name: fileName, coder: .xmlCoder) else {
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
    
    func testRemoteFileData() throws {
        guard let data = remoteFileData else {
            XCTFail("No remote file data")
            return
        }
        
        let doc = try GPXDocument(xmlCoding: data)
        print("Loaded GPX document with \(doc.tracks.count) tracks and \(doc.waypoints.count) waypoints")
    }
    
    func testGpxWriting() throws {
        guard let document = getLocalTestDocument(name: fileName, coder: .aeXML) else {
            XCTFail("Oh no! Can't open GPSVisSample file")
            return
        }
        
        let gpxString = document.gpxString()
        print(gpxString)
    }

    func testAEXMLSpeed() throws {
        guard let data = remoteFileData else { return }
        
        measure {
            let doc = try? GPXDocument(data)
            XCTAssertNotNil(doc)
            
        }
    }
        
    func testXmlCoderSpeed() throws {
        guard let data = remoteFileData else { return }
        
        measure {
            let doc = try? GPXDocument(xmlCoding: data)
            XCTAssertNotNil(doc)
        }
    }
    
}

//MARK: Helper Functions
@available(macOS 12.0, *)
extension RCGPXTests {
    
    func getLocalTestDocument(name:String, coder: InitializerType) -> GPXDocument? {
        let bundle = Bundle.module
        guard let fileUrl = bundle.url(forResource: name, withExtension: "gpx") else {
            XCTFail("URL for GPX file could not be found")
            return nil
        }
        do {
            let data = try Data(contentsOf: fileUrl)
            let document: GPXDocument
            switch coder {
            case .aeXML:
                document = try GPXDocument(data)
            case .xmlCoder:
                document = try GPXDocument(xmlCoding: data)
            }
            return document
        } catch {
            XCTFail("GPX Reader Error: \(error.localizedDescription)")
            return nil
        }
    }
    
}

