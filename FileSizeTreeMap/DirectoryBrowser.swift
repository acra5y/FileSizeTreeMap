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

    func getItems(pathToBrowse aPath: String) -> [String : [FileAttributeKey : Any]] {
        do {
            let contents: [String] = try FileManager.default.contentsOfDirectory(atPath: aPath)
            return contents.reduce(into: [String: [FileAttributeKey : Any]]()) {
                $0[$1] = getItem(pathToItem: "\(aPath)/\($1)")
            }
        } catch {
            print("Boom \(error)")
            return [:]
        }
    }

    func isDirectory(pathToCheck aPath: String) -> Bool {
        var isDirectory: ObjCBool = false

        FileManager.default.fileExists(atPath: aPath, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
}
