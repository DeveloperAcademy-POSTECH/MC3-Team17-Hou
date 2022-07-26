//
//  SetKeywordViewController.swift
//  Ninano
//
//  Created by 임영후 on 2022/07/19.
//

import UIKit

class SetKeywordViewController: UIViewController {

    @IBOutlet weak var addKeywordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeywordBtn.layer.cornerRadius = 5
    }
}
