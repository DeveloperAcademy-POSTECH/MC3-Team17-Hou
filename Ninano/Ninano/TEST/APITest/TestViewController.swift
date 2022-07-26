//
//  TestViewController.swift
//  Ninano
//
//  Created by Yoonjae on 2022/07/24.
//

import UIKit
import SafariServices

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()

    private let searchVC = UISearchController(searchResultsController: nil)

    private var articles: APIResponse?
    private var viewModels = [NewsTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground

        fetchTopStories()
        createSearchBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }

    private func fetchTopStories() {
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                    self?.viewModels = articles.culturalEventInfo.row.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        imageURL: URL(string: $0.mainImg ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // Table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles?.culturalEventInfo.row[indexPath.row]

        guard let url = URL(string: article?.orgLink ?? "") else {
            return
        }

        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}

