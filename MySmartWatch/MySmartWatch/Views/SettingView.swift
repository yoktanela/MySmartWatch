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
    
    var settingLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "textColor")
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var settingImg: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.opacity = 0.5
        return imgView
    }()
    
    var nextImg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "nextImg")
        return imgView
    }()
    
    init(text: String, image: UIImage, nextEnabled: Bool = false) {
        super.init(frame: CGRect.zero)
        self.settingLabel.text = text
        self.settingImg.image = image
        self.setUp()
        if nextEnabled { self.setNextImage() }
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
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor(named: "lightGray")
        self.addSubview(bottomBorder)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = bottomBorder.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0)
        let rightConstraint = bottomBorder.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0)
        let bottomConstraint = bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let heightConstraint = bottomBorder.heightAnchor.constraint(equalToConstant: 1.0)
        self.addConstraints([leftConstraint, rightConstraint, bottomConstraint, heightConstraint])
    }
    
    func setNextImage() {
        self.addSubview(self.nextImg)
        nextImg.translatesAutoresizingMaskIntoConstraints = false
        let centerY = nextImg.centerYAnchor.constraint(equalTo: self.settingLabel.centerYAnchor)
        let rightConstraint = nextImg.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0)
        let widthImgConstraint = nextImg.widthAnchor.constraint(equalTo: nextImg.heightAnchor)
        let heightImgConstraint = nextImg.heightAnchor.constraint(equalToConstant: 20.0)
        self.addConstraints([centerY, rightConstraint, widthImgConstraint, heightImgConstraint])
    }
}
