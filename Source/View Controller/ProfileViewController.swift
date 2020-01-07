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
    @IBOutlet weak var settingsBackgroundView: UIView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var profileBackgroundImageView: UIView!
    
    private var hackerUUID: HackerUUID?
    private var viewModel: ProfileViewControllerModel = ProfileViewControllerModel(isActiveSession: false)
    
    private var isUserLoggedIn: Bool! {
        didSet {
            guard isUserLoggedIn != nil else {
                return
            }
            
            viewModel.isActiveSession = isUserLoggedIn
            guard isViewLoaded else {
                return
            }
            
            if isUserLoggedIn {
                setupActiveSessionNavigation(withAnimation: true)
            } else {
                setupNonActiveSessionNavigation(withAnimation: true)
            }
            settingsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = PROFILE_BACKGROUND_COLOR
        self.settingsBackgroundTopAnchor.constant = nonActiveSessionTopAnchor
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfilePictureButton()
        setupSettingsBackgroundAndTable()
        attemptToRetrieveUserData()
        
        if self.isUserLoggedIn {
            setupActiveSessionNavigation(withAnimation: false)
            // fetch hacker content
        } else {
            setupNonActiveSessionNavigation(withAnimation: false)
        }
        settingsTableView.reloadData()
    }
    
    private func setupSettingsBackgroundAndTable() {
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        addSpecifiedShadow(self.settingsBackgroundView)
        self.settingsBackgroundView.clipsToBounds = true
        self.settingsBackgroundView.layer.cornerRadius = 28
    }
    
    private func attemptToRetrieveUserData() {
        /*
        **Note** Commented out temporarily
        guard let hackerUUID = UserDefaultsHolder.getHackerUUID() else {
            isUserLoggedIn = false
            return
        }
        self.hackerUUID = hackerUUID
        */
        isUserLoggedIn = true
    }
    
    // MARK: Table View Datasource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell,
            indexPath.row <  viewModel.tableContent.count
        else {
            return UITableViewCell()
        }
        
        cell.model = viewModel.tableContent[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row <  viewModel.tableContent.count else {
            return
        }
        
        performModel(viewModel.tableContent[indexPath.row].function)
    }
    
    private func performModel(_ function: SettingsMenuModelFunction) {
        switch function {
        case .automaticLogin:
            presentQRScanner()
            return
        case .logout:
            logoutUser()
            return
        default:
            return
        }
    }
    
    private func logoutUser() {
        UserDefaultsHolder.clearHackerData()
        isUserLoggedIn = false
    }
    
    private func presentQRScanner() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: QRScannerViewController.identifier)
        nextViewController.modalTransitionStyle = .crossDissolve
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func profilePictureButtonClicked(_ sender: Any) {
        presentCameraPickerViewController()
    }
}
