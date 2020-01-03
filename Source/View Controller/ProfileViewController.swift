//
//  ProfileViewController.swift
//  KnightHacks
//
//  Created by Patrick Stoebenau on 10/21/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit

internal class ProfileViewController: NavigationBarViewController, NavigationBarViewControllerExtension, UITableViewDelegate, UITableViewDataSource {
    
    internal static let identifier: String = "ProfileViewController"
    internal let activeSessionTopAnchor: CGFloat = 270
    internal let nonActiveSessionTopAnchor: CGFloat = 0

    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var settingsBackgroundTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var settingsTableView: UITableView!
    
    private var hackerUUID: HackerUUID?
    private var viewModel: ProfileViewControllerModel = ProfileViewControllerModel()
    
    private var isUserLoggedIn: Bool = false {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            if isUserLoggedIn {
                setupActiveSessionNavigation()
            } else {
                setupNonActiveSessionNavigation()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfilePictureButton()
        setupTableView()
        attemptToRetrieveUserData()
        
        if self.isUserLoggedIn {
            setupActiveSessionNavigation(withAnimation: false)
        } else {
            setupNonActiveSessionNavigation(withAnimation: false)
        }
    }
    
    private func setupTableView() {
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
    }
    
    private func attemptToRetrieveUserData() {
        guard let hackerUUID = UserDefaultsHolder.getHackerUUID() else {
            isUserLoggedIn = false
            return
        }
        self.hackerUUID = hackerUUID
        isUserLoggedIn = true
    }
    
    // MARK: Table View Datasource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nonActiveSessionMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell,
            indexPath.row <  viewModel.nonActiveSessionMenuItems.count
        else {
            return UITableViewCell()
        }
        
        cell.model = viewModel.nonActiveSessionMenuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row <  viewModel.nonActiveSessionMenuItems.count else {
            return
        }
        
        let model = viewModel.nonActiveSessionMenuItems[indexPath.row]
        switch model.function {
        case .scanQR:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: QRScannerViewController.identifier)
            nextViewController.modalTransitionStyle = .crossDissolve
            self.present(nextViewController, animated: true, completion: nil)
        default:
            return
        }
    }
    
    @IBAction func profilePictureButtonClicked(_ sender: Any) {
        // logic to change user profile picture
    }
}
