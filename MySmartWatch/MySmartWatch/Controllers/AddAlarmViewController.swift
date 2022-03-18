//
//  AddAlarmViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 17.03.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AddAlarmViewController: UIViewController {
    
    private var settingsViewModel: SettingsViewModel?
    private var disposeBag = DisposeBag()
    
    var hourPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    var minutePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    var daysTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var selectedHour = BehaviorRelay<Int>(value: 0)
    var selectedMinute = BehaviorRelay<Int>(value: 0)
    var repeatDays = BehaviorRelay<[Day]>(value: [])
    
    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemBackground
        self.navigationItem.title = "Add Alarm"
        self.navigationItem
            .setLeftBarButton(UIBarButtonItem(title: "Cancel",
                                              style: .plain,
                                              target: self,
                                              action: #selector(back(sender:))),
                              animated: true)
        
        self.navigationItem
            .setRightBarButton(UIBarButtonItem(title: "Save",
                                               style: .plain,
                                               target: self,
                                               action: #selector(save(sender:))),
                               animated: true)
        
        self.setSubViews()
        self.bindUI()
    }
    
    func setSubViews() {
        self.view.addSubview(hourPicker)
        hourPicker.translatesAutoresizingMaskIntoConstraints = false
        let hourTopConstraint = hourPicker.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0.0)
        let hourLeftConstraint = hourPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        let hourRightConstraint = hourPicker.rightAnchor.constraint(equalTo: self.view.centerXAnchor)
        let hourHeightConstraint = hourPicker.heightAnchor.constraint(equalToConstant: 200.0)
        self.view.addConstraints([hourTopConstraint, hourLeftConstraint, hourRightConstraint, hourHeightConstraint])
        
        self.view.addSubview(minutePicker)
        minutePicker.translatesAutoresizingMaskIntoConstraints = false
        let minTopConstraint = minutePicker.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0.0)
        let minLeftConstraint = minutePicker.leftAnchor.constraint(equalTo: self.view.centerXAnchor)
        let minRightConstraint = minutePicker.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        let minHeightConstraint = minutePicker.heightAnchor.constraint(equalToConstant: 200.0)
        self.view.addConstraints([minTopConstraint, minLeftConstraint, minRightConstraint, minHeightConstraint])
        
        self.view.addSubview(daysTableView)
        daysTableView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = self.daysTableView.topAnchor.constraint(equalTo: self.hourPicker.bottomAnchor, constant: 10.0)
        let bottomConstraint = self.daysTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30.0)
        let leftConstraint = self.daysTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0)
        let rightConstraint = self.daysTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0)
        self.view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        
        daysTableView.register(DayViewCell.self, forCellReuseIdentifier: "dayViewCell")
        daysTableView.separatorStyle = .none

    }
    
    func bindUI() {
        Observable.from(optional: (0..<24).makeIterator()).bind(to: hourPicker.rx.itemTitles) { (row, element) in
            return String(format: "%02d", element)
        }
        .disposed(by: disposeBag)
        hourPicker.rx.itemSelected
            .map {$0.row}
            .asDriver(onErrorDriveWith: .just(0))
            .drive(selectedHour)
            .disposed(by: disposeBag)
        
        Observable.from(optional: (0..<60).makeIterator()).bind(to: minutePicker.rx.itemTitles) { (row, element) in
            return String(format: "%02d", element)
        }
        .disposed(by: disposeBag)
        minutePicker.rx.itemSelected
            .map {$0.row}
            .asDriver(onErrorDriveWith: .just(0))
            .drive(selectedMinute)
            .disposed(by: disposeBag)
        
        Observable.from(optional: Day.getDays())
            .observe(on: MainScheduler.instance)
            .bind(to: self.daysTableView.rx.items) { (tableView, row, element ) in
                let cell = self.daysTableView.dequeueReusableCell(withIdentifier: "dayViewCell", for: IndexPath(row: row, section: 0)) as! DayViewCell
                
                cell.customizeCell(dayName: element.getName())
                return cell
            }.disposed(by: disposeBag)
        
        daysTableView.rx
            .modelSelected(Day.self)
            .subscribe(onNext: { day in
                if self.repeatDays.value.contains(where: {$0 == day}) {
                    self.repeatDays.remove(element: day)
                } else {
                    self.repeatDays.add(element: day)
                }
            })
            .disposed(by: disposeBag)
        
        daysTableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              if let cell = self?.daysTableView.cellForRow(at: indexPath) as? DayViewCell {
                  cell.picked = !cell.picked
              }
          }).disposed(by: disposeBag)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save(sender: UIBarButtonItem) {
        self.settingsViewModel?.addAlarm(hour: selectedHour.value, minute: selectedMinute.value, repeatDays: self.repeatDays.value)
        self.dismiss(animated: true, completion: nil)
    }
}
