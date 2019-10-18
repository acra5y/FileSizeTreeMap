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
    lazy private var state: (ok: Bool, items: [String : Int]) = self.directoryBrowser.getItems(pathToBrowse: self.currentPath)

    private func getRectBelowTextField(outerRect: NSRect) -> NSRect {
        return NSMakeRect(outerRect.minX, outerRect.minY - self.currentPathTextfield.bounds.minY, outerRect.width, outerRect.height - self.currentPathTextfield.bounds.height)
    }

    private func updateCurrentPath(newPath: String) {
        if (newPath.count > 0) {
            self.currentPath = newPath
        }
        self.state = self.directoryBrowser.getItems(pathToBrowse: self.currentPath)
        self.updateView()
    }

    @IBAction func textFieldEdited(_ sender: NSTextField) {
        self.updateCurrentPath(newPath: sender.stringValue)
    }

    override func mouseUp(with event: NSEvent) {
        if (event.clickCount == 1) {
            let clickedTile = self.tiles.first(where:{ $0.frame.contains(event.locationInWindow) })

            if (clickedTile != nil) {
                let newPath = "\(self.currentPath)/\(clickedTile!.name)"
                if (self.directoryBrowser.isDirectory(pathToCheck: newPath)) {
                    self.updateCurrentPath(newPath: "\(self.currentPath)/\(clickedTile!.name)")
                } else {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(clickedTile!.name, forType: .string)
                }
            }
        }
    }

    private func drawItems(bounds: NSRect, items: [String : Int]) {
        let names = items.map({ key, _ in key })
        let values = items.map({ _, value in value })

        let treeMap = YMTreeMap(withValues: values)
        let treeMapRects: [NSRect] = treeMap.tessellate(inRect: bounds)

        var tiles: [ItemView] = []

        for (index, treeMapRect) in treeMapRects.enumerated() {
            let itemName = names[index]
            let item = ItemView(frame: treeMapRect, name: itemName, size: items[itemName]!)
            self.addSubview(item, positioned: .below, relativeTo: index == 0 ? self.currentPathTextfield : tiles[index - 1])
            tiles.append(item)
        }
        self.tiles = tiles
    }

    private func updateView() {
        self.currentPathTextfield.stringValue = self.currentPath
        let rectBelowTextField = self.getRectBelowTextField(outerRect: self.bounds)

        if (!self.state.ok) {
            self.tiles = []
            let errorMessage = ErrorMessageView(frame: rectBelowTextField)
            self.addSubview(errorMessage)
            return
        }

        for view in self.window!.contentView!.subviews where view is ItemView || view is ErrorMessageView {
            view.removeFromSuperviewWithoutNeedingDisplay()
        }

        self.drawItems(
            bounds: rectBelowTextField,
            items: self.state.items.filter({ key, value in return value != nil && value! > 0 })
        )
    }
}
