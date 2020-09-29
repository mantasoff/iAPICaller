//
//  APICallerAssembly.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-27.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//
import Swinject

class ServerBrainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(KeychainManager.self) { _ in
            KeychainManager(service: "playground.tesonet.lt")
        }
        
        container.register(ServerBrain.self) { r in
            ServerBrain(keychainManager: r.resolve(KeychainManager.self)!)
        }.inObjectScope(.container)
        
        //container.register(ViewController.self) { r in
        //    ViewController()
        //}.inObjectScope(.)
    }
}
