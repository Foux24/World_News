//
//  WorldNewsNewsImage.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import UIKit

// MARK: - WorldNewsNewsImage
final class WorldNewsNewsImage: UIView {

    /// UIImage
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    /// UIImageView
    private(set) lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.backgroundColor = .systemGray4
        return image
    }()
    
    /// View
    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 3.0
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    
    /// Инициализтор
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImage()
        self.setupContraints()
    }

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
    }
}

// MARK: - Private
private extension WorldNewsNewsImage {
    
    /// Настроим UI
    func setupImage() {
        self.addSubview(containerView)
        containerView.addSubview(imageView)
        imageView.addSubview(addViewGradient())
    }
    
    /// Настройка констрейнтов
    func setupContraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    /// Градиент Вью на Картинку новости
    func addViewGradient() -> UIView {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 350))
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let topColor: CGColor = UIColor.clear.cgColor
        let bottomColor: CGColor = UIColor.black.cgColor
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.alpha = 1
        return view
    }
}
