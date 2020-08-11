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
    @IBOutlet weak var errorTextLabel: UILabel!
    var serverBrain = ServerBrain()
    
    //MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        resetToInitialValues()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        resetToInitialValues()
    }
    
    //MARK: - Button press functions
    @IBAction func onLoginPressed(_ sender: UIButton) {
        if let userName = userNameTextField.text, let password = passwordTextField.text {
            APICaller().fetchToken(userName: userName, password: password) { (token, errorText) in
                if errorText != nil {
                    DispatchQueue.main.async {
                        self.showErrorText(errorText: errorText!)
                    }
                    return
                }
                
                if token != nil {
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
    
    //MARK: - UI Related Functions
    private func resetToInitialValues() {
        userNameTextField.text = ""
        passwordTextField.text = ""
        errorTextLabel.isHidden = true
    }
    
    private func showErrorText(errorText: String) {
        errorTextLabel.text = "Woops: \(errorText)"
        errorTextLabel.isHidden = false
    }
}

//MARK: - Delegates
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

