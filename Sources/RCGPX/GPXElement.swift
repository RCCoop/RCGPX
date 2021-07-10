//
//  GPXElement.swift
//  
//
//  Created by Ryan Linn on 7/9/21.
//

import Foundation
import AEXML

public enum GPXError: Error {
    case missingRequiredElement(String)
}

protocol GPXElement {
    /// The XML element name for this type of GPX Element, such as
    /// **trk**, **trkseg**, **wpt**, etc.
    static var xmlTag: String { get }
    
    /// Initializes the GPXElement using an AEXMLElement read from a GPX file.
    /// - Parameter xml: xml element read from a valid GPX file.
    init(xml: AEXMLElement) throws
    
    /// A representation of the GPX element as AEXMLElement, for writing to GPX file.
    var xmlElement: AEXMLElement { get }
}
