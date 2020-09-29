//
//  CountryTableViewCell.swift
//  iAPICaller
//
//  Created by Mantas Paškevičius on 2020-08-08.
//  Copyright © 2020 Mantas Paškevičius. All rights reserved.
//

import UIKit
import SnapKit

class CountryTableViewCell: UITableViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 60
        stackView.axis = .horizontal
        return stackView
    }()
    
    let CountryNameLabel2: UILabel = {
        let label = UILabel()
        label.text = "Lithuania #86"
        
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let DistanceLabel2: UILabel = {
        let label = UILabel()
        label.text = "1586"
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = .green
        label.textAlignment = .right
        return label
    }()
    
    override func awakeFromNib() {
        addSubview(CountryNameLabel2)
        addSubview(DistanceLabel2)
        setSnapKitConstraints()
    
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setSnapKitConstraints() {
        CountryNameLabel2.snp.makeConstraints { (label) in
            label.width.equalTo(200)
            label.top.equalToSuperview()
            label.left.equalToSuperview()
            label.bottom.equalToSuperview()
        }
        
        DistanceLabel2.snp.makeConstraints { label in
            label.width.equalTo(200)
            label.top.equalToSuperview()
            label.right.equalToSuperview().offset(-50)
            label.bottom.equalToSuperview()
        }
    }
    
}
