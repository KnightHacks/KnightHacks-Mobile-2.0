//
//  FilterCollectionView.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 6/23/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit

/**
 This protocol provides the datasource for filter collection view cells
 */
public protocol FilterCollectionViewDataSource {
    var filters: [FilterMenuModel] { get set }
}

/**
 This protocol only provides menu tapped responses. For more control, overriding the delegate with a UICollectionViewDelegate is recommended.
 */
public protocol FilterCollectionViewDelegate {
    func didSelectFilter(filter: FilterMenuModel)
}

/**
 A filter menu view for sorting and sectioning large lists of data
 - Requires the implementation of FilterCollectionViewDataSource to set filter button contents
 - Filter menu functionality can be extended either through FilterCollectionViewDelegate or UICollectionViewDelegate for more user-defined functions
 */
public class FilterCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public static let nibName: String = "FilterCollectionView"
    public static let minimumRequiredHeight: CGFloat = 115
    public static let minimumRequiredWidth: CGFloat = 85
    public static let minimumCellFrame: CGRect = CGRect(
        x: 0, y: 0, width: FilterCollectionView.minimumRequiredWidth, height: FilterCollectionView.minimumRequiredHeight
    )
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    public var dataSource: FilterCollectionViewDataSource?
    public var delegate: FilterCollectionViewDelegate?
    
//    public var viewHasAppeared: Bool = false
//    public var filters: [FilterMenuModel] = []
    
    public final func performLoadingAnimation() {
        
        guard self.window != nil else { return }
        guard let source = dataSource, !source.filters.isEmpty else { return }
        
        // reload filters
        collectionView.reloadData()
        
        // scroll to end
        let path = IndexPath(row: source.filters.count - 1, section: 0)
//        collectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        collectionView.selectItem(at: path, animated: true, scrollPosition: .centeredHorizontally)
    }
    
//    public var shouldStartLoadingAnimation: Bool? {
//        didSet {
//            guard shouldStartLoadingAnimation == true  else { return }
//            guard let datasource = dataSource else { return }
//            collectionView.selectItem(at: IndexPath(row: datasource.filters.count - 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
        self.initCollectionView()
        collectionView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
        self.initCollectionView()
        collectionView.delegate = self
    }
    
    private func initView() {
        Bundle.main.loadNibNamed(FilterCollectionView.nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func initCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: FilterCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        collectionView.backgroundColor = selectedCellColor(selectedController: AppDelegate.selectedCellId)
        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let source = dataSource, indexPath.row < source.filters.count else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.didSelectFilter(filter: source.filters[indexPath.row])
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FilterCollectionView.minimumRequiredWidth, height: FilterCollectionView.minimumRequiredHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.filters.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell,
            let source = dataSource,
            indexPath.row < source.filters.count
        else {
            return UICollectionViewCell(frame: FilterCollectionView.minimumCellFrame)
        }
        cell.model = source.filters[indexPath.row]
        cell.backgroundColor = selectedCellColor(selectedController: AppDelegate.selectedCellId)
        
        return cell
    }
    
    public func selectedCellColor(selectedController: String) -> UIColor {
        
        switch selectedController {
        case "ScheduleTableViewController":
            return SCHEDULE_MENU_COLOR
        case "WorkshopTableViewController":
            return WORKSHOPS_MENU_COLOR
        case "SponsorsTableViewController":
            return SPONSORS_MENU_COLOR
        case "LiveUpdatesTableViewController":
            return LIVE_UPDATES_MENU_COLOR
        case "FrequentlyAskedTableViewController":
            return FAQS_MENU_COLOR
        case "ProfileViewController":
            return PROFILE_MENU_COLOR
        default:
            return BACKGROUND_COLOR
        }
    }
//    public final func reloadData() {
//        guard let !filters.isEmpty else { return }
//
//        self.collectionView.reloadData()
//        let path = IndexPath(row: .count - 1, section: 0)
//        self.collectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
//    }
}
