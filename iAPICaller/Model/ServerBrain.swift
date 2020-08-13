//
//  ServerBrain.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import Foundation
import PromiseKit

class ServerBrain {
    var servers: [Server] = []
    var token: String = ""
    var userName: String = ""
    var password: String = ""
    var tokenURL: String = ""
    var serverURL: String = ""
    var onRequestError: ((String) -> ())?
    
    //MARK: - Request functions
    func fetchToken() -> Promise<String> {
        return Promise { seal in
            let url = URL(string: tokenURL)
            var request = URLRequest(url: url!)
            let loginInformation = buildLoginJSON(userName: userName, password: password)
            
            request.httpMethod = "POST"
            request.httpBody = loginInformation
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            APICaller().callAPI(with: request, responseParser: parseToken)
            .done { parsedResponse in
                if parsedResponse != nil, let tokenString = parsedResponse as? String {
                    self.token = tokenString
                    seal.fulfill(tokenString)
                }
            }
            .catch { error in
                print(error.localizedDescription)
                seal.reject(error)
            }
        }
    }
    
    func fetchServers() -> Promise<[Server]> {
        return Promise { seal in
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
            
            APICaller().callAPI(with: request, sessionConfiguration: sessionConfig, responseParser: decodeServers)
            .done { parsedResponse in
                if parsedResponse != nil, let parsedServers = parsedResponse as? [Server] {
                    self.servers = parsedServers
                    seal.fulfill(parsedServers)
                }
            }
            .catch { error in
                seal.reject(error)
            }
        
        }
    }
        
    
    //MARK: - JSON parsing functions
    private func buildLoginJSON(userName: String, password: String) -> Data? {
        let json = [K.jsonIdentifiers.usernameIdentifier: userName, K.jsonIdentifiers.passwordIdentifier: password]
        let jsonData = try? JSONEncoder().encode(json)
        return jsonData
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
