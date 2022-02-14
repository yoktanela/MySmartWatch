//
//  ScanViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 2.02.2022.
//

import Foundation
import UIKit
import CoreBluetooth
import RxSwift
import RxCocoa

class ScanViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private var scannerViewModel: ScannerViewModel!
    
    var peripheralTableView: UITableView = {
        var tableView = UITableView()
        tableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        return tableView
    }()
    
    var explanationLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "titleColor")
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .light)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scannerViewModel = ScannerViewModel()

        self.view.backgroundColor = UIColor.systemBackground
        self.setSubviews()
    }
    
    func setSubviews() {
        
        self.navigationItem.title = "Available Devices"

        self.view.addSubview(explanationLabel)
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        let topLblConstariant = explanationLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0)
        let leftLblConstraint = explanationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        let rightLblConstraint = explanationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        self.view.addConstraints([topLblConstariant, leftLblConstraint, rightLblConstraint])
        
        peripheralTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(peripheralTableView)
        let topConstraint = self.peripheralTableView.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 10.0)
        let bottomConstraint = self.peripheralTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30)
        let leftConstraint = self.peripheralTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0)
        let rightConstraint = self.peripheralTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0)
        self.view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        
        peripheralTableView.register(PeripheralViewCell.self, forCellReuseIdentifier: "peripheralViewCell")
        peripheralTableView.separatorStyle = .none
        
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        self.scannerViewModel
            .getPeripherals()
            .observe(on: MainScheduler.instance)
            .bind(to: self.peripheralTableView.rx.items) { (tableView, row, element ) in
                let cell = self.peripheralTableView.dequeueReusableCell(withIdentifier: "peripheralViewCell", for: IndexPath(row : row, section : 0)) as! PeripheralViewCell
                cell.customizeCell(name: element.name, rssi: element.rssi, connectable: element.connectable)
                return cell
            }.disposed(by: disposeBag)
        
        self.scannerViewModel.noDeviceFound
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { noElement in
                if noElement {
                    self.explanationLabel.text = ""
                } else {
                    self.explanationLabel.text = "Select one of the smart watch to connect and monitor your heart rate, steps and sleep quality."
                }
            }).disposed(by: disposeBag)
        
        
        let running = Observable.merge(
            self.scannerViewModel.scanning.asObservable(),
            self.scannerViewModel.getPeripherals().map { _ in false }
        )
        .startWith(true)
        .asDriver(onErrorJustReturn: false)
        
        running
          .drive(activityIndicator.rx.isAnimating)
          .disposed(by: disposeBag)
    }
}
