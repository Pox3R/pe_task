//
//  Server.swift
//
//  Created by Eldar Goloviznin on 12/12/2018.
//

import Foundation

/// `Server` is used to create your custom servers.
protocol Server {
    
    // MARK: - Public methods
    
    /// Starts your server
    func start()
    
    /// Stops your server
    func stop()
    
}
