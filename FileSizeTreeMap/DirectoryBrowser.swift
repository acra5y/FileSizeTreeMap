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
            print("Error reading attributes of item \(pathToItem): \(error)")
            return [:]
        }
    }

    func getItems(pathToBrowse aPath: String) -> (Bool, [String : [FileAttributeKey : Any]]) {
        if (!self.isDirectory(pathToCheck:  aPath)) {
            print("given path \(aPath) is not a directory.")
            return (false, [:])
        }

        do {
            let contents: [String] = try FileManager.default.contentsOfDirectory(atPath: aPath)
            return (
                true,
                contents.reduce(into: [String: [FileAttributeKey : Any]]()) {
                    $0[$1] = getItem(pathToItem: "\(aPath)/\($1)")
                }
            )
        } catch {
            print("Error reading files at path \(aPath) \(error)")
            return (false, [:])
        }
    }

    func isDirectory(pathToCheck aPath: String) -> Bool {
        var isDirectory: ObjCBool = false

        FileManager.default.fileExists(atPath: aPath, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
}
