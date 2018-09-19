//
//  FrequentlyAskedViewController.swift
//  KH_prototype_one
//
//  Created by Lloyd Dapaah on 9/18/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class FrequentlyAskedViewController: ParentTableView {
    var isCellReduced: [Bool] = [true, true, true, true, true, true, true, true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        self.navigationItem.title = "Frequently Asked"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DynamicTableViewCell.identifier, for: indexPath) as! DynamicTableViewCell
        cell.cellType = .hiddenDetailedCell
        cell.isShowingDetails = !isCellReduced[indexPath.row]
        
        cell.showMoreButton?.tag = indexPath.row
        cell.showMoreButton?.addTarget(self, action: #selector(expandOrShrinkCell(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func expandOrShrinkCell(sender: UIButton) {
        isCellReduced[sender.tag] = !isCellReduced[sender.tag]

        tableView.allowsSelectionDuringEditing = false
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
        tableView.endUpdates()
    }
    
}
