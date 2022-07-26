//
//  SearchResultViewController.swift
//  Ninano
//
//  Created by 이가은 on 2022/07/15.
//

import UIKit

final class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var eventFilterButton: EventFilterButton!
    @IBOutlet private var performanceCollectionView: UICollectionView!
    @IBOutlet private weak var keywordNotification: UIButton!
    @IBOutlet private weak var keywordAddedNotification: UIStackView!
    @IBOutlet private weak var eventCollectionView: UICollectionView!
    private var isNotificationButtonSelected = false
    
    fileprivate let systemImagesTemp = ["performanceImage1", "performanceImage2", "performanceImage1", "performanceImage2", "performanceImage1", "performanceImage2", "performanceImage1", "performanceImage2", "performanceImage1", "performanceImage2", "performanceImage1", "performanceImage2", "performanceImage1", "performanceImage2", "performanceImage1", "performanceImage2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keywordAddedNotification.isHidden = true
        // collectionView에 대한 설정
        performanceCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        performanceCollectionView.dataSource = self
        performanceCollectionView.delegate = self
        eventFilterButton.datedeliveryDelegate = self
        
        let uiImage = UIImage(systemName: "chevron.left")
        let undo = UIBarButtonItem(image: uiImage, style: .plain, target: self, action: #selector(didTapBackButton))
        self.navigationItem.leftBarButtonItem = undo
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 320, height: 0))
        searchBar.placeholder = "Search User"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        keywordNotification.layer.cornerRadius = 15
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func keywordNotificationButton(_ sender: UIButton) {
    }
    
    @IBAction private func notificationSettingsButton(_ sender: UIButton) {
        // TODO: 키워드 값 넣는 로직
        if isNotificationButtonSelected == false {
            keywordAddedNotification.isHidden = false
            keywordAddedNotification.layer.cornerRadius = 15
            sender.isHidden = true
            
            isNotificationButtonSelected = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 1) {
                    self.keywordAddedNotification.isHidden = true
                }
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        let numberOfCells: CGFloat = 3
        let width = collectionView.frame.size.width - (flowLayout.minimumInteritemSpacing * (numberOfCells-1))
        return CGSize(width: width/(numberOfCells), height: width/(numberOfCells))
    }
}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.systemImagesTemp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: PerformancesViewCell.self)
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PerformancesViewCell {
            cell.imageName = self.systemImagesTemp[indexPath.item]
            cell.contentView.layer.cornerRadius = 8
            return cell
        }
        
        return PerformancesViewCell()
    }
}

protocol DateDelivable: AnyObject {
    func addDate(date: Date)
}

protocol FilterButtonClickable: AnyObject {
    func openLocalActionSheet(actionSheet: UIAlertController)
    func openCaledarSearchResultView()
}

extension SearchResultViewController: DateDelivable, FilterButtonClickable {
    
    func addDate(date: Date) {
        let koreanDate = date.convertDateToKoreanDate(.koreanDate)
        let button: UIButton = eventFilterButton.dateFilterButton
        button.setTitle(koreanDate, for: .normal)
        button.configuration?.baseBackgroundColor = UIColor(hex: "D5DCF8")
        button.configuration?.cornerStyle = .capsule
    }
    
    func openLocalActionSheet(actionSheet: UIAlertController) {
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openCaledarSearchResultView() {
        guard let calenderModal = UIStoryboard(name: "CalenderModal", bundle: .main).instantiateViewController(withIdentifier: "CalenderModalViewController") as? CalenderModalViewController else { return }
        calenderModal.datedeliveryDelegate = self
        self.present(calenderModal, animated: true, completion: nil)
    }
}
