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
    var randomColor: NSColor {
        return NSColor(red: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                   green: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                   blue: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                   alpha: 1)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let values = [ 445, 203, 110, 105, 95, 65, 33, 21, 10 ].sorted()

        // These two lines are actual YMTreeMap usage!
        let treeMap = YMTreeMap(withValues: values)
        let treeMapRects = treeMap.tessellate(inRect: dirtyRect)

        treeMapRects.forEach { (treeMapRect) in
            randomColor.setFill()
            treeMapRect.fill()
        }
    }

}
