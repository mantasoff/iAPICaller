//
//  APICaller.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import Foundation

struct APICaller {
    
    //MARK: - API Request functions
    func fetchToken(userName: String, password: String, callback: @escaping (String?,String?) ->()) {
        if let loginInformation = buildLoginJSON(userName: userName, password: password) {
            let url = URL(string: K.requests.tokenURL)
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            request.httpBody = loginInformation
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if (error != nil) {
                    print(error?.localizedDescription ?? "No data")
                    callback(nil, error?.localizedDescription)
                    return
                }
                
                if let safeResponse = response, self.isError(response: safeResponse) {
                    callback(nil, "Unauthorized, try again :(")
                    return
                }
                
                if data != nil {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let responseJSON = responseJSON as? [String: String] {
                        callback(responseJSON[K.jsonIdentifiers.tokenIdentifier], nil)
                    }
                }
                callback(nil,nil)
            }
            task.resume()
        } else {
            callback(nil, "The username and password are not in the correct format!")
            return
        }
    }
    
    func fetchServers(token: String, callback: @escaping ([Server]) -> ()) {
        if token.isEmpty {
            print("The Token is empty")
            return
        }
        
        let authorizationToken = "Bearer \(token)"
        let url = URL(string: K.requests.locationURL)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": authorizationToken]
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: sessionConfig)
        let dataTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error when getting servers: \(error!.localizedDescription)")
            }
            
            if  data != nil {
                if let servers = self.decodeServers(from: data!) {
                    callback(servers)
                }
            }
        }
        dataTask.resume()
    }
    
    //MARK: - JSON parsing functions
    private func buildLoginJSON(userName: String, password: String) -> Data? {
        let json = [K.jsonIdentifiers.usernameIdentifier: userName, K.jsonIdentifiers.passwordIdentifier: password]
        let jsonData = try? JSONEncoder().encode(json)
        return jsonData ?? nil
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
    
    private func isError(response: URLResponse) -> Bool {
        if let httpResponse = response as? HTTPURLResponse {
            if (httpResponse.statusCode < 600) && (httpResponse.statusCode >= 400) {
                return true
            }
        }
        return false
    }
}
