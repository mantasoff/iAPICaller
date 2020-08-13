//
//  Country.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-09.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import Foundation

class Server: Decodable {
    var name: String = "";
    var distance: Int = 0;
    
    init(name: String, distance: Int) {
        self.name = name
        self.distance = distance
    }
}
