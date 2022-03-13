//
//  WorldNewsView.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import UIKit

// MARK: - View Стартового экрана
final class WorldNewsView: UIView {
    
    /// Поиск новостей/ Фильтр
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск Новостей"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    /// UITableView
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 350
        return tableView
    }()
    
    /// Инициализтор
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupConstreints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.setupConstreints()
    }
}

//MARK: - Private
private extension WorldNewsView {
    
    /// Установка UI на View
    func setupUI() {
        self.addSubview(searchBar)
        self.addSubview(tableView)
        self.backgroundColor = .systemGray6
    }
    
    /// Установка констрейнтов
    func setupConstreints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}