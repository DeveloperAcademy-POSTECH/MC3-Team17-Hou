//
//  CalenderViewController.swift
//  Ninano
//
//  Created by 이가은 on 2022/07/19.
//

import UIKit

final class CalenderModalViewController: UIViewController {
    
    @IBOutlet weak private var scheduleButton: UIButton!
    @IBOutlet weak private var calendarFrame: UIView!
    @IBOutlet weak private var dataPicker: UIDatePicker!
    
    weak var datedeliveryDelegate: DateDelivable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleButton.layer.cornerRadius = 10
        calendarFrame.layer.cornerRadius = 10
    }
    
    @IBAction private func clickedScheduleButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        datedeliveryDelegate?.addDate(date: dataPicker.date)
    }
    
    @IBAction private func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
