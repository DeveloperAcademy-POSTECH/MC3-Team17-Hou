//
//  ModalCalendarViewController.swift
//  Ninano
//
//  Created by 임영후 on 2022/07/19.
//

import UIKit

class ModalCalendarViewController: UIViewController {

    @IBOutlet weak var calendarFrame: UIView!
    @IBOutlet weak var addSchedule: UIButton!
    @IBAction func cancleBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
//        self.dismiss(animated: true, completion: nil)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarFrame.layer.cornerRadius = 10
        addSchedule.layer.cornerRadius = 10
    }
}
