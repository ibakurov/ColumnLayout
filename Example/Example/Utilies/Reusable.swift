//
//  Reusable.swift
//  Example
//
//  Created by Illya Bakurov on 11/11/17.
//  Copyright © 2017 Illya Bakurov. All rights reserved.
//

import Foundation

/** A generic protocol that is primarily used for collection view and table view cell reuse identifier handling. */
public protocol Reusable: class {
    
    /** The protocol's static reuse identifier. */
    static var reuseIdentifier: String { get }
    
    /** The protocol's static nib name. */
    static var nibName: String { get }
    
}

/** A generic extension that is primarily used for collection view and table view cell reuse identifier handling. This helps to normalize cell reuse methods and reduce duplicate code. */
public extension Reusable {
    
    /** Returns the generic reuse identifier for the given class. */
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    /** Returns the generic nib name for the given class. */
    static var nibName: String {
        return String(describing: self)
    }
}
