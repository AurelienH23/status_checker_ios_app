//
//  ServiceCell.swift
//  StatusChecker
//
//  Created by Aurélien Haie on 24/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {
    
    // MARK: - Properties
    
    var service: ServiceData? {
        didSet {
            guard let service = service else { return }
            textLabel?.text = service.name
            detailTextLabel?.text = "Last time checked : \(service.lastTimeChecked)"
            statusLabel.text = service.status == 200 ? "OK" : "FAIL"
            statusLabel.backgroundColor = service.status == 200 ? .appGreen : .appRed
        }
    }
    
    // MARK: - View elements
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Lifecycle funcs
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom funcs
    
    fileprivate func setupCellView() {
        textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        detailTextLabel?.font = .systemFont(ofSize: 16, weight: .light)
        detailTextLabel?.textColor = .gray
        
        contentView.addSubview(statusLabel)
        statusLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 16, width: 60, height: 30)
    }
    
}
