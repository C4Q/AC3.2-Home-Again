//
//  DetailTableViewCell.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    var facilityName = UILabel()
    var facilityAddress = UILabel()
    var facilityDistance = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        facilityName.textColor = .black
        facilityName.font = UIFont.systemFont(ofSize: 20.0)
        facilityAddress.numberOfLines = 0
        
        
        // Adding new overlay
        setHierarchyAndConstraintsOf(name: facilityName,
                                     address: facilityAddress,
                                     distance: facilityDistance,
                                     to: contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Cell Setup
    internal func setHierarchyAndConstraintsOf(name: UILabel, address: UILabel, distance: UILabel, to cell: UIView) {
        
        cell.addSubview(name)
        cell.addSubview(address)
        cell.addSubview(distance)
        
        name.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(16.0)
        }
        
        address.snp.makeConstraints { (make) in
            make.leading.equalTo(name)
            make.top.equalTo(name.snp.bottom).offset(8.0)
        }
        
        distance.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(name)
        }
    
    }

}
