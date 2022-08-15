//
//  ViewController.swift
//  UIKit
//
//  Created by Arthur Wang on 7/12/22.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    var ticker: String = ""
    var graphData: [CGPoint] = [CGPoint(x: 0.0, y: 0.0)]
    var range: (CGFloat, CGFloat) = (0, 1)
    var domain: (CGFloat, CGFloat) = (0, 1)
    
    lazy var graph: XYChart = {
        let view = XYChart.init()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    lazy var dictionaryView: DictionaryView = {
        let view = DictionaryView.init(frame: NSRect())
        view.data = [ : ]
        return view
    }()
    lazy var searchBar: SearchBar = {
        let view = SearchBar.init(frame: NSRect(), delegate: self, dataSource: self)
        return view
    }()
    
    lazy var tabs: TabView = {
        let view = TabView.init(frame: NSRect())
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
        view.wantsLayer = true
        view.layer!.backgroundColor = NSColor.white.cgColor
        self.view.addSubview(graph)
        self.view.addSubview(tabs)
        self.view.addSubview(dictionaryView)
        self.view.addSubview(searchBar)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        layout()
        self.view.window?.delegate = self
    }
    func windowDidResize(_ notification: Notification) {
        layout()
    }
    func layout() {
        layoutGraph()
        layoutSearchBar()
        layoutTabs()
        layoutDictionaryView()
    }
    func updateGraph() {
        graph.removeFromSuperview()
        graph = XYChart.init()
        graph.delegate = self
        graph.dataSource = self
        self.view.addSubview(graph, positioned: .below, relativeTo: searchBar)
        layoutGraph()
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    override func scrollWheel(with event: NSEvent) {
//        print(event.scrollingDeltaY)
    }
    override func mouseUp(with event: NSEvent) {
        ObserveObject.obj.mouseDown = false
    }
    override func mouseDown(with event: NSEvent) {
        ObserveObject.obj.mouseDown = true
    }
    func apiCall() {
//        Exchanges.initiateCodes()
//        Companies.createLocalStorage()
        print(NSHomeDirectory() + "/tickers.json")
        Companies.loadData()
    }
}

extension ViewController {
    func layoutDictionaryView() {
        dictionaryView.frame = self.view.bounds
        dictionaryView.frame.size.height -= 200
        dictionaryView.frame.size.width = 400
        dictionaryView.frame.origin.x = self.view.bounds.width - 400
        dictionaryView.frame.origin.y = 100
    }
    func layoutGraph() {
        graph.frame = view.bounds
        graph.frame.size.height -= 100
        graph.frame.size.width -= 400
    }
    func layoutSearchBar() {
        searchBar.frame.origin.y = view.bounds.height - 75
        searchBar.frame.origin.x = view.bounds.midX - 250
        searchBar.frame.size.width = 400
        searchBar.frame.size.height = 30
    }
    func layoutTabs() {
        tabs.frame.origin.y = view.bounds.height - 75
        tabs.frame.origin.x = view.bounds.midX + 175
        tabs.frame.size.width = 225
        tabs.frame.size.height = 30
//        tabs.wantsLayer = true
//        tabs.layer?.backgroundColor = NSColor.blue.cgColor
    }
}


