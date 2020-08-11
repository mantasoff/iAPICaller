//
//  ServerBrain.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import Foundation

class ServerBrain {
    var servers: [Server] = []
    var prefilteredServers: [Server]?
    var token: String = ""
    var userName: String = ""
    var password: String = ""
    
    func filterServers(filter: String) -> [Server] {
        if filter.isEmpty {
            return servers
        }
        
        let filteredServers = servers.filter { (server) -> Bool in
            if server.name.lowercased().contains(filter.lowercased()) {
                return true
            }
            return false
        }
        
        return filteredServers
    }
}
