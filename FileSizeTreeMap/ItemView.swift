//
//  ItemView.swift
//  FileSizeTreeMap
//
//  Created by Olivier Schmelzle on 24.09.19.
//  Copyright © 2019 Olivier Schmelzle. All rights reserved.
//

import Cocoa

class ItemView: NSView {
    lazy var name: String = ""
    lazy var item: Item = Item(size: 0, isDirectory: false)

    required init?(coder decoder: NSCoder) {
       super.init(coder: decoder)
    }

    init(frame frameRect: NSRect, name: String, item: Item) {
        super.init(frame: frameRect)

        self.name = name
        self.item = item
    }

    var randomColor: NSColor {
        return NSColor(red: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       green: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       blue: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       alpha: 1)
    }

    private func getLabel() -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.countStyle = .file
        return "\(self.name) \(byteCountFormatter.string(fromByteCount: Int64(self.item.size!)))"
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        randomColor.setFill()
        dirtyRect.fill()
        let label: NSAttributedString =  NSAttributedString(
            string: self.getLabel(),
            attributes: [.foregroundColor: NSColor.white, .strokeColor: NSColor.black, .strokeWidth:  -3.0]
        )
        label.draw(in: dirtyRect)
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil // let click bubble up to parent view
    }
}
