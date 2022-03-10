//
//  HeartRateViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 18.02.2022.
//

import Foundation
import UIKit
import CoreBluetooth
import RxSwift
import RxCocoa

class HeartRateViewController: UIViewController {
    
    var peripheralViewModel: PeripheralViewModel?
    private var disposeBag = DisposeBag()
    
    var heartRateLabel: UILabel = {
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
    
    var pulseImg: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "pulseImg")
            imgView.layer.opacity = 0.5
            return imgView
        }()

    init(bluetoothService: BluetoothService, peripheral: CBPeripheral) {
        self.peripheralViewModel = PeripheralViewModel(bluetoothService: bluetoothService, peripheral: peripheral)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        
        self.view.addSubview(heartRateLabel)
        heartRateLabel.translatesAutoresizingMaskIntoConstraints = false
        let topLblConstariant = heartRateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0)
        let leftLblConstraint = heartRateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        let rightLblConstraint = heartRateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        self.view.addConstraints([topLblConstariant, leftLblConstraint, rightLblConstraint])
        
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = activityIndicator.centerXAnchor.constraint(equalTo: self.heartRateLabel.centerXAnchor)
        let centerY = activityIndicator.centerYAnchor.constraint(equalTo: self.heartRateLabel.centerYAnchor)
        self.view.addConstraints([centerX, centerY])
        
        self.view.addSubview(pulseImg)
                pulseImg.translatesAutoresizingMaskIntoConstraints = false
                let topImgConstariant = pulseImg.topAnchor.constraint(equalTo: self.activityIndicator.bottomAnchor, constant: 20.0)
                let widthImgConstraint = pulseImg.widthAnchor.constraint(equalTo: pulseImg.heightAnchor)
                let heightImgConstraint = pulseImg.heightAnchor.constraint(equalToConstant: 50.0)
                let centerXImg = pulseImg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                self.view.addConstraints([topImgConstariant, widthImgConstraint, heightImgConstraint, centerXImg])
        
        self.bindUI()
    }
    
    func bindUI() {
        
        peripheralViewModel?.heartRate
            .flatMap { rate -> Observable<Bool> in
                if let _ = rate {
                    return .just(false)
                }
                return .just(true)
            }.asDriver(onErrorJustReturn: true)
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        peripheralViewModel?.heartRate
            .flatMap { rate -> Observable<String> in
                if let rate = rate {
                    return .just(String(rate))
                }
                return .just("")
            }.asDriver(onErrorJustReturn: "")
            .drive(heartRateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
