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
    
    internal let logoutRisenBottomAnchor: CGFloat = -10
    internal let logoutHiddenBottomAnchor: CGFloat = -170

    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var settingsBackgroundTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var settingsBackgroundView: UIView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var profileBackgroundImageView: UIView!
    
    // QR Display Outlets
    @IBOutlet weak var QRImageView: UIImageView!
    @IBOutlet var QRDisplayBackgroundView: UIView!
    @IBOutlet weak var logoutPopupView: UIView!
    @IBOutlet weak var QRDisplayNameLabel: UILabel!
    @IBOutlet weak var QRDisplayCenterView: UIView!
    
    // Confirm logout outlets
    @IBOutlet weak var confirmLogoutButton: UIButton!
    @IBOutlet weak var confirmLogoutPanelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var confirmLogoutBackgroundView: UIView!
    internal var coverView: UIView?
    
    internal var viewModel: ProfileViewControllerModel = ProfileViewControllerModel()
    
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
        self.setupQRDisplayView()
        self.setupConfirmLogoutPanel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfilePictureButton()
        setupSettingsBackgroundAndTable()
        attemptToRetrieveUserData()
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
        viewModel.reloadLocalSessionIfNeeded()
        isUserLoggedIn = self.viewModel.hackerInfo != nil
        
        if self.isUserLoggedIn {
            setupActiveSessionNavigation(withAnimation: false)
            viewModel.reloadQRCodeImageIfNeeded()
            viewModel.getHackerInfo { (didGetHackerInfo) in
                if didGetHackerInfo {
                    self.updateView()
                    self.settingsTableView.reloadData()
                }
            }
        } else {
            setupNonActiveSessionNavigation(withAnimation: false)
        }
    }
    
    // MARK: Table View Datasource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell,
            indexPath.row < viewModel.tableContent.count
        else {
            return UITableViewCell()
        }
        
        cell.model = viewModel.tableContent[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.tableContent.count else {
            return
        }
        performModel(viewModel.tableContent[indexPath.row].function)
    }
    
    private func performModel(_ function: SettingsMenuModelFunction) {
        switch function {
        case .automaticLogin:
            presentQRScanner()
            return
        case .presentQRCode:
            presentQRDisplay()
            return
        case .logout:
            logoutUser()
            return
        default:
            return
        }
    }
    
    private func updateView() {
        
    }
    
    private func logoutUser() {
        showConfirmLogoutPanel()
    }
    
    private func presentQRScanner() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: QRScannerViewController.identifier)
        nextViewController.modalTransitionStyle = .crossDissolve
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    private func presentQRDisplay() {
        showQRDisplayBackgroundView()
    }
    
    @IBAction func profilePictureButtonClicked(_ sender: Any) {
        presentCameraPickerViewController()
    }
    
    @IBAction func QRDisplayCancelTapped(_ sender: Any) {
        hideQRDisplayBackgroundView()
    }
    
    @IBAction func confirmLogoutTapped(_ sender: Any) {
        viewModel.logoutHacker { (didLogout) in
            guard didLogout else {
                return
            }
            
            UserDefaultsHolder.clearHackerData()
            self.updateView()
            self.hideConfirmLogoutPanel()
            self.isUserLoggedIn = false
        }
    }
}
