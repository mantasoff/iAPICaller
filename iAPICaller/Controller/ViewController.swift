//
//  ViewController.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var serverBrain = ServerBrain()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Button press functions
    @IBAction func onLoginPressed(_ sender: UIButton) {
        if let userName = userNameTextField.text, let password = passwordTextField.text {
            APICaller().fetchToken(userName: userName, password: password) { (token, errorText) in
                if errorText == nil && token != nil {
                    self.serverBrain.token = token!
                    APICaller().fetchServers(token: token!) { (servers) in
                        self.serverBrain.servers = servers
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: K.segues.loginToServers, sender: self)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Segue preparation functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.loginToServers {
            let serverListTableViewController = segue.destination as! ServerListTableViewController;
            serverListTableViewController.serverBrain = serverBrain
        }
    }
}

