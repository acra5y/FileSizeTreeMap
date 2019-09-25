//
//  DirectoryBrowser.swift
//  FileSizeTreeMap
//
//  Created by Olivier Schmelzle on 24.09.19.
//  Copyright © 2019 Olivier Schmelzle. All rights reserved.
//

import Foundation

class DirectoryBrowser {
    private func getItem(pathToItem: String) -> [FileAttributeKey : Any] {
        do {
            return try FileManager.default.attributesOfItem(atPath: pathToItem)
        } catch {
            print("Boom \(error)")
            return [:]
        }
    }

    func getItems(pathToBrowse aPath: FileManager.SearchPathDirectory) -> [String : [FileAttributeKey : Any]] {
        let urls: [URL] = FileManager.default.urls(for: aPath, in: .userDomainMask)
        do {
            let contents: [String] = try FileManager.default.contentsOfDirectory(atPath: urls[0].path)
            return contents.reduce(into: [String: [FileAttributeKey : Any]]()) {
                $0[$1] = getItem(pathToItem: "\(urls[0].path)/\($1)")
            }
        } catch {
            print("Boom \(error)")
            return [:]
        }
    }
}
