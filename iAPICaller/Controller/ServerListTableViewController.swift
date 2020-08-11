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
    var servers: [Server]?
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: K.cellNames.CountryTableViewCell)
        searchTextField.delegate = self
        
        if serverBrain == nil {
            serverBrain = ServerBrain()
        }
        
        servers = serverBrain?.servers
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellNames.CountryTableViewCell, for: indexPath) as! CountryTableViewCell
        
        if servers != nil {
            let server = servers![indexPath.row]
            cell.CountryNameLabel.text = server.name
            cell.DistanceLabel.text = "\(server.distance)"
        }
        
        return cell
    }
    
    //MARK: - Actions
    @IBAction func OnRefreshButtonClicked(_ sender: UIBarButtonItem) {
        if serverBrain != nil, serverBrain?.token != nil {
            APICaller().fetchServers(token: serverBrain!.token) { (servers) in
                self.serverBrain?.servers = servers
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - UI Related Functions
    func reloadData() {
        tableView.reloadData()
    }

    @IBAction func searchDidEndEditting(_ sender: UITextField) {
        servers = serverBrain?.filterServers(filter: sender.text ?? "")
        tableView.reloadData()
    }
}

//MARK: - Delegates
extension ServerListTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
