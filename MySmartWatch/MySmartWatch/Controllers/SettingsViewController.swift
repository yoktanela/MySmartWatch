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
    }
    
}
