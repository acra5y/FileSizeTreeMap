//
//  TreeMapView.swift
//  FileSizeTreeMap
//
//  Created by Olivier Schmelzle on 05.09.19.
//  Copyright © 2019 Olivier Schmelzle. All rights reserved.
//

import Cocoa

class TreeMapView: NSView {

    @IBOutlet weak var currentPathTextfield: NSTextField!
    @IBOutlet weak var treeMapItemsView: TreeMapItemsView!

    lazy private var currentPath: String = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true).first!
    lazy private var directoryBrowser: DirectoryBrowser = DirectoryBrowser()

    override func mouseUp(with event: NSEvent) {
        if (event.clickCount == 1) {
            let container = self.window!.contentView!.subviews.first(where:{ $0.frame.contains(event.locationInWindow) })

            if (container != nil && container is TreeMapItemsView) {
                let clickedTile = container!.subviews.first(where:{ $0.frame.contains(event.locationInWindow) })

                if (clickedTile != nil && clickedTile is ItemView) {
                    let itemName = (clickedTile! as! ItemView).name

                    let newPath = "\(self.currentPath)/\(itemName)"
                    if (self.directoryBrowser.isDirectory(pathToCheck: newPath)) {
                        self.updateCurrentPath(newPath: "\(self.currentPath)/\(itemName)")
                    } else {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(itemName, forType: .string)
                    }
                }
            }
        }
    }

    public func updateCurrentPath(newPath: String) {
        if (newPath.count > 0) {
            self.currentPath = newPath
        }
        self.currentPathTextfield.stringValue = self.currentPath
        self.treeMapItemsView.state = self.directoryBrowser.getItems(pathToBrowse: self.currentPath)
        self.treeMapItemsView.updateView()
    }

    @IBAction func textFieldEdited(_ sender: NSTextField) {
        self.updateCurrentPath(newPath: sender.stringValue)
    }
}
