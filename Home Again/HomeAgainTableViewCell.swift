//
//  HomeAgainTableViewCell.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit

class HomeAgainTableViewCell: UITableViewCell {

    // MARK: - Properties
    var sectionImage = UIImageView()
    var sectionLabel = UILabel()
    var sectionOverlay = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Customize overlay
        sectionImage.contentMode = .scaleAspectFill
        
        sectionOverlay.backgroundColor = ColorPalette.darkestBlue
        sectionOverlay.alpha = 0.5
        
        sectionLabel.textAlignment = .center
        sectionLabel.font = UIFont.systemFont(ofSize: 24.0)
        sectionLabel.textColor = ColorPalette.textIconColor
        sectionLabel.layer.borderColor = ColorPalette.textIconColor.cgColor
        sectionLabel.layer.borderWidth = 3.0
        
        // Adding new overlay
        setHierarchyAndConstraintsOf(image: sectionImage,
                                     label: sectionLabel,
                                     overlay: sectionOverlay,
                                     to: contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Setup
    internal func setHierarchyAndConstraintsOf(image: UIImageView, label: UILabel, overlay: UIView, to cell: UIView) {
        cell.addSubview(image)
        cell.addSubview(overlay)
        cell.addSubview(label)
        
        image.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.center.equalTo(cell)
            make.width.equalTo(250.0)
            make.height.equalTo(80.0)
        }
        
        overlay.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(image)
        }
    }
    
}
