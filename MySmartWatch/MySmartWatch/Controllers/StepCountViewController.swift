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
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        return indicator
    }()
    
    var stepCountView: CounterDisplayView = {
        let view = CounterDisplayView(imageName: "footImg")
        return view
    }()
    
    var calorieCountView: CounterDisplayView = {
        let view = CounterDisplayView(imageName: "calorieImg")
        return view
    }()
    
    var distanceCountView: CounterDisplayView = {
        let view = CounterDisplayView(imageName: "distanceImg")
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
        
        setSubviews()
        bindUI()
    }
    
    func setSubviews() {
        
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let centerY = activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        self.view.addConstraints([centerX, centerY])
        
        self.view.addSubview(stepCountView)
        stepCountView.translatesAutoresizingMaskIntoConstraints = false
        let stepTopConstariant = stepCountView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50.0)
        let stepLeftConstraint = stepCountView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        let stepRightConstraint = stepCountView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        self.view.addConstraints([stepTopConstariant, stepLeftConstraint, stepRightConstraint])
        
        self.view.addSubview(calorieCountView)
        calorieCountView.translatesAutoresizingMaskIntoConstraints = false
        let calorieTopConstariant = calorieCountView.topAnchor.constraint(equalTo: stepCountView.bottomAnchor, constant: 40.0)
        let calorieLeftConstraint = calorieCountView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        let calorieRightConstraint = calorieCountView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        self.view.addConstraints([calorieTopConstariant, calorieLeftConstraint, calorieRightConstraint])
        
        self.view.addSubview(distanceCountView)
        distanceCountView.translatesAutoresizingMaskIntoConstraints = false
        let distanceTopConstariant = distanceCountView.topAnchor.constraint(equalTo: calorieCountView.bottomAnchor, constant: 50.0)
        let distanceLeftConstraint = distanceCountView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        let distanceRightConstraint = distanceCountView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        self.view.addConstraints([distanceTopConstariant, distanceLeftConstraint, distanceRightConstraint])
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
            }.startWith("-")
            .asDriver(onErrorJustReturn: "-")
            .drive(stepCountView.rx.value)
            .disposed(by: disposeBag)
        
        peripheralViewModel?.calorie
            .compactMap{$0}
            .flatMap{ cal -> Observable<String> in
                return .just("\(String(cal)) cal")
            }.startWith("-")
            .asDriver(onErrorJustReturn: "-")
            .drive(calorieCountView.rx.value)
            .disposed(by: disposeBag)
        
        peripheralViewModel?.distance
            .compactMap{$0}
            .flatMap{ distance -> Observable<String> in
                return .just("\(String(distance)) km")
            }.startWith("-")
            .asDriver(onErrorJustReturn: "-")
            .drive(distanceCountView.rx.value)
            .disposed(by: disposeBag)
    }
}
