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
        let red: CGFloat = ( (CGFloat)(arc4random_uniform(256)) ) / 256;
        let green: CGFloat = ( (CGFloat)(arc4random_uniform(256)) ) / 256;
        let blue: CGFloat = ( (CGFloat)(arc4random_uniform(256)) ) / 256;

        let mixRed: CGFloat = 1+0xad/256, mixGreen: CGFloat = 1+0xd8/256, mixBlue: CGFloat = 1+0xe6/256;

        return NSColor(red: (red + mixRed) / 3,
                       green: (green + mixGreen) / 3,
                       blue: (blue + mixBlue) / 3,
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
            attributes: [.strokeColor: NSColor.white, .strokeWidth:  -1.5, .font: NSFont.systemFont(ofSize: 14)]
        )
        label.draw(in: dirtyRect)
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil // let click bubble up to parent view
    }
}
