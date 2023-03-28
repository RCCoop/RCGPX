//
//  GPXFeature.swift
//  
//
//  Created by Ryan Linn on 3/28/23.
//

import Foundation

/// Basic protocol to denote that a type can be found in the root of a `GPXDocument`.
public protocol GPXFeature {
    /// The unique name of the feature to be displayed in a list of GPX elements.
    var name: String { get }
    
    /// An optional, user-provided description of the feature
    var gpxDescription: String? { get }
}
