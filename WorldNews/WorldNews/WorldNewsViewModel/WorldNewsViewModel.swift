//
//  WorldNewsViewModel.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import UIKit
import RealmSwift

/// Протокол для данных новостей
protocol WorldNewsViewModelInput {
    var newsFilter: Dictionary<String,[Article]> { get set }
    var news: Dictionary<String,[Article]> { get set }
    var arrayCotegoryNews: [String] { get set }
    
}

/// Протокол для обращения к ViewModel
protocol WorldNewsViewModelOutput {
    var defaultCountRow: Int { get set }
    func loadNews() -> Void
    func getDictionaryNews(objects: Results<NewsRealm>) -> Void
    func serachBarFiltered(searchText: String, dictionaryNews: Dictionary<String,[Article]>) -> Void
}

// MARK: - WorldNewsViewModel
final class WorldNewsViewModel: WorldNewsViewModelOutput {
    
    /// Контроллер
    weak var controller: (UIViewController & WorldNewsViewModelInput)?
    
    /// Запросы в сеть
    var requestService = RequestServer()
    
    /// Дефолт кол-во строк в таблице
    var defaultCountRow: Int = 1
    
    /// Load News
    func loadNews() -> Void {
        loadBusinessNews()
        loadEntertainmentNews()
        loadGeneralNews()
        loadSprotNews()
        loadTechnologyNews()
    }
    
    /// Load Business News
    func loadBusinessNews() {
        requestService.loadBusinessNews { result in
            switch result {
            case .success(_):
                print("Запрос на бизнес новости выполнен")
            case .failure(let error):
                print("Бизнес - \(error)")
            }
        }
    }
    
    /// Load Entertainment News
    func loadEntertainmentNews() {
        requestService.loadEntertainmentNews { result in
            switch result {
            case .success(_):
                print("Запрос на развлекательные новости выполнен")
            case .failure(let error):
                print("Развлeчения - \(error)")
            }
        }
    }
    
    /// Load General News
    func loadGeneralNews() {
        requestService.loadGeneralNews { result in
            switch result {
            case .success(_):
                print("Запрос на главные новости выполнен")
            case .failure(let error):
                print("Главные - \(error)")
            }
        }
    }
    
    /// Load Sport News
    func loadSprotNews() {
        requestService.loadSpotsNews { result in
            switch result {
            case .success(_):
                print("Запрос на новости спорта выполнен")
            case .failure(let error):
                print("Спорт - \(error)")
            }
        }
    }
    
    /// Load Technology News
    func loadTechnologyNews() {
        requestService.loadTechnologyNews { result in
            switch result {
            case .success(_):
                print("Запрос на новости технологий выполнен")
            case .failure(let error):
                print("Технологии - \(error)")
            }
        }
    }
    
    /// Конвертируем обьект реалма в словарь
    func convertRealmList(object: NewsRealm) -> Dictionary<String,[Article]> {
        var dic = Dictionary<String,[Article]>()
        dic[object.category] = object.listNews.map { $0 }
        return dic
    }
    
    /// Возвращаем полный словарь с новостями
    func getDictionaryNews(objects: Results<NewsRealm>) -> Void {
        var dictionary = Dictionary<String,[Article]>()
        for object in objects {
            let news = convertRealmList(object: object)
            let key = news.keys.first ?? ""
            let value = news.values.first
            dictionary[key] = value
        }
		DispatchQueue.main.async {
			self.controller?.news = dictionary
			self.controller?.newsFilter = dictionary
			self.controller?.arrayCotegoryNews = dictionary.keys.sorted()
		}
    }
    
    /// Фильтрация друзей в SearchBar
    func serachBarFiltered(searchText: String, dictionaryNews: Dictionary<String,[Article]>) -> Void {
        self.controller?.newsFilter = [:]
        if searchText == "" {
            controller?.newsFilter = dictionaryNews
        }
    }
}
