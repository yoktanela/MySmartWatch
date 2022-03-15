//
//  CounterDisplayView.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 16.03.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CounterDisplayView: UIControl {
    
    var value: String = "-" {
        didSet {
            self.setValue()
            sendActions(for: .valueChanged)
        }
    }
    
    var counterLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "textColor")
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .light)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var counterImg: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.opacity = 0.5
        return imgView
    }()
    
    init(imageName: String, font: UIFont? = UIFont.systemFont(ofSize: 30, weight: .light)) {
        counterLabel.font = font
        counterImg.image = UIImage(named: imageName)
        super.init(frame: CGRect.zero)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(counterLabel)
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        let topLblConstariant = counterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0)
        let leftLblConstraint = counterLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0)
        let rightLblConstraint = counterLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0)
        self.addConstraints([topLblConstariant, leftLblConstraint, rightLblConstraint])
        
        self.addSubview(counterImg)
        counterImg.translatesAutoresizingMaskIntoConstraints = false
        let topImgConstariant = counterImg.topAnchor.constraint(equalTo: self.counterLabel.bottomAnchor, constant: 20.0)
        let widthImgConstraint = counterImg.widthAnchor.constraint(equalTo: counterImg.heightAnchor)
        let heightImgConstraint = counterImg.heightAnchor.constraint(equalToConstant: 50.0)
        let centerXImg = counterImg.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let bottomImgConstariant = counterImg.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10.0)
        self.addConstraints([topImgConstariant, widthImgConstraint, heightImgConstraint, centerXImg, bottomImgConstariant])
    }
    
    func setValue() {
        self.counterLabel.text = value
    }
}

extension Reactive where Base: CounterDisplayView {

    var value: ControlProperty<String> {
        return base.rx.controlProperty(editingEvents: UIControl.Event.valueChanged, getter: { view in
            return view.value
        },setter: { (view, newValue) in
            view.value = newValue
        })
    }
}
