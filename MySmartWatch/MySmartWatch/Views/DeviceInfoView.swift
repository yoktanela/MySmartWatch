//
//  DeviceInfoView.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 17.03.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DeviceInfoView: UIControl {
    
    var batteryText: String = "-" {
        didSet {
            self.setBattery()
            sendActions(for: .valueChanged)
        }
    }
    
    var deviceNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "textColor")
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var batteryImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "batteryImg")
        return imgView
    }()
    
    var batteryLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "textColor")
        lbl.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        lbl.textAlignment = .left
        lbl.text = "100%"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    init(deviceName: String = "") {
        super.init(frame: CGRect.zero)
        self.deviceNameLabel.text = deviceName
        self.setUp()
    }
    
    func setUp() {
        
        self.addSubview(deviceNameLabel)
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let topLblConstariant = deviceNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0)
        let leftLblConstraint = deviceNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0)
        let bottomLblConstariant = deviceNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0)
        self.addConstraints([topLblConstariant, leftLblConstraint, bottomLblConstariant])
        
        self.addSubview(batteryImageView)
        batteryImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerY = batteryImageView.centerYAnchor.constraint(equalTo: self.deviceNameLabel.centerYAnchor)
        let rightImgConstraint = batteryImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0)
        let widthImgConstraint = batteryImageView.widthAnchor.constraint(equalTo: batteryImageView.heightAnchor)
        let heightImgConstraint = batteryImageView.heightAnchor.constraint(equalToConstant: 30.0)
        self.addConstraints([centerY, rightImgConstraint, widthImgConstraint, heightImgConstraint])
        
        self.addSubview(batteryLabel)
        batteryLabel.translatesAutoresizingMaskIntoConstraints = false
        let lblCenterX = batteryLabel.centerXAnchor.constraint(equalTo: self.batteryImageView.centerXAnchor)
        let lblCenterY = batteryLabel.centerYAnchor.constraint(equalTo: self.batteryImageView.centerYAnchor)
        self.addConstraints([lblCenterX, lblCenterY])
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor(named: "borderColor")
        self.addSubview(bottomBorder)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = bottomBorder.leftAnchor.constraint(equalTo: self.leftAnchor)
        let rightConstraint = bottomBorder.rightAnchor.constraint(equalTo: self.rightAnchor)
        let bottomConstraint = bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let heightConstraint = bottomBorder.heightAnchor.constraint(equalToConstant: 1.0)
        self.addConstraints([leftConstraint, rightConstraint, bottomConstraint, heightConstraint])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDeviceName(name: String) {
        self.deviceNameLabel.text = name
    }
    
    func setBattery() {
        batteryLabel.text = batteryText
    }
}

extension Reactive where Base: DeviceInfoView {

    var batteryText: ControlProperty<String> {
        return base.rx.controlProperty(editingEvents: UIControl.Event.valueChanged, getter: { view in
            return view.batteryText
        },setter: { (view, newValue) in
            view.batteryText = newValue
        })
    }
}
