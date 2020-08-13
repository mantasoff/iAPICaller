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
    var token: String = ""
    var userName: String = ""
    var password: String = ""
    var tokenURL: String = ""
    var serverURL: String = ""
    var onRequestError: ((String) -> ())?
    
    //MARK: - Request functions
    func fetchToken(onTokenFetch: @escaping (String) -> ()) {
        let url = URL(string: tokenURL)
        var request = URLRequest(url: url!)
        let loginInformation = buildLoginJSON(userName: userName, password: password)
        
        request.httpMethod = "POST"
        request.httpBody = loginInformation
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        APICaller().callAPI(with: request, responseParser: parseToken, callback: { (parsedResponse, errorString) in
            if errorString != nil {
                if self.onRequestError != nil {
                    self.onRequestError!(errorString!)
                }
                return
            }
            
            if parsedResponse != nil, let tokenString = parsedResponse as? String {
                self.token = tokenString
                onTokenFetch(self.token)
            }
        })
    }
    
    func fetchServers(onServerFetch: @escaping ([Server]) -> ()) {
        if token.isEmpty {
            print("The Token is empty")
            return
        }
        
        let authorizationToken = "Bearer \(token)"
        let url = URL(string: serverURL)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": authorizationToken]
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        APICaller().callAPI(with: request, sessionConfiguration: sessionConfig, responseParser: decodeServers, callback: { (parsedResponse, errorString) in
            if errorString != nil {
                if self.onRequestError != nil {
                    self.onRequestError!(errorString!)
                }
                return
            }
            
            if parsedResponse != nil, let parsedServers = parsedResponse as? [Server] {
                self.servers = parsedServers
                onServerFetch(parsedServers)
            }
        })
    }
    
    //MARK: - JSON parsing functions
    private func buildLoginJSON(userName: String, password: String) -> Data? {
        let json = [K.jsonIdentifiers.usernameIdentifier: userName, K.jsonIdentifiers.passwordIdentifier: password]
        let jsonData = try? JSONEncoder().encode(json)
        return jsonData ?? nil
    }
    
    private func parseToken(from data: Data) -> String {
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let parsedJSON = responseJSON as? [String: String] {
            return(parsedJSON[K.jsonIdentifiers.tokenIdentifier]!)
        }
        return ""
    }
    
    private func decodeServers(from data: Data) -> [Server]? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Array<Server>.self, from: data)
            return response
        } catch {
            print(error)
            return nil
        }
    }
    
    //MARK: - Filter functions
    func filterServers(filter: String) -> [Server] {
        if filter.isEmpty {
            return servers
        }
        
        let filteredServers = servers.filter { (server) -> Bool in
            return server.name.lowercased().contains(filter.lowercased()) 
        }
        
        return filteredServers
    }
}
