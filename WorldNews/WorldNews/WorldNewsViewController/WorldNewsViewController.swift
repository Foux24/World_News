//
//  WorldNewsViewController.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import UIKit
import RealmSwift

// MARK: - WorldNewsViewController
final class WorldNewsViewController: UIViewController {
        
    /// ссылка для работы с обьектами реалма
    lazy var realm = RealmManager.shared
    
    /// Выдернем новости из БД
    var newsRealm: Results<NewsRealm>? {
        realm?.getObject(type: NewsRealm.self)
    }

    /// NotificationToken
	private var token: NotificationToken?
    
    /// Новости в словаре
    var news = Dictionary<String,[Article]>() {
        didSet {
            worldNewsView.tableView.reloadData()
        }
    }
    
    /// Новости в словаре
    var newsFilter = Dictionary<String,[Article]>() {
        didSet {
            worldNewsView.tableView.reloadData()
        }
    }
    
    /// Категории
    var arrayCotegoryNews = [String]()
    
    /// Вью Модель
    var viewModel: WorldNewsViewModelOutput
    
    /// Инициализтор
    init(viewModel: WorldNewsViewModelOutput) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Вью
    private var worldNewsView: WorldNewsView {
        return self.view as! WorldNewsView
    }
    
    //MARK: - Lify Cycle
    override func loadView() {
        super.loadView()
        self.view = WorldNewsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadNews()
        setupTableView()
        setupNaviController()
        createNotificationToken()
    }
}

// MARK: - Extension Data Source
extension WorldNewsViewController: UITableViewDataSource {
    
    /// Кол-во Секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsFilter.count
    }
    
    /// Кол-во строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.defaultCountRow
    }
    
    /// Конфигуратор данными для ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worldNewsView.tableView.dequeueReusableCell(forIndexPath: indexPath) as WorldNewsTableViewCell
        let news = news[arrayCotegoryNews[indexPath.section]]
        cell.configurationCell(news: news ?? [], categoryNews: arrayCotegoryNews[indexPath.section])
        return cell
    }
}

extension WorldNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.worldNewsView.tableView.deselectRow(at: indexPath, animated: false)
    }
}
// MARK: - Private
private extension WorldNewsViewController {
    
    /// Настроим TableView
    func setupTableView() {
        worldNewsView.tableView.registerCell(WorldNewsTableViewCell.self)
        worldNewsView.tableView.dataSource = self
        worldNewsView.searchBar.delegate = self
    }
    
    /// Title для нави
    func setupNaviController() {
        self.navigationItem.title = "Новости"
    }

    /// NotificationToken Realm DB
	func createNotificationToken() {
		token = newsRealm?.observe { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .initial(let newsData):
				print("\(newsData.count) news")
			case .update(_ ,
						 deletions: let deletions,
						 insertions: let insertions ,
						 modifications: let modifications):

				let deletionsIndexPath = deletions.map { IndexPath(row: $0, section: $0) }
                let insertionsIndexPath = insertions.map { IndexPath(row: $0, section: $0) }
				let modificationsIndexPath = modifications.map { IndexPath(row: $0, section: $0) }

                self.viewModel.getDictionaryNews(objects: self.newsRealm!)
                
                if self.news.count == self.newsRealm?.count {
                    
                    DispatchQueue.main.async {
                        
                        self.worldNewsView.tableView.beginUpdates()

                        self.worldNewsView.tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
                        
                        self.worldNewsView.tableView.insertRows(at: insertionsIndexPath, with: .automatic) // <- ошибка при попытке вставить строку
                        
                        self.worldNewsView.tableView.reloadRows(at: modificationsIndexPath, with: .automatic)

                        self.worldNewsView.tableView.endUpdates()
                    }
                }
			case .error(let error):
				print("\(error)")
			}
		}
	}

}

// MARK: - SearchBarDelegate
extension WorldNewsViewController: UISearchBarDelegate {

    /// Настроим логику SearchBar-а
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.serachBarFiltered(searchText: searchText, dictionaryNews: news)
		DispatchQueue.main.async {
			self.worldNewsView.tableView.reloadData()
		}
    }
}

// MARK: - Реализация протокола
extension WorldNewsViewController: WorldNewsViewModelInput {}
