//
//  WorldNewsCollectionViewCell.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import UIKit

final class WorldNewsCollectionViewCell: UICollectionViewCell {
    
    /// Ключ для регистрации ячкйки
    static let reuseID = String(describing: WorldNewsCollectionViewCell.self)

    /// UIImage
    private(set) lazy var photoView: WorldNewsNewsImage = {
        var image = WorldNewsNewsImage()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    /// Тайтл новости
    private(set) lazy var titleNewsLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    /// Конфигурирует ячейку
    func configureImage(with image: UIImage?, textTitle: String) {
        guard let imageDefault = UIImage(systemName: "newspaper") else { return }
        photoView.image = image ?? imageDefault
        titleNewsLable.text = textTitle
        setupUIImage()
        setupConstraints()
    }
    
}

// MARK: - Private
private extension WorldNewsCollectionViewCell {
    
    /// Метод  добавления UIImage в ячейку
    func setupUIImage() {
        contentView.addSubview(photoView)
        photoView.addSubview(titleNewsLable)
    }
    
    /// Метод установки констрейнтов
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleNewsLable.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: 30),
            titleNewsLable.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: -15),
            titleNewsLable.bottomAnchor.constraint(equalTo: photoView.bottomAnchor, constant: -15)
        ])
    }
}
