//
//  StateTableViewCell.swift
//  Representative
//
//  Created by Deniz Tutuncu on 2/7/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {
    
    var representativeLandingPad: Representative? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let unwrappedRepresentative = representativeLandingPad else { return }
        nameLabel.text = unwrappedRepresentative.name
        partyLabel.text = unwrappedRepresentative.party
        districtLabel.text = unwrappedRepresentative.district
        websiteLabel.text = unwrappedRepresentative.link
        phoneNumberLabel.text = unwrappedRepresentative.phone
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    
    
}
