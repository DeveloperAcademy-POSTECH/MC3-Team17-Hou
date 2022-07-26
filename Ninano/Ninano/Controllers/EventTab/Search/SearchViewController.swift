//
//  SearchViewController.swift
//  Ninano
//
//  Created by Eunbee Kang on 2022/07/16.
//

import UIKit

class SearchViewController: UIViewController {
    private var categoryConfig = UIButton.Configuration.plain()
    private var categoryFont = UIFont.boldSystemFont(ofSize: 15)

    private enum Category: String, CaseIterable {
        case recommended = "니나노의 추천 공연"
        case thisMonth = "이번 달 예정 공연"
        case free = "무료 공연"
        case liked = "내가 구독한 공연"
        
        static let allValues = [recommended, thisMonth, free, liked]
    }
    
    private var articles: APIResponse?
    private var viewModels = [SearchEventCellViewModel]()
    
    @IBAction func detailButton(_ sender: Any) {
    }
    
    @IBOutlet private var categoryTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopStories()
        // Do any additional setup after loading the view.
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        categoryConfig.title = Category.allValues[indexPath.row].rawValue
        cell.categoryName.configuration = categoryConfig
        cell.categoryName.titleLabel?.font = categoryFont
        cell.categoryChevron.titleLabel?.font = categoryFont
        cell.viewModels = viewModels
        return cell
    }
    
    func fetchTopStories() {
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
                case .success(let articles):
                    self?.articles = articles
                    // MARK: viewModels를 가져오는데 시간이 걸리므로 가져온 후 CategoryCell에서 eventCollectionView를 reload 함.
                    self?.viewModels = articles.culturalEventInfo.row.compactMap({
                        SearchEventCellViewModel(
                            imageURL: URL(string: $0.mainImg ?? "")
                        )
                    })
                    DispatchQueue.main.async {
                        self?.categoryTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}
