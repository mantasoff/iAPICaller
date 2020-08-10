//
//  ServerListTableViewController.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import UIKit

class ServerListTableViewController: UITableViewController {
    var serverBrain: ServerBrain?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: K.cellNames.CountryTableViewCell)
        
        if serverBrain == nil {
            serverBrain = ServerBrain()
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverBrain?.servers.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellNames.CountryTableViewCell, for: indexPath) as! CountryTableViewCell
        
        if serverBrain != nil {
            let server = serverBrain!.servers[indexPath.row]
            cell.CountryNameLabel.text = server.name
            cell.DistanceLabel.text = "\(server.distance)"
        }
        
        return cell
    }
}
