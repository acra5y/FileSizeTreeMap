//
//  TreeMapView.swift
//  FileSizeTreeMap
//
//  Created by Olivier Schmelzle on 05.09.19.
//  Copyright © 2019 Olivier Schmelzle. All rights reserved.
//

import Cocoa
import YMTreeMap

class TreeMapView: NSView {
    func getItem(pathToItem: String) -> [FileAttributeKey : Any] {
        do {
            return try FileManager.default.attributesOfItem(atPath: pathToItem)
        } catch {
            print("Boom \(error)")
            return [:]
        }
    }

    func getItems() -> [String : [FileAttributeKey : Any]] {
        let urls: [URL] = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)
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

    override func draw(_ dirtyRect: NSRect) {
        let items = getItems()
        super.draw(dirtyRect)

        let names = items.map({ key, _ in key })
        let values = items.map({ key, value in value[FileAttributeKey.size]! as! Double })

        let treeMap = YMTreeMap(withValues: values)
        let treeMapRects: [NSRect] = treeMap.tessellate(inRect: dirtyRect)

        for (index, treeMapRect) in treeMapRects.enumerated() {
            let item = ItemView()
            item.name = names[index]
            item.draw(treeMapRect)
        }
    }
}
