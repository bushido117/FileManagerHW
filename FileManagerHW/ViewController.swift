//
//  ViewController.swift
//  FileManagerHW
//
//  Created by Вадим Сайко on 27.09.22.
//

import UIKit

class Person: Codable {
    var name: String
    var surname: String
    var pet: Pet?
    internal init(name: String, surname: String, pet: Pet?) {
        self.name = name
        self.surname = surname
        self.pet = pet
    }
}

class Pet: Codable {
    var name: String
    var ownersName: String
    internal init(name: String, ownersName: String) {
        self.name = name
        self.ownersName = ownersName
    }
}

class ViewController: UIViewController, FileManagerDelegate {
    let person = Person(name: "Vadim", surname: "Saiko", pet: nil)
    let pet = Pet(name: "Volodya", ownersName: "Vadim")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager()
        fileManager.delegate = self
//        2 задание
        person.pet = pet
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        var preferenceUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        do {
            let data = try encoder.encode(person)
            preferenceUrl.append(component: "person")
            try data.write(to: preferenceUrl)
        } catch {
            print(error)
        }
        
        do {
            let person1 = try decoder.decode(
                Person.self,
                from: FileManager.default.contents(atPath: preferenceUrl.path) ?? .init())
            print(person1.name)
        } catch {
            print(error)
        }
//       1 задание
        writeSomeData(data: "myImage")
        writeSomeData(data: "myPhoto")
        writeSomeData(data: "myData")
        writeSomeData(data: "myFile")
        writeSomeData(data: "myDocument")
    }

    func writeSomeData(data: String) {
        var cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        var documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        cacheUrl.append(component: data)
        do {
            try data.write(to: cacheUrl, atomically: true, encoding: .utf8)
            if FileManager.default.fileExists(atPath: documentUrl.path() + "/\(data)")
                && cacheUrl.lastPathComponent != "person"{
                try FileManager.default.removeItem(atPath: documentUrl.path() + "/\(data)")
            }
            if cacheUrl.lastPathComponent != "myImage" {
                documentUrl.append(component: data)
                try FileManager.default.moveItem(at: cacheUrl, to: documentUrl)
            }
        } catch {
            print(error)
        }
    }
}
