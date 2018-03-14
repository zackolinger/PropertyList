//
//  ViewController2.swift
//  PropertyList
//
//  Created by Zack Olinger on 3/14/18.
//  Copyright © 2018 Zack Olinger. All rights reserved..
//

import UIKit

class IdeaViewController: UIViewController {

    @IBOutlet weak var ideaView: UITextView!
    
    var idea : [Dictionary<String, String>]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let idea = idea {
            var ideaList = ""
            var ideaNumber = 1
            
            for thoughts in idea {
                if let thought = thoughts["Thought"] {
                    ideaList += " #\(ideaNumber)\nIdea: \(thought)\n\n"
                }
                ideaNumber += 1
            }
          ideaView.text = ideaList
        }
        
    }
}
