//
//  RequestServer.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import Foundation
import RealmSwift

// MARK: - Request
/// Тип новостей
fileprivate enum TypeMethods: String {
    case friendsGet = "/v2/top-headlines"
}

/// Типы запросов
fileprivate enum TypeRequest: String {
    case get = "GET"
    case post = "POST"
}

/// Язык новостей
fileprivate enum LanguageNews: String {
    case ru = "ru"
    case en = "eu"
}

/// Категория новостей
fileprivate enum CategoryNews: String {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case healt = "healt"
    case hscience = "hscience"
    case sports = "sports"
    case technology = "technology"
}

/// Api Key
fileprivate enum KeyApi: String {
    case key = "d6b11eeace37459f80e6e6f8f3660a2e"
}

// MARK: - Error
/// Енум с возможными ошибками
enum FriendsError: Error {
    case parseError
    case requestError(Error)
}


// MARK: - Основа для запроса на сервер
final class RequestServer {
    
    /// Определим сессию с конфигуратором
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    /// Протокол запроса
    private let scheme = "https"
    
    /// Адресс сервера
    private let host = "newsapi.org"
    
    /// Декодер
    private let decoder = JSONDecoder()
    
    // MARK: - Запрос на сервер
    /// Бизнесс новости
    func loadBusinessNews(completion: @escaping (Result<[Article], FriendsError>) -> Void) {
            let params: [String: String] = ["pageSize" : "20"]
            
            let url = configureUrl(keyApi: .key,
                                   method: .friendsGet,
                                   country: .ru,
                                   category: .business,
                                   httpMethod: .get,
                                   params: params)
            print(url)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    return completion(.failure(.requestError(error)))
                }
                guard let data = data else { return }
                do {
                    let result = try self.decoder.decode(News.self, from: data).articles
                    
                    let newsRealm = NewsRealm()
                    newsRealm.category = "Бизнес"
                    newsRealm.listNews.append(objectsIn: result)
					DispatchQueue.main.async {
						self.updateNews(news: [newsRealm])
					}
					completion(.success(result))
                } catch {
                    return completion(.failure(.parseError))
                }
            }
            task.resume()
    }
    
    /// Спорт новости
    func loadSpotsNews(completion: @escaping (Result<[Article], FriendsError>) -> Void) {
            let params: [String: String] = ["pageSize" : "20"]
            
            let url = configureUrl(keyApi: .key,
                                   method: .friendsGet,
                                   country: .ru,
                                   category: .sports,
                                   httpMethod: .get,
                                   params: params)
            print(url)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    return completion(.failure(.requestError(error)))
                }
                guard let data = data else { return }
                do {
                    let result = try self.decoder.decode(News.self, from: data).articles
                    
                    let newsRealm = NewsRealm()
                    newsRealm.category = "Спорт"
                    newsRealm.listNews.append(objectsIn: result)
					DispatchQueue.main.async {
						self.updateNews(news: [newsRealm])
					}
					completion(.success(result))
                } catch {
                    return completion(.failure(.parseError))
                }
            }
            task.resume()
    }
    
    /// Развлекательные новости
    func loadEntertainmentNews(completion: @escaping (Result<[Article], FriendsError>) -> Void) {

            let params: [String: String] = ["pageSize" : "20"]
            
            let url = configureUrl(keyApi: .key,
                                   method: .friendsGet,
                                   country: .ru,
                                   category: .entertainment,
                                   httpMethod: .get,
                                   params: params)
            print(url)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    return completion(.failure(.requestError(error)))
                }
                guard let data = data else { return }
                do {
                    let result = try self.decoder.decode(News.self, from: data).articles
                    let newsRealm = NewsRealm()
                    newsRealm.category = "Развлечения"
                    newsRealm.listNews.append(objectsIn: result)
					DispatchQueue.main.async {
						self.updateNews(news: [newsRealm])
					}
					completion(.success(result))
                } catch {
                    return completion(.failure(.parseError))
                }
            }
            task.resume()
    }
    
    /// Главные новости
    func loadGeneralNews(completion: @escaping (Result<[Article], FriendsError>) -> Void) {

            let params: [String: String] = ["pageSize" : "20"]
            
            let url = configureUrl(keyApi: .key,
                                   method: .friendsGet,
                                   country: .ru,
                                   category: .general,
                                   httpMethod: .get,
                                   params: params)
            print(url)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    return completion(.failure(.requestError(error)))
                }
                guard let data = data else { return }
                do {
                    let result = try self.decoder.decode(News.self, from: data).articles
                    let newsRealm = NewsRealm()
                    newsRealm.category = "Главные"
                    newsRealm.listNews.append(objectsIn: result)
					DispatchQueue.main.async {
						self.updateNews(news: [newsRealm])
					}
					completion(.success(result))
                } catch {
                    return completion(.failure(.parseError))
                }
            }
            task.resume()
    }

    /// Новости технологий
    func loadTechnologyNews(completion: @escaping (Result<[Article], FriendsError>) -> Void) {
            let params: [String: String] = ["pageSize" : "20"]
            
            let url = configureUrl(keyApi: .key,
                                   method: .friendsGet,
                                   country: .ru,
                                   category: .technology,
                                   httpMethod: .get,
                                   params: params)
            print(url)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    return completion(.failure(.requestError(error)))
                }
				guard let data = data else { return }
				do {
					let result = try self.decoder.decode(News.self, from: data).articles
					let newsRealm = NewsRealm()
					newsRealm.category = "Технологии"
					newsRealm.listNews.append(objectsIn: result)
					DispatchQueue.main.async {
						self.updateNews(news: [newsRealm])
					}
					completion(.success(result))
				} catch {
					return completion(.failure(.parseError))
				}
			}
		task.resume()
	}
}

// MARK: - Private

private extension RequestServer {

    /// Метод для работы с БД реалм
	func updateNews(news: [NewsRealm]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL!)
            realm.beginWrite()
            realm.add(news, update: .all)
            try realm.commitWrite()
        } catch {
            print("error \(error)")
        }
	}
    
    /// Метод для конфигурации URL
    func configureUrl(keyApi: KeyApi,
                      method: TypeMethods,
                      country: LanguageNews,
                      category: CategoryNews,
                      httpMethod: TypeRequest,
                      params: [String: String]) -> URL {
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "country", value: country.rawValue))
        queryItems.append(URLQueryItem(name: "category", value: category.rawValue))
        for (param, value) in params {
            queryItems.append(URLQueryItem(name: param, value: value))
        }
        queryItems.append(URLQueryItem(name: "apiKey", value: keyApi.rawValue))
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = method.rawValue
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            fatalError("URL is invalid")
        }
        return url
    }
}

