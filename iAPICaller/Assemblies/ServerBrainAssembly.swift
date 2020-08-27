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
        container.register(ServerBrain.self) { _ in
            ServerBrain()
        }.inObjectScope(.container)
        
        //container.register(ViewController.self) { r in
        //    ViewController()
        //}.inObjectScope(.)
    }
}
