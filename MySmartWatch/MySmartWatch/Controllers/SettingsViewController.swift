//
//  SettingsViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 16.03.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    var peripheralViewModel: PeripheralViewModel?
    private var disposeBag = DisposeBag()
    
    var deviceInfoView: DeviceInfoView = {
        let view = DeviceInfoView()
        return view
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
        self.setSubViews()
    }
    
    func setSubViews() {
        
        if let deviceName = self.peripheralViewModel?.getDeviceName() {
            deviceInfoView.setDeviceName(name: deviceName)
        }
        
        self.view.addSubview(deviceInfoView)
        self.deviceInfoView.translatesAutoresizingMaskIntoConstraints = false
        let batteryTopConstraint = deviceInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0)
        let batteryRightConstraint = deviceInfoView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        let batteryLeftConstraint = deviceInfoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        self.view.addConstraints([batteryTopConstraint, batteryLeftConstraint, batteryRightConstraint])
        
        peripheralViewModel?.battery
            .compactMap{$0}
            .flatMap { value -> Observable<String> in
                return .just("\(String(value))%")
            }.asDriver(onErrorJustReturn: "-")
            .drive(self.deviceInfoView.rx.batteryText)
            .disposed(by: disposeBag)
    }
    
}
