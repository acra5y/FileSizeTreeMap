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

    func getItem(pathToItem: String) -> [FileAttributeKey : Any] {
        do {
            return try FileManager.default.attributesOfItem(atPath: pathToItem)
        } catch {
            print("Boom \(error)")
            return [:]
        }
    }

    func getItems() -> [[FileAttributeKey : Any]] {
        let urls: [URL] = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)
        do {
            let contents: [String] = try FileManager.default.contentsOfDirectory(atPath: urls[0].path)
            return contents.map({ getItem(pathToItem: "\(urls[0].path)/\($0)") })
        } catch {
            print("Boom \(error)")
            return []
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        let items = getItems()
        super.draw(dirtyRect)

        let values = items.map({ $0[FileAttributeKey.size]! as! Double }).sorted()

        // These two lines are actual YMTreeMap usage!
        let treeMap = YMTreeMap(withValues: values)
        let treeMapRects = treeMap.tessellate(inRect: dirtyRect)

        treeMapRects.forEach { (treeMapRect) in
            randomColor.setFill()
            treeMapRect.fill()
        }
    }

}
