//
//  ErrorMessageView.swift
//  FileSizeTreeMap
//
//  Created by Olivier Schmelzle on 03.10.19.
//  Copyright © 2019 Olivier Schmelzle. All rights reserved.
//

import Cocoa

class ErrorMessageView: NSView {
    lazy var message: String = "Could not read directory. Please make sure it exists and you have rights to access it."

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: NSColor.black]
        let label: NSAttributedString =  NSAttributedString(string: self.message, attributes: attributes)
        let size = label.size()
        let centeredRect = CGRect(
            x: dirtyRect.origin.x + (dirtyRect.size.width - size.width) / 2.0,
            y: dirtyRect.origin.y + (dirtyRect.size.height - size.height) / 2.0,
            width: dirtyRect.size.width,
            height: size.height
        )
        label.draw(in: centeredRect)
    }
}
