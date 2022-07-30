//
//  SearchViewController.swift
//  Ninano
//
//  Created by Eunbee Kang on 2022/07/16.
//

import UIKit

class SearchViewController: UIViewController {
    private var titleFont = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2, weight: .bold)]
    private var categoryConfig = UIButton.Configuration.plain()
    private var categoryFont = UIFont.preferredFont(forTextStyle: .subheadline, weight: .semibold)

    private enum Category: String, CaseIterable {
        case recommended = "니나노의 추천 공연"
        case thisMonth = "이번 달 예정 공연"
        case free = "무료 공연"
        case liked = "내가 구독한 공연"
        
        static let allValues = [recommended, thisMonth, free, liked]
    }
    
    private var articles: APIResponse?
    private var eventList = [Event]()
    
    @IBOutlet private var categoryTableView: UITableView!
    
    @IBAction func didTouchSearchButton(_ sender: UIButton) {
        guard let searchResultView = UIStoryboard(name: "SearchResult", bundle: .main).instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController else { return }
        searchResultView.eventList = eventList
        // TODO: 내가 좋아할 만한 공연 화면으로 넘어가면 searchResult, 검색 화면으로 넘어가면 .searchCatagory(navigationTitle: String)
        searchResultView.viewCatagory = .searchResult
        self.navigationController?.pushViewController(searchResultView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.largeTitleTextAttributes = titleFont
        fetchTopStories()
        configNavigationTitle()
        // Do any additional setup after loading the view.
    }
    private func configNavigationTitle() {
        let calendarTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 270, height: 20))
        calendarTitle.textAlignment = .left
        calendarTitle.font = UIFont.boldSystemFont(ofSize: 25)
        calendarTitle.text = "공연 추천"
        self.navigationItem.titleView = calendarTitle
            
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
        cell.categoryName.titleLabel?.adjustsFontForContentSizeCategory = true
        cell.categoryChevron.titleLabel?.font = categoryFont
        cell.eventList = eventList
        return cell
    }
    
    func fetchTopStories() {
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                // MARK: viewModels를 가져오는데 시간이 걸리므로 가져온 후 CategoryCell에서 eventCollectionView를 reload 함.
                self?.eventList = articles.culturalEventInfo.row.compactMap({
                    Event(
                        title: String($0.title),
                        posterURL: URL(string: $0.mainImg ?? ""),
                        place: String($0.place),
                        area: String($0.guname),
                        period: String($0.date),
                        URL: String($0.orgLink ?? ""),
                        actor: String($0.player),
                        info: String($0.program),
                        price: String($0.useFee)
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
