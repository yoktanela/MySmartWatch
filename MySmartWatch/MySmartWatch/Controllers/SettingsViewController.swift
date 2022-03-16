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
    
    var batteryView: SettingView = {
        let settingView = SettingView(text: "Battery", image: #imageLiteral(resourceName: "batteryImg"))
        return settingView
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
        self.view.addSubview(batteryView)
        self.batteryView.translatesAutoresizingMaskIntoConstraints = false
        let batteryTopConstraint = batteryView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50.0)
        let batteryRightConstraint = batteryView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        let batteryLeftConstraint = batteryView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        self.view.addConstraints([batteryTopConstraint, batteryLeftConstraint, batteryRightConstraint])
        if let deviceName = self.peripheralViewModel?.getDeviceName() {
            batteryView.setSettingText(text: deviceName)
        }
        
        peripheralViewModel?.battery
            .compactMap{$0}
            .flatMap { value -> Observable<String> in
                return .just("\(String(value)) %")
            }.asDriver(onErrorJustReturn: "-")
            .drive(self.batteryView.rx.value)
            .disposed(by: disposeBag)
    }
    
}
