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

    private func getItemSize(pathToItem: String) -> Int? {
        let item = self.getItem(pathToItem: pathToItem)

        if (item[.type] == nil || item[.type]! as! FileAttributeType != .typeDirectory) {
            return item[.size] as? Int
        }

        var folderSize = 0
        (FileManager.default.enumerator(at: NSURL(fileURLWithPath: pathToItem) as URL, includingPropertiesForKeys: [.totalFileAllocatedSizeKey])?.allObjects as? [URL])?.lazy.forEach {
            folderSize += (try? $0.resourceValues(forKeys: [.totalFileAllocatedSizeKey]))?.totalFileAllocatedSize ?? 0
        }

        return folderSize
    }

    func getItems(pathToBrowse aPath: String) -> (Bool, [String : Item]) {
        if (!self.isDirectory(pathToCheck: aPath)) {
            print("given path \(aPath) is not a directory.")
            return (false, [:])
        }

        do {
            let contents: [String] = try FileManager.default.contentsOfDirectory(atPath: aPath)
            return (
                true,
                contents.reduce(into: [String: Item]()) {
                    let pathToItem = "\(aPath)/\($1)"
                    $0[$1] = Item(size: getItemSize(pathToItem: pathToItem), isDirectory: self.isDirectory(pathToCheck: pathToItem))
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
