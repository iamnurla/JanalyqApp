//
//  ViewController.swift
//  Janalyq App
//
//  Created by Nurlybek Amanzhol on 26.05.2021.
//

import UIKit
import SafariServices

class MainVC: UIViewController {

    //MARK: - Properties
    
    private let tableView =  UITableView()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var viewModels = [NewsCellViewModel]()
    
    private var articles = [Article]()

    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    
    //MARK: - Helpers
    

    func configureUI() {
        configureTableView()
        configureSearchController()
        navigationItem.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchNews()
    }
    

    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier )
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
    }
    
    
    
    //MARK: - API Helper
    
    func fetchNews() {
        APIManager.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsCellViewModel(
                        title: $0.title,
                        publishedAt: $0.publishedAt ?? "",
                        imageURL: URL(string: $0.urlToImage ?? "")
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
    
}


    //MARK: - UITableViewDataSource

extension MainVC: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {fatalError()}
        cell.configure(with: viewModels[indexPath.row])
        return cell
        
    }
}



    //MARK: - UITableViewDelegate
extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


    //MARK: - UISearchBarDelegate

extension MainVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text , !text.isEmpty else {
            return
        }
        APIManager.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsCellViewModel(
                        title: $0.title,
                        publishedAt: $0.publishedAt ?? "",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchController.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
            print(error)
            }
        }
    }
}
    
        
