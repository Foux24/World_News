//
//  HashImage.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 11.03.2022.
//

import UIKit

/// Протокол для ребута коллекции или таблицы по индекспасу
fileprivate protocol DataReloadable {
    func reloadRow(atIndexPath indexPath: IndexPath)
}

// MARK: - HashPhotoService ( загрузка картинок в хэш при работу с таблицами и коллекциями )
final class HashImage {
    
    /// Тайм интервал в течении которого кеш актуален
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    
    /// Массив с урл : картинкой
    private var images = [String: UIImage]()
    
    /// свойство для обналвения таблицы или коллекции через протокол
    private let container: DataReloadable
    
    /// инициализтора для ребута таблицы или коллекции
    init(container: UITableView) {
        self.container = Table(table: container)
    }
    
    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
    
    /// свойство для задания имени папки в которую будут сохранятся изображения
    private static let pathName: String = {
        let pathName = "images"
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return pathName}
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()
    
    /// Метод предоставления изображения по переданному урлу
    func photo(atIndexPath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        if let photo = images[url] {
            image = photo
        }else if let photo = getImageFromCache(url: url) {
            image = photo
        }else{
            loadPhoto(atIndexPath: indexPath, byUrl: url)
        }
        return image
    }
}

// MARK: - Private
/// Расширим наш клас для имплементации классов таблиц и коллекций
private extension HashImage {
    
    class Table: DataReloadable {
        /// сылка на таблицу
        let table: UITableView
        /// инициализтор
        init(table: UITableView) {
            self.table = table
        }
        /// Метод для ребута строки в таблице
        func reloadRow(atIndexPath indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    /// Аналогично више представленному варианту, только обновляем итем в коллекции а не строку
    class Collection: DataReloadable {
        let collection: UICollectionView
        init(collection: UICollectionView) {
            self.collection = collection
        }
        func reloadRow(atIndexPath indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
    
    /// Метод загрузки изображения из файловой системы
    func getImageFromCache(url: String) -> UIImage? {
        guard
            let fileName = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else { return nil }
        
        /// Смотрим дату создания файла в системе
        let lifeTime = Date().timeIntervalSince(modificationDate)
        guard
            lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return nil }
        DispatchQueue.main.async {
            self.images[url] = image
        }
        return image
    }
    
    /// Метод конфигурации пути к файлу
    func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(HashImage.pathName + "/" + hashName).path
    }
    
    /// Метод загрузки изображения из сети по переданному адресу
    func loadPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) {
        
        guard let urlImage = URL(string: url) else { return }
        URLSession.shared.dataTask(with: urlImage) { [weak self] (data, response, error) in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.images[url] = image
            }
            self?.saveImageToCache(url: url, image: image)
            DispatchQueue.main.async {
                self?.container.reloadRow(atIndexPath: indexPath)
            }
        }.resume()
        
    }
    
    /// Метод для сохранения изображения в файловой системе
    func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
              let data = image.pngData() else {return}
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}
