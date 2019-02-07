//
//  StateDetailTableViewController.swift
//  Representative
//
//  Created by Deniz Tutuncu on 2/7/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateDetailTableViewController: UITableViewController {
    
    var state: String?
    
    var representatives: [Representative] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        title = state
        if let state = state {
            RepresentativeController.searchRepresentatives(forState: state) { (representatives) in
                DispatchQueue.main.async {
                    self.representatives = representatives
                    self.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representatives.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "representiveCell", for: indexPath) as? StateTableViewCell
        let representative = representatives[indexPath.row]
        cell?.representativeLandingPad = representative
        
        return cell ?? UITableViewCell()
    }
    
}
