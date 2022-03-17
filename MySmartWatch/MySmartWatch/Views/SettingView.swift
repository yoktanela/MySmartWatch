//
//  SettingView.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 16.03.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingView: UIControl {
    
    var value: String = "-" {
        didSet {
            self.setValue()
            sendActions(for: .valueChanged)
        }
    }
    
    var settingLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "textColor")
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .light)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var settingImg: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.opacity = 0.5
        return imgView
    }()
    
    var valueLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "textColor")
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    init(text: String, image: UIImage) {
        super.init(frame: CGRect.zero)
        self.settingLabel.text = text
        self.settingImg.image = image
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.addSubview(settingImg)
        settingImg.translatesAutoresizingMaskIntoConstraints = false
        let widthImgConstraint = settingImg.widthAnchor.constraint(equalTo: settingImg.heightAnchor)
        let heightImgConstraint = settingImg.heightAnchor.constraint(equalToConstant: 20.0)
        let centerYImg = settingImg.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let leftImgConstraint = settingImg.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0)
        self.addConstraints([widthImgConstraint, heightImgConstraint, centerYImg, leftImgConstraint])
        
        self.addSubview(settingLabel)
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        let topLblConstariant = settingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0)
        let leftLblConstraint = settingLabel.leftAnchor.constraint(equalTo: self.settingImg.rightAnchor, constant: 20.0)
        let bottomLblConstariant = settingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0)
        self.addConstraints([topLblConstariant, leftLblConstraint, bottomLblConstariant])
        
        self.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        let topValConstraint = valueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0)
        let rightValConstraint = valueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0)
        self.addConstraints([topValConstraint, rightValConstraint])
    }
    
    func setValue() {
        self.valueLabel.text = value
    }
    
    func setSettingText(text: String ) {
        self.settingLabel.text = text
    }
}

extension Reactive where Base: SettingView {

    var value: ControlProperty<String> {
        return base.rx.controlProperty(editingEvents: UIControl.Event.valueChanged, getter: { view in
            return view.value
        },setter: { (view, newValue) in
            view.value = newValue
        })
    }
}
