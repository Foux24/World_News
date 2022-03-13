//
//  News.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import Foundation
import RealmSwift

// MARK: - NewsRealm
class NewsRealm: Object {

    /// Категории новостей
    @objc dynamic var category: String = ""

    /// Список новостей
    var listNews = List<Article>()
    
    override static func primaryKey() -> String? {
        "category"
    }
    
    override static func indexedProperties() -> [String] {
        ["category"]
    }
}

// MARK: - News
struct News: Codable {
    let articles: [Article]
}

// MARK: - Article
class Article: Object, Codable {
    /// Тайтл новости
    @objc dynamic var title: String? = nil
    
    /// УРЛ
    @objc dynamic var url: String? = nil
    
    /// УРЛ картинки
    @objc dynamic var urlToImage: String? = nil
    
    /// Дата публикации
    @objc dynamic var publishedAt: String? = nil

    enum CodingKeys: String, CodingKey {
        case title, url, urlToImage, publishedAt
    }
    
    let owners = LinkingObjects(fromType: NewsRealm.self, property: "listNews")
    
    override static func primaryKey() -> String? {
        "url"
    }
    
}


