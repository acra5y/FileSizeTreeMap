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

    @IBOutlet var treeMapView: TreeMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        treeMapView = TreeMapView(frame: .zero)
        self.view.addSubview(treeMapView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

