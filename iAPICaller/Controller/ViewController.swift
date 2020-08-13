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
        
        errorTextLabel.isHidden = true
        
        serverBrain.tokenURL = K.requests.tokenURL
        serverBrain.serverURL = K.requests.serverURL
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    //MARK: - Button press functions
    @IBAction func onLoginPressed(_ sender: UIButton) {
        if let userName = userNameTextField.text, let password = passwordTextField.text {
            serverBrain.userName = userName
            serverBrain.password = password
            serverBrain.onRequestError = showErrorText
            
            _ = serverBrain.fetchToken()
            .then { token in
                return self.serverBrain.fetchServers()
            }
            .done {_ in
                self.resetToInitialState()
                self.segueToTableView()
            }
            .catch({ error in
                self.showErrorText(errorText: error.localizedDescription)
            })
        }
    }
    
    //MARK: - Segue related functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.loginToServers {
            let serverListTableViewController = segue.destination as! ServerListTableViewController;
            serverListTableViewController.serverBrain = serverBrain
        }
    }
    
    private func segueToTableView() {
        DispatchQueue.main.async {
           self.performSegue(withIdentifier: K.segues.loginToServers, sender: self)
        }
    }
    
    //MARK: - UI Related Functions
    private func resetToInitialState() {
        userNameTextField.text = ""
        passwordTextField.text = ""
        errorTextLabel.isHidden = true
    }
    
    private func showErrorText(errorText: String) {
        DispatchQueue.main.async {
            self.errorTextLabel.text = "Woops: \(errorText)"
            self.errorTextLabel.isHidden = false
        }
    }
}

//MARK: - Delegates
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

