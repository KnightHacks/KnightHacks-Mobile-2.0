//
//  SponsorsTableViewController.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 7/28/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit

internal class SponsorsTableViewController: NavigationBarTableViewController, NavigationBarViewControllerExtension, FilterCollectionViewObserver, ModelObserver {
    
    internal static let identifier: String = "SponsorsTableViewController"
    
    private var filterCollectionView: FilterCollectionView!
    private var viewModel: SponsorTableViewControllerModel!
    
    var filters: [FilterMenuModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = SponsorTableViewControllerModel()
        self.viewModel.observer = self
        self.filters = viewModel.filters
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.colorUpper(view: tableView, with: BACKGROUND_COLOR)
        self.filterCollectionView = addFilterCollectionView(to: tableView, datasource: self.viewModel)
        self.viewModel.filterCollectionView = self.filterCollectionView
        
        // disable filter collection view
        self.tableView.tableHeaderView = makeTemporaryHeaderCover()
    }
    
    private func makeTemporaryHeaderCover() -> UIView {
        let diffPoint: CGFloat = 18
        let height: CGFloat = 30
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: height))
        let bottomLayerView = UIView(frame: CGRect(x: 0, y: diffPoint, width: self.view.frame.width, height: height - diffPoint))
        
        view.backgroundColor = BACKGROUND_COLOR
        bottomLayerView.backgroundColor = .white
        view.addSubview(bottomLayerView)
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchSponsorData()
        self.add(navigationController: navigationController, and: navigationItem, with: BACKGROUND_COLOR)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Filter Delegate
    
    func didSelectFilter(filter: FilterMenuModel) {
        self.viewModel.filterSponsorData(with: filter)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.addBackgroundView(using: viewModel.viewContent)
        return viewModel.viewContent.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SponsorsTableViewCell.identifier, for: indexPath) as? SponsorsTableViewCell,
            indexPath.row < viewModel.viewContent.count else {
            return UITableViewCell()
        }
        
        cell.model = viewModel.viewContent[indexPath.row]
        return cell
    }
    
    // MARK: - View model delegate
    
    func didFetchModel() {
        self.tableView.reloadData()
    }
}
