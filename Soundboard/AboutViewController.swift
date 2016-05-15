//
//  AboutViewController.swift
//  Soundboard
//
//  Created by Jan on 15.05.16.
//  Copyright © 2016 dfragment.net. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let htmlPath = NSBundle.mainBundle().pathForResource("about", ofType: "html")
        do {
            let html = try NSString(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding)
            webView.loadHTMLString(html as String, baseURL: nil)
        } catch let error as NSError {
            print("No about.html file present", error)
            webView.loadHTMLString("<p>Soundboard<br />© dfragment.net 2016</p>", baseURL: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
