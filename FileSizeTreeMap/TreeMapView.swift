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

    @IBOutlet weak var currentPathTextfield: NSTextField!

    private var tiles: [ItemView] = []
    lazy private var currentPath: String = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true).first!
    lazy private var directoryBrowser: DirectoryBrowser = DirectoryBrowser()

    private func getTreeMapBounds(outerRect: NSRect) -> NSRect {
        return NSMakeRect(outerRect.minX, outerRect.minY - self.currentPathTextfield.bounds.minY, outerRect.width, outerRect.height - self.currentPathTextfield.bounds.height)
    }

    private func updateCurrentPath(newPath: String) {
        if (self.directoryBrowser.isDirectory(pathToCheck:  newPath)) {
            self.currentPath = newPath
            self.setNeedsDisplay(self.bounds)
        }
    }

    @IBAction func textFieldEdited(_ sender: NSTextField) {
        self.updateCurrentPath(newPath: sender.stringValue)
    }

    override func mouseUp(with event: NSEvent) {
        if (event.clickCount == 1) {
            let clickedTile = self.tiles.first(where:{ $0.frame.contains(event.locationInWindow) })

            if (clickedTile != nil) {
                self.updateCurrentPath(newPath: "\(self.currentPath)/\(clickedTile!.name)")
            } else {
                print("I don't know where that click went")
            }
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        self.currentPathTextfield.stringValue = self.currentPath
        let items = self.directoryBrowser
            .getItems(pathToBrowse: self.currentPath)
            .filter({ _, value in return value[FileAttributeKey.size]! as! Double > 0 })
        super.draw(dirtyRect)

        let names = items.map({ key, _ in key })
        let values = items.map({ key, value in value[FileAttributeKey.size]! as! Double })

        let treeMap = YMTreeMap(withValues: values)
        let treeMapRects: [NSRect] = treeMap.tessellate(inRect: self.getTreeMapBounds(outerRect: dirtyRect))

        var tiles: [ItemView] = []

        for (index, treeMapRect) in treeMapRects.enumerated() {
            let item = ItemView(frame: treeMapRect)
            let itemName = names[index]
            item.name = itemName
            item.file = items[itemName]!
            item.draw(treeMapRect)
            tiles.append(item)
            self.tiles = tiles
        }
    }
}
