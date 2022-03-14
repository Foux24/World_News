//
//  WorldNewsTableViewCell.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import UIKit

// MARK: - LikedPhotoTableViewCell
final class WorldNewsTableViewCell: UITableViewCell {
    
    /// Ключ для регистрации ячкйки
    static let reuseID = String(describing: WorldNewsTableViewCell.self)

    /// Хэш изображений
    private var fileManager: HashImage?
    
    /// Новости
    private var news = [Article]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// Лейбл с категорией
    private(set) lazy var categoryNewsLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// UICollectionView
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    /// Конфигуратор для ячейки
    func configurationCell(news: [Article], categoryNews: String) {
        self.fileManager = HashImage(container: collectionView)
        categoryNewsLable.text = categoryNews
        self.news = news.sorted { $0.publishedAt ?? "" > $1.publishedAt ?? "" }
        setupUI()
        setupConstraints()
        setupCollectionView()
    }
}

//MARK: - UITableViewDataSource
extension WorldNewsTableViewCell: UICollectionViewDataSource {
    
    /// Кол-во итемов в секции коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.suffix(20).count
    }
    
    /// Данные для итема
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorldNewsCollectionViewCell
        let image = fileManager?.photo(atIndexPath: indexPath, byUrl: news[indexPath.row].urlToImage ?? "")
        cell.configureImage(with: image, textTitle: news[indexPath.row].title ?? "")
        return cell
    }
}

//MARK: - UITableViewDelegate
extension WorldNewsTableViewCell: UICollectionViewDelegate {
    
    /// Действие при выделении итема
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: news[indexPath.row].url ?? "")!
        if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [ : ] , completionHandler: nil)
        } else {
        UIApplication.shared.openURL(url)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Private
private extension WorldNewsTableViewCell {
    
    /// Метод  добавления UIImage в ячейку
    func setupUI() {
        self.backgroundColor = .clear
        contentView.addSubview(categoryNewsLable)
        contentView.addSubview(collectionView)
    }
    
    /// Настройки коллекции
    func setupCollectionView() {
        collectionView.registerCell(WorldNewsCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
    }
    
    /// Метод установки констрейнтов
    func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryNewsLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            categoryNewsLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            categoryNewsLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            collectionView.topAnchor.constraint(equalTo: categoryNewsLable.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    /// Настроим композицию элементов в коллекции
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(0.8))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
