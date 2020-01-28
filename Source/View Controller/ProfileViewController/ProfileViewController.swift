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
    @IBOutlet weak var cameraIconImageView: UIImageView!
    
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
    var alternativeLoginView: AlternativeLoginView?
    
    // activity outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        self.setupNameAndPointsLabals()
        self.setupProfileBackgroundImage()
        self.setupSettingsBackgroundAndTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfilePictureButton()
        attemptToRetrieveUserData()
        settingsTableView.reloadData()
    }
    
    private func setupProfileBackgroundImage() {
        let imageView = UIImageView(image: UIImage(named: "profile-picture-background"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        profileBackgroundImageView.insertSubview(imageView, at: 0)
        imageView.topAnchor.constraint(equalTo: profileBackgroundImageView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: profileBackgroundImageView.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: profileBackgroundImageView.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: profileBackgroundImageView.bottomAnchor).isActive = true
    }
    
    private func setupNameAndPointsLabals() {
        profileNameLabel.textColor = BACKGROUND_COLOR
        pointsLabel.textColor = BACKGROUND_COLOR
        pointsLabel.layer.cornerRadius = 15
        pointsLabel.clipsToBounds = true
        pointsLabel.layoutIfNeeded()
        
        if let image = UserDefaultsHolder.getProfileImage() {
            profilePictureButton.setImage(image, for: .normal)
        }
    }
    
    private func setupSettingsBackgroundAndTable() {
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        addSpecifiedShadow(self.settingsBackgroundView)
        self.settingsBackgroundView.clipsToBounds = true
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
        case .manualLogin:
            showAlternativeLogin()
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
        showUIImagePickerControllerActionSheet()
    }
    
    @IBAction func QRDisplayCancelTapped(_ sender: Any) {
        hideQRDisplayBackgroundView()
    }
    
    @IBAction func confirmLogoutTapped(_ sender: Any) {
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        viewModel.logoutHacker { (_) in
            self.view.isUserInteractionEnabled = true
            UserDefaultsHolder.clearHackerData()
            self.activityIndicator.stopAnimating()
            
            self.updateView()
            self.hideConfirmLogoutPanel()
            self.isUserLoggedIn = false
        }
    }
    
    @IBAction func cancelConfirmLogoutPanelTapped(_ sender: Any) {
        hideConfirmLogoutPanel()
    }
}
