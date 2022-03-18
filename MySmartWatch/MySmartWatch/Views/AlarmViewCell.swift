//
//  AlarmViewCell.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 17.03.2022.
//

import Foundation
import UIKit

class AlarmViewCell: UITableViewCell {
    
    public let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    public let alarmTimeLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public let repeatDaysLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .light)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1)
        let bottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        let leftAnchor = containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        let rightAnchor = containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        self.addConstraints([topAnchor, bottomAnchor, leftAnchor, rightAnchor])
        
        // Alarm time label constraints
        containerView.addSubview(alarmTimeLabel)
        alarmTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        let alarmTopAnchor = alarmTimeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0)
        let alarmLeftAnchor = alarmTimeLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16.0)
        let alarmRightAnchor = alarmTimeLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5.0)
        containerView.addConstraints([alarmTopAnchor, alarmLeftAnchor, alarmRightAnchor])
        
        // repeat days label constraints
        containerView.addSubview(repeatDaysLabel)
        repeatDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        let repeatTopAnchor = repeatDaysLabel.topAnchor.constraint(equalTo: alarmTimeLabel.bottomAnchor, constant: 5)
        let repeatLeftAnchor = repeatDaysLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16)
        let repeatRightAnchor = repeatDaysLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5)
        let repeatBottomAnchor = repeatDaysLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        containerView.addConstraints([repeatTopAnchor, repeatLeftAnchor, repeatRightAnchor, repeatBottomAnchor])
        
        self.addBottomSeperator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customizeCell(alarm: Alarm) {
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.alarmTimeLabel.text = alarm.getAlarmString()
        self.repeatDaysLabel.text = alarm.getRepeatDaysString()
    }
}
