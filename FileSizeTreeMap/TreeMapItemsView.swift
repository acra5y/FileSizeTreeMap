//
//  TreeMapViewItems.swift
//  FileSizeTreeMap
//
//  Created by Olivier Schmelzle on 20.10.19.
//  Copyright © 2019 Olivier Schmelzle. All rights reserved.
//

import Cocoa
import YMTreeMap

class TreeMapItemsView: NSView {
    var state: (ok: Bool, items: [String : Item]) = (true, [:])
    private var tiles: [ItemView] = []

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    init(frame frameRect: NSRect, state: (ok: Bool, items: [String : Item])) {
        super.init(frame: frameRect)
        
        self.state = state
    }

    private func drawItems() {
        let names = self.state.items.map({ key, _ in key })
        let values = self.state.items.map({ _, value in value.size }).compactMap{ $0 }
        
        let treeMap = YMTreeMap(withValues: values)
        let treeMapRects: [NSRect] = treeMap.tessellate(inRect: self.bounds)
        
        var tiles: [ItemView] = []
        
        for (index, treeMapRect) in treeMapRects.enumerated() {
            let itemName = names[index]
            let item = ItemView(frame: treeMapRect, name: itemName, item: self.state.items[itemName]!)
            self.addSubview(item, positioned: .below, relativeTo: index == 0 ? nil : tiles[index - 1])
            tiles.append(item)
        }
        self.tiles = tiles
    }
    
    public func updateView() {
        for view in self.subviews where view is ItemView || view is ErrorMessageView {
            view.removeFromSuperviewWithoutNeedingDisplay()
        }

        if (!self.state.ok) {
            self.tiles = []
            let errorMessage = ErrorMessageView(frame: self.bounds)
            self.addSubview(errorMessage)
            return
        }
        
        self.drawItems()
    }

    override func viewDidEndLiveResize() {
        self.updateView()
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil // let click bubble up to parent view
    }
}
