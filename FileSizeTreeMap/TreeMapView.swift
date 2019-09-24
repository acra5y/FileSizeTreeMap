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
    private var tiles: [ItemView] = []

    override func mouseUp(with event: NSEvent) {
        if (event.clickCount == 1) {
            let clickedTile = self.tiles.first(where:{ $0.frame.contains(event.locationInWindow) })

            if (clickedTile != nil) {
                print(clickedTile!.name)
            } else {
                print("I don't know where that click went")
            }
        }
    }

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

        var tiles: [ItemView] = []

        for (index, treeMapRect) in treeMapRects.enumerated() {
            let item = ItemView(frame: treeMapRect)
            item.name = names[index]
            item.draw(treeMapRect)
            tiles.append(item)
            self.tiles = tiles
        }
    }
}
