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
        
        self.bindUI()
    }
    
    func bindUI() {
        peripheralViewModel?.connected
            .subscribe(onNext: { value in
                if value {
                    // remove indicator
                } else {
                    //empty state
                }
            }).disposed(by: disposeBag)
        
        let heartRateStr = peripheralViewModel?.heartRate
            .flatMap { rate -> Observable<String> in
                if let rate = rate {
                    return .just(String(rate))
                }
                return .just("")
            }.asDriver(onErrorJustReturn: "")
        
        heartRateStr?.drive(heartRateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
