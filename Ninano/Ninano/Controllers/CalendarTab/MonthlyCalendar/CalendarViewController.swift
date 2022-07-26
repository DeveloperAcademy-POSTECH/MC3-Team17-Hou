//
//  CalendarViewController.swift
//  Ninano
//
//  Created by Yoonjae on 2022/07/17.
//

import UIKit
import Foundation

class CalendarViewController: UIViewController {
    
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var weeks: [String] = ["Sun", "Mon", "Tus", "Wed", "Thu", "Fri", "Sat"]
    var days: [String] = []
    // 해달 월에 몇일까지 있는지 카운트
    var daysCountInMonth = 0
    // 시작일
    var weekdayAdding = 0
    
    //  캘린더 이미지화면 연결
    @IBOutlet weak var image: UIImageView!
    
    // 달력을 표시할 콜렉션 뷰 연결
    @IBOutlet weak var calendarView: UICollectionView!
    // 달력에서 글씨를 포시할 라벨 연결
    @IBOutlet weak var yearMonthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    //  알림 아이콘 연결
    @IBAction func alarm(_ sender: Any) {
        
    }
    
    @IBAction func didTappedBackButton(_ sender: Any) {
        components.month = (components.month ?? 0) - 1
        self.calculation()
        self.calendarView?.reloadData()
        
    }
    
    @IBAction func didTappedFrontButton(_ sender: Any) {
        components.month = (components.month ?? 0) + 1
        self.calculation()
        self.calendarView?.reloadData()
    }
    
    // 뷰 초기 설정
    private func initView() {
        self.initCollection()
        dateFormatter.dateFormat = "yyyy年M月"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        self.calculation()
    }
    // CollectionView의 초기 설정
    private func initCollection() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
        self.calendarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapPressGesture)))
    }
    
    private func calculation() {
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth ?? Date() )
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth ?? Date())!.count
        weekdayAdding = 2 - firstWeekday
        self.yearMonthLabel.text = dateFormatter.string(from: firstDayOfMonth!)
        self.days.removeAll()
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
    
    @objc
    func handleTapPressGesture() {
        print("달력")
    }
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        default:
            return self.days.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCollectionViewCell

        switch indexPath.section {
        case 0:
            cell?.dateLabel.text = weeks[indexPath.row]
        default:
            cell?.dateLabel.text = days[indexPath.row]
        }

        if indexPath.row % 7 == 0 {
            cell?.dateLabel.textColor = UIColor.black
        } else if indexPath.row % 7 == 6 {
            cell?.dateLabel.textColor = UIColor.black
        } else {
            cell?.dateLabel.textColor = UIColor.black
        }
        
        return cell!
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
            let cellSize: CGFloat = myBoundSize / 9
            return CGSize(width: cellSize, height: cellSize)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
}
