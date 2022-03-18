//
//  DayViewCell.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 18.03.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DayViewCell: UITableViewCell {
    
    public let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    public let selectionBox : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "unselectedImg")
        return img
    }()
    
    public let dayNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .light)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var _picked: Bool = false
    public var picked: Bool {
        get {
            return _picked
        } set {
            _picked = newValue
            if (newValue) {
                self.selectionBox.image = #imageLiteral(resourceName: "selectedImg")
            } else {
                self.selectionBox.image = #imageLiteral(resourceName: "unselectedImg")
            }
        }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1)
        let bottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        let leftAnchor = containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        let rightAnchor = containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        self.addConstraints([topAnchor, bottomAnchor, leftAnchor, rightAnchor])
        
        containerView.addSubview(selectionBox)
        selectionBox.translatesAutoresizingMaskIntoConstraints = false
        let boxTopAnchor = selectionBox.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0)
        let boxLeftAnchor = selectionBox.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16.0)
        let boxBottomAnchor = selectionBox.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0)
        let boxHeightAnchor = selectionBox.heightAnchor.constraint(equalToConstant: 15.0)
        let boxWidthAnchor = selectionBox.widthAnchor.constraint(equalTo: selectionBox.heightAnchor)
        containerView.addConstraints([boxTopAnchor, boxLeftAnchor, boxBottomAnchor, boxHeightAnchor, boxWidthAnchor])
        
        containerView.addSubview(dayNameLabel)
        dayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelYAnchor = dayNameLabel.centerYAnchor.constraint(equalTo: selectionBox.centerYAnchor)
        let labelLeftAnchor = dayNameLabel.leftAnchor.constraint(equalTo: selectionBox.rightAnchor, constant: 16.0)
        let labelRightAnchor = dayNameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 10.0)
        containerView.addConstraints([labelYAnchor, labelLeftAnchor, labelRightAnchor])
        
        self.addBottomSeperator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customizeCell(dayName: String) {
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.dayNameLabel.text = dayName
    }
}
