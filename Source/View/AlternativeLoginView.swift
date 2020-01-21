//
//  AlternativeLoginView.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 1/20/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

internal protocol AlternativeLoginViewDelegate {
    func handleLoginResponse(_ authCode: String)
    func handleCloseView()
}

internal class AlternativeLoginView: UIView, UITextFieldDelegate {
    
    public static let nibName: String = "AlternativeLoginView"
    
    @IBOutlet weak var hackerIdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public var delegate: AlternativeLoginViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        Bundle.main.loadNibNamed(AlternativeLoginView.nibName, owner: self, options: nil)
        self.backgroundColor = .white
        
        errorLabel.isEnabled = false
        errorLabel.isHidden = true
        loginButton.layer.cornerRadius = 6
        
        hackerIdTextField.delegate = self
        addSpecifiedShadow(hackerIdTextField)
        addGradient(loginButton)
        boundEdges(of: contentView, to: self, with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    private func attemptLogin() {
        errorLabel.isEnabled = false
        errorLabel.isHidden = true
        activityIndicator.startAnimating()
        
        guard let publicUUID = self.hackerIdTextField.text, !publicUUID.isEmpty else {
            errorLabel.isEnabled = true
            errorLabel.isHidden = false
            errorLabel.text = "Please enter a valid ID"
            activityIndicator.stopAnimating()
            return
        }
        
        HackerRequestSingletonFunction.loginHacker(publicUUID: publicUUID) { (authCode) in
            guard let authCode = authCode else {
                self.errorLabel.isEnabled = true
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Hacker ID is Invalid"
                self.activityIndicator.stopAnimating()
                return
            }
            
            UserDefaultsHolder.setUser(HackerUUID(publicUUID: publicUUID, authCode: authCode))
            self.activityIndicator.stopAnimating()
            self.delegate?.handleLoginResponse(authCode)
            return
        }
    }
    
    private func addGradient(_ view: UIButton) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [UIColor(red: 73, green: 61, blue: 205, a: 1).cgColor, UIColor(red: 176, green: 81, blue: 204, a: 1).cgColor]
        gradient.cornerRadius = view.layer.cornerRadius
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        attemptLogin()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.handleCloseView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        attemptLogin()
        return true
    }
}
