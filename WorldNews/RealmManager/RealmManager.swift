//
//  RealmManager.swift
//  WorldNews
//
//  Created by Vitalii Sukhoroslov on 13.03.2022.
//

import Foundation
import RealmSwift

// MARK: - RealmManager
// Манагер для работы с БД реалм
final class RealmManager {
    
    static let shared = RealmManager()
    private let realm: Realm
    
    private init?() {
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configuration) else { return nil }
        print(realm.configuration.fileURL ?? "")
        self.realm = realm
    }
    
    // метод добавления обьекта
    func add<T: Object>(object: T) throws {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    // метод добавления масива обьекта
    func add<T: Object>(object: [T]) throws {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    // метод обновления БД
    func update<T: Object>(type: T, primaryKeyValue: Any, setNewValue: Any, field: String) throws {
        try realm.write {
            guard let primaryKey = T.primaryKey() else {
                print("нет ключа для обьекта \(T.self)")
                return
            }
            let target = realm.objects(T.self).filter("\(primaryKey) = %@", primaryKeyValue)
            target.setValue(setNewValue, forKey: "\(field)")
        }
    }
    
    // метод получения обьекта
    func getObject<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    // метод удаления обьекта
    func delete<T: Object>(object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }
    
    // метод удаления всех обьектов
    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
}
