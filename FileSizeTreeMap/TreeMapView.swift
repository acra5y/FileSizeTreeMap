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
    lazy private var directoryBrowser: DirectoryBrowser = DirectoryBrowser()

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

    override func draw(_ dirtyRect: NSRect) {
        let items = self.directoryBrowser.getItems(pathToBrowse: .picturesDirectory).filter({ _, value in return value[FileAttributeKey.size]! as! Double > 0 })
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
