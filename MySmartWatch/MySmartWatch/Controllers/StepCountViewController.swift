//
//  StepCountViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 10.03.2022.
//

import Foundation
import UIKit
import CoreBluetooth
import RxSwift
import RxCocoa

class StepCountViewController: UIViewController {
    
    var peripheralViewModel: PeripheralViewModel?
    private var disposeBag = DisposeBag()
    
    var stepCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "textColor")
        lbl.font = UIFont.systemFont(ofSize: 50, weight: .light)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        return indicator
    }()
    
    var stepImg: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "footImg")
            imgView.layer.opacity = 0.5
            return imgView
        }()
    
    init(peripheralViewModel: PeripheralViewModel) {
        self.peripheralViewModel = peripheralViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        setSubviews()
        bindUI()
    }
    
    func setSubviews() {
        self.view.addSubview(stepCountLabel)
        stepCountLabel.translatesAutoresizingMaskIntoConstraints = false
        let topLblConstariant = stepCountLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50.0)
        let leftLblConstraint = stepCountLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        let rightLblConstraint = stepCountLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        self.view.addConstraints([topLblConstariant, leftLblConstraint, rightLblConstraint])
        
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = activityIndicator.centerXAnchor.constraint(equalTo: self.stepCountLabel.centerXAnchor)
        let centerY = activityIndicator.centerYAnchor.constraint(equalTo: self.stepCountLabel.centerYAnchor)
        self.view.addConstraints([centerX, centerY])
        
        self.view.addSubview(stepImg)
        stepImg.translatesAutoresizingMaskIntoConstraints = false
        let topImgConstariant = stepImg.topAnchor.constraint(equalTo: self.activityIndicator.bottomAnchor, constant: 20.0)
        let widthImgConstraint = stepImg.widthAnchor.constraint(equalTo: stepImg.heightAnchor)
        let heightImgConstraint = stepImg.heightAnchor.constraint(equalToConstant: 50.0)
        let centerXImg = stepImg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        self.view.addConstraints([topImgConstariant, widthImgConstraint, heightImgConstraint, centerXImg])
    }
    
    func bindUI() {
        
        let running = BehaviorRelay<Bool>(value: true)
        peripheralViewModel?.stepCount
            .compactMap {$0}
            .flatMap { step -> Observable<Bool> in
                return .just(false)
            }.asDriver(onErrorJustReturn: true)
            .drive(running)
            .disposed(by: disposeBag)
        
        running.asDriver()
            .drive(self.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        peripheralViewModel?.stepCount
            .compactMap {$0}
            .flatMap { step -> Observable<String> in
                return .just(String(step))
            }.asDriver(onErrorJustReturn: "")
            .drive(stepCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
