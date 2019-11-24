//
//  ScheduleTableViewController.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 6/23/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit

internal class ScheduleTableViewController: NavigationBarViewController, NavigationBarViewControllerExtension, FilterCollectionViewObserver, ModelObserver {
    
    internal static let identifier: String = "ScheduleTableViewController"

    @IBOutlet private weak var mainTableView: UITableView!
    
    private var filterCollectionView: FilterCollectionView!
    private var viewModel: ScheduleTableViewControllerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ScheduleTableViewControllerModel()
        self.viewModel.observer = self
        
        self.colorUpper(view: mainTableView, with: BACKGROUND_COLOR)
        self.filterCollectionView = addFilterCollectionView(to: mainTableView, datasource: viewModel)
        self.viewModel.filterCollectionView = self.filterCollectionView
        
        self.attach(table: mainTableView, toDelegate: self, andDataSource: self)
        self.add(navigationController: navigationController, and: navigationItem, with: BACKGROUND_COLOR)
        
        // Add button overlay for map
        let mapIconImage = UIImage(named: "mapIcon")
        let viewHeight: CGFloat = self.view.frame.height
        let viewWidth: CGFloat = self.view.frame.width
        let buttonSize: CGFloat = 70
        let button = UIButton(frame: CGRect(origin: CGPoint(x: viewWidth-buttonSize-30, y: viewHeight-buttonSize-30), size: CGSize(width: buttonSize, height: buttonSize)))
        button.backgroundColor = UIColor.white
        button.setBackgroundImage(mapIconImage, for: UIControl.State.normal)
        button.layer.cornerRadius = buttonSize/2
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 12
        button.layer.shadowOffset = CGSize(width: 12.0, height: 12.0)
        button.addTarget(self, action: #selector(self.buttonClicked(_ :)), for: .touchUpInside)
        self.navigationController?.view.addSubview(button)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.fetchScheduleData()
    }
    
    // Map button press event
    @objc func buttonClicked(_ button: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController")
        
        // Remove button
        button.removeFromSuperview()
        
        // Navigate to map view controller
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // MARK: - Filter Delegate
    
    func didSelectFilter(filter: FilterMenuModel) {
        viewModel.filterData(filter)
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        super.addBackgroundView(to: mainTableView, using: viewModel.viewContent)
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = FilterTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        
        if section < viewModel.viewContent.count {
            view.headerLabel.text = viewModel.viewContent[section].first?.header
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(HEADER_IN_SECTION_HEIGHT)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewContent[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as? ScheduleTableViewCell,
            indexPath.section < viewModel.viewContent.count,
            indexPath.row < viewModel.viewContent[indexPath.section].count else {
            return UITableViewCell()
        }
        
        cell.model = viewModel.viewContent[indexPath.section][indexPath.row]
        return cell
    }
    
    // MARK: - View model delegate
    
    func didFetchModel() {
        mainTableView.reloadData()
    }
}
