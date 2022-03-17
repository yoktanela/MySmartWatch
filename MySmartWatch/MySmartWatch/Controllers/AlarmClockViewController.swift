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
    
    var alarmTableView: UITableView = {
        var tableView = UITableView()
        tableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        return tableView
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
        self.view.addSubview(alarmTableView)
        alarmTableView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = self.alarmTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0)
        let bottomConstraint = self.alarmTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30.0)
        let leftConstraint = self.alarmTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0)
        let rightConstraint = self.alarmTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0)
        self.view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        
        alarmTableView.register(AlarmViewCell.self, forCellReuseIdentifier: "alarmViewCell")
        alarmTableView.separatorStyle = .none
    }
    
    func bindUI() {
        
        self.peripheralViewModel
            .alarms
            .observe(on: MainScheduler.instance)
            .bind(to: self.alarmTableView.rx.items) { (tableView, row, element ) in
                let cell = self.alarmTableView.dequeueReusableCell(withIdentifier: "alarmViewCell", for: IndexPath(row: row, section: 0)) as! AlarmViewCell
                cell.customizeCell(alarm: element)
                return cell
            }.disposed(by: disposeBag)
        
        if let rightBarItem = self.navigationItem.rightBarButtonItem {
            self.peripheralViewModel
                .alarms
                .flatMap { alarms -> Observable<Bool> in
                    return .just(alarms.count < self.peripheralViewModel.maxAlarmCount)
                }
                .asDriver(onErrorDriveWith: .just(false))
                .drive(rightBarItem.rx.isEnabled)
                .disposed(by: disposeBag)
        }
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
