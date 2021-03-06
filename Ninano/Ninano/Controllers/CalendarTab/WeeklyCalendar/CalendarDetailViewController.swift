//
//  CalendarDetailViewController.swift
//  Ninano
//
//  Created by Eunbee Kang on 2022/07/18.
//

import UIKit

class CalendarDetailViewController: UIViewController {
    private var eventList = EventData().list
    private var event: Event?
    
    private var monthImage: UIImage?
    private var eventPoster: UIImage?
    
    private var weekdays: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    private var dates: [String] = ["17", "18", "19", "20", "21", "22", "23"]
    private var selectedCell: Int?
    
    private var month: String = "7월"
    private var backButton = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
    private let backSymbol = UIImage(systemName: "chevron.left")
    
    private var heartConfig = UIImage.SymbolConfiguration(paletteColors: [.systemRed])
    private let heartSymbol = UIImage(systemName: "heart.fill")
    
    private var calConfig = UIImage.SymbolConfiguration(paletteColors: [.white])
    private let calSymbol = UIImage(systemName: "calendar.badge.clock")
    
    private let calInset: CGFloat = 15.0
    
    @IBOutlet weak var monthBackButton: UIButton!
    @IBOutlet weak var monthImageView: UIImageView!
    @IBOutlet weak var topBackground: UIView!
    @IBOutlet weak var weeklyCalendarView: UICollectionView!
    @IBOutlet weak var dayEventDetailView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButtonConfig()
        monthBackButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        monthBackButton.imageView?.preferredSymbolConfiguration = backButton
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: calInset, bottom: 0, right: calInset)
        weeklyCalendarView.collectionViewLayout = flowLayout
        
        monthImage = UIImage(named: "JulyBG")
        monthImageView.image = monthImage
        topBackground.layer.cornerRadius = 25
        self.dayEventDetailView.backgroundColor = .clear
        setBlurEffect()
    }
    
    func backButtonConfig() {
        monthBackButton.configuration = .plain()
        monthBackButton.configuration?.title = month
        
        monthBackButton.configuration?.image = backSymbol
        monthBackButton.configuration?.imagePlacement = .leading
        monthBackButton.configuration?.imagePadding = 15
        
        monthBackButton.configuration?.baseForegroundColor = .black
        monthBackButton.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        monthImageView.addSubview(visualEffectView)
        visualEffectView.frame = monthImageView.frame
    }
}

extension CalendarDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weeklyCalendarCell", for: indexPath) as? WeeklyCalendarCell else {
            return UICollectionViewCell()
        }
        
        cell.dayHighlight.layer.cornerRadius = 14.5
        cell.dayNameLabel.text = weekdays[indexPath.row]
        cell.dateNumberLabel.text = dates[indexPath.row]
        
        if indexPath.row == selectedCell {
            cell.dayHighlight.alpha = 1.0
            cell.dayNameLabel.textColor = .white
            cell.dateNumberLabel.textColor = .white
        } else {
            cell.dayHighlight.alpha = 0.0
            cell.dayNameLabel.textColor = .black
            cell.dateNumberLabel.textColor = .black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        weeklyCalendarView.reloadData()
        dayEventDetailView.reloadData()
    }
}

extension CalendarDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        flow.minimumInteritemSpacing = 5
        let width = (UIScreen.main.bounds.width - (calInset * 2)) / CGFloat(weekdays.count) - flow.minimumInteritemSpacing
        
        return CGSize(width: width, height: 52)
    }
}

extension CalendarDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayEventDetailCell", for: indexPath) as? DayEventDetailCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        
        let eventData = eventList[indexPath.row]
        
        eventPoster = UIImage(named: "\(eventData.eventPosterName)")
        cell.posterImage.image = eventPoster
        cell.posterImage.layer.cornerRadius = 10

        cell.eventNameLabel.text = eventData.eventName
        cell.eventPlaceLabel.text = eventData.eventPlace
        cell.eventPeriodLabel.text = eventData.eventPeriod
        cell.eventTimeLabel.text = eventData.eventTime
        
        cell.planned.image = calSymbol
        cell.planned.preferredSymbolConfiguration = calConfig
        
        heartConfig = heartConfig.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20)))
        cell.liked.image = heartSymbol
        cell.liked.preferredSymbolConfiguration = heartConfig
        cell.liked.alpha = eventData.isLiked == true ? 1.0 : 0.0
        
        return cell
    }
}
