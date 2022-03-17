//
//  AlarmClockViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 17.03.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AlarmClockViewController: UIViewController {
    
    var peripheralViewModel: PeripheralViewModel!
    private var disposeBag = DisposeBag()
    
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
        
        self.navigationItem.title = "Alarm Clock"
        self.navigationItem
            .setLeftBarButton(UIBarButtonItem.menuButton(image: #imageLiteral(resourceName: "backImg")
                                                            .withRenderingMode(.alwaysOriginal),
                                                         self,
                                                         action: #selector(back(sender:))), animated: true)
        
        self.navigationItem
            .setRightBarButton(UIBarButtonItem.menuButton(image: #imageLiteral(resourceName: "plusImg")
                                                            .withRenderingMode(.alwaysOriginal),
                                                          self,
                                                          action: #selector(addAlarm(sender:))), animated: true)
        self.setSubViews()
        self.bindUI()
    }
    
    func setSubViews() {
        // set alarm table view
    }
    
    func bindUI() {
        // bind ui
        self.peripheralViewModel
            .alarms
            .subscribe( onNext: { alarms in
                alarms.forEach { alarm in
                    print(alarm.hour)
                    print(alarm.minute)
                }
            })
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addAlarm(sender: UIBarButtonItem) {
        let addAlarmVC = AddAlarmViewController(peripheralViewModel: peripheralViewModel)
        let navController = UINavigationController(rootViewController: addAlarmVC)
        self.present(navController, animated: true, completion: nil)
    }
}
