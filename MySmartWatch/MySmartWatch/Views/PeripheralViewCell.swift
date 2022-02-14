//
//  PeripheralViewCell.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 2.02.2022.
//

import Foundation
import UIKit

class PeripheralViewCell: UITableViewCell {
    public let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(netHex: 0xF9F9F9)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(netHex: 0x7E7F9A).cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    public let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public let rssiLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .light)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "rssi: "
        return lbl
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Container view constraints
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1)
        let bottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        let leftAnchor = containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16)
        let rightAnchor = containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        self.addConstraints([topAnchor, bottomAnchor, leftAnchor, rightAnchor])
        
        // Name label constraints
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleTopAnchor = nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0)
        let titleLeftAnchor = nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16.0)
        let titleRightAnchor = nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5.0)
        containerView.addConstraints([titleTopAnchor, titleLeftAnchor, titleRightAnchor])
        
        // rssiLabel constraints
        containerView.addSubview(rssiLabel)
        rssiLabel.translatesAutoresizingMaskIntoConstraints = false
        let rssiLabelTopAnchor = rssiLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
        let rssiLabelLeftAnchor = rssiLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16)
        let rssiLabelRightAnchor = rssiLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5)
        let rssiLabelBottomAnchor = rssiLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        containerView.addConstraints([rssiLabelTopAnchor, rssiLabelLeftAnchor, rssiLabelBottomAnchor, rssiLabelRightAnchor])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customizeCell(name: String?, rssi: NSNumber?, connectable: Bool) {
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.nameLabel.text = name
        self.rssiLabel.text = rssi?.stringValue
    }
}
