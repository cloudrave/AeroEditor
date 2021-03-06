//
//  ViewController.swift
//  AeroEditor
//
//  Created by Nick Merrill on 7/29/15.
//  Copyright (c) 2015 Nick Merrill. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class ViewController: NSViewController {
    
    @IBOutlet weak var fileDisplay: NSTextField!
    
    lazy var statusWindowCtrl: NSWindowController = self.storyboard!.instantiateController(withIdentifier: "StatusWindowController") as! NSWindowController
    lazy var statusViewCtrl: StatusViewController = self.statusWindowCtrl.contentViewController as! StatusViewController
    lazy var previewWindowCtrl: NSWindowController = self.storyboard!.instantiateController(withIdentifier: "PreviewWindowController") as! NSWindowController
    lazy var previewViewCtrl: PreviewViewController = self.previewWindowCtrl.contentViewController as! PreviewViewController
    
    var videoURLs = [URL]()
    var activeProcessor:NMVideoProcessor? {
        didSet {
            statusViewCtrl.videoProcessor = activeProcessor
            previewViewCtrl.videoProcessor = activeProcessor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewWindowCtrl.showWindow(self)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    // Allows user to choose which video files to process
    @IBAction func addFiles(_ sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.runModal()
        self.videoURLs += openPanel.urls
        self.updateFileDisplay()
    }
    @IBAction func reset(_ sender: AnyObject) {
        self.videoURLs.removeAll(keepingCapacity: false)
        self.updateFileDisplay()
        self.previewViewCtrl.reset()
        self.activeProcessor?.reset()
    }
    
    func updateFileDisplay() {
        let str:NSMutableString = ""
        for url in self.videoURLs {
            str.append("• ")
            str.append(url.lastPathComponent)
            str.append("\n")
        }
        self.fileDisplay.stringValue = str as String
    }

    // Begins processing video files
    @IBAction func process(_ sender: AnyObject) {
        let processor = NMVideoProcessor(forFiles: self.videoURLs)
        self.activeProcessor = processor
        
        processor.completionHandler = {
            // Set preview video to monitor composition
            self.previewViewCtrl.loadAsset(processor.composition)
            self.previewViewCtrl.videoProcessor = processor
        }
        processor.beginProcessing()
    }
    
    // Shows window with processor queue status
    @IBAction func showStatus(_ sender: AnyObject) {
//        statusViewCtrl.videoProcessor = self.activeProcessor
        statusWindowCtrl.showWindow(self)
    }
    
    @IBAction func showPreview(_ sender: AnyObject) {
        previewWindowCtrl.showWindow(self)
    }
    
    
//    @IBAction func previewImageFrame(sender: AnyObject) {
//        if let processor = self.activeProcessor {
//            processor.getPreviewFrame({
//                image in
//                print("about to show frame")
//                self.previewImageView.image = NSImage(CGImage: image, size: self.previewImageView.frame.size)
//            })
//        }
//    }
}

