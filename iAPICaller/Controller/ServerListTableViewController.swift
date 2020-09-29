//
//  ServerListTableViewController.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import UIKit

class ServerListTableViewController: UITableViewController {
    let serverBrain: ServerBrain
    var servers: [Server]?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: K.cellNames.countryTableViewCell)
        searchTextField.delegate = self
        getServersFromServerBrain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        serverBrain = DI.resolve(ServerBrain.self)
        super.init(coder: aDecoder)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellNames.countryTableViewCell, for: indexPath) as? CountryTableViewCell else {
            fatalError("Unable to dequeue Server Cell")
        }
        
        if let servers = servers {
            let server = servers[indexPath.row]
            cell.CountryNameLabel2.text = server.name
            cell.DistanceLabel2.text = "\(server.distance)"
        }
        
        return cell
    }
    
    //MARK: - Actions
    @IBAction func OnRefreshButtonClicked(_ sender: UIBarButtonItem) {
        getServersFromServerBrain()
    }
    @IBAction func OnSignOutButtonClicked(_ sender: UIBarButtonItem) {
        serverBrain.removePassword()
        performSegue(withIdentifier: K.segues.serversToLogin, sender: self)
    }
    
    //MARK: - UI Related Functions
    @IBAction func searchDidEndEditting(_ sender: UITextField) {
        servers = serverBrain.filterServers(filter: sender.text ?? "")
        tableView.reloadData()
    }
    
    private func getServersFromServerBrain() {
        activityIndicatorView.isHidden = false
        serverBrain.fetchServers()
        .done { servers in
            self.servers = servers
            self.tableView.reloadData()
            self.activityIndicatorView.isHidden = true
        }
        .catch { error in
            self.activityIndicatorView.isHidden = true
        }
    }
}

//MARK: - Delegates
extension ServerListTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
