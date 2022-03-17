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
    
    var peripheralViewModel: PeripheralViewModel!
    private var disposeBag = DisposeBag()
    
    var deviceInfoView: DeviceInfoView = {
        let view = DeviceInfoView()
        return view
    }()
    
    var findDeviceSetting: SettingView = {
        let view = SettingView(text: "Find My Device", image: #imageLiteral(resourceName: "vibrationImg"))
        return view
    }()
    
    var alarmSettingView: SettingView = {
        let view = SettingView(text: "Alarm Clock", image: #imageLiteral(resourceName: "alarmImg"), nextEnabled: true)
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
        self.bindUI()
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
        
        self.view.addSubview(findDeviceSetting)
        self.findDeviceSetting.translatesAutoresizingMaskIntoConstraints = false
        let findTopConstraint = findDeviceSetting.topAnchor.constraint(equalTo: self.deviceInfoView.bottomAnchor, constant: 20.0)
        let findLeftConstraint = findDeviceSetting.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let findRightConstraint = findDeviceSetting.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        self.view.addConstraints([findTopConstraint, findLeftConstraint, findRightConstraint])
        
        self.view.addSubview(alarmSettingView)
        self.alarmSettingView.translatesAutoresizingMaskIntoConstraints = false
        let alarmTopConstraint = alarmSettingView.topAnchor.constraint(equalTo: self.findDeviceSetting.bottomAnchor, constant: 20.0)
        let alarmLeftConstraint = alarmSettingView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let alarmRightConstraint = alarmSettingView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        self.view.addConstraints([alarmTopConstraint, alarmLeftConstraint, alarmRightConstraint])
    }
    
    func bindUI() {
        peripheralViewModel.battery
            .compactMap{$0}
            .flatMap { value -> Observable<String> in
                return .just("\(String(value))%")
            }.asDriver(onErrorJustReturn: "-")
            .drive(self.deviceInfoView.rx.batteryText)
            .disposed(by: disposeBag)
        
        findDeviceSetting.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                self.peripheralViewModel.vibrateDevice()
            })
            .disposed(by: disposeBag)
        
        alarmSettingView.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                let alarmVC = AlarmClockViewController(peripheralViewModel: self.peripheralViewModel)
                let navigationController = UINavigationController(rootViewController: alarmVC)
                alarmVC.navigationItem.title = "Alarm Clock"
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
}
