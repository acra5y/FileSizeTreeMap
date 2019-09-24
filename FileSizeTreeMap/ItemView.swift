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

    var randomColor: NSColor {
        return NSColor(red: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       green: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       blue: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       alpha: 1)
    }

    override func draw(_ dirtyRect: NSRect) {
        randomColor.setFill()
        dirtyRect.fill()
        let label: NSAttributedString =  NSAttributedString(string: self.name, attributes: [.foregroundColor: NSColor.white, .strokeColor: NSColor.black, .strokeWidth:  -3.0])
        label.draw(in: dirtyRect)
    }
}
