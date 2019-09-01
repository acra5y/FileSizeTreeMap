//
//  ViewController.swift
//  FileSizeTreeMap
//
//  Created by Olivier Schmelzle on 01.09.19.
//  Copyright © 2019 Olivier Schmelzle. All rights reserved.
//

import Cocoa
import AppKit
import YMTreeMap

class ViewController: NSViewController {

    @IBOutlet weak var TreeMapContainer: NSBox!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        draw()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    var randomColor: NSColor {
        return NSColor(red: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       green: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       blue: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       alpha: 1)
    }
    
    func draw() {
        let values = [ 445, 203, 110, 105, 95, 65, 33, 21, 10 ].sorted()
        
        // These two lines are actual YMTreeMap usage!
        let treeMap = YMTreeMap(withValues: values)
        let treeMapRects = treeMap.tessellate(inRect: TreeMapContainer.bounds)
        
        let context = NSGraphicsContext.current?.cgContext
        
        treeMapRects.forEach { (treeMapRect) in
            randomColor.setFill()
            context?.fill(treeMapRect)
        }
    }
}

