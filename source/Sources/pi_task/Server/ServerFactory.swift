//
//  ServerFactory.swift
//
//  Created by Eldar Goloviznin on 12/12/2018.
//

import Foundation

/// An error that can occur on `ServerFactory.create(port: Int)` method calling.
private enum ServerFactoryError: String, Error {
    
    /// Port is beyond the bounds of 0 ... 65536
    case wrongPort
    
}

/// Class for returning implementation of `Server` protocol. Use it to build your server.
final class ServerFactory {
    
    /// There is no reason to create `ServerFactory` instance directly.
    private init() {
        fatalError("ServerFactory should not be called directly")
    }
    
    // MARK: Public methods
    
    /**
     Builds `Server` implementation.
     
     - Parameters:
        - port: An integer value corresponds to the port you are willing to bind.
     
     - Throws: `ServerFactoryError.wrongPort` if `port` is invalid.
     
     - Returns: `Server` implementation.
     */
    static func create(port: Int) throws -> Server {
        guard 0 ... 65536 ~= port else {
            throw ServerFactoryError.wrongPort
        }
        
        return ServerDefault(port: port)
    }
    
}
