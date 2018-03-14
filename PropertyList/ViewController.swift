//
//  ViewController.swift
//  PropertyList
//
//  Created by Zack Olinger on 3/14/18.
//  Copyright © 2018 Zack Olinger. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mainTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTextField.delegate = self
        
    
    }
    
    @IBAction func saveIdea(_ sender: Any) {
        let alertController = UIAlertController(title: "Got it!", message: "Text input was saved!", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Done", style: .default, handler: { (alert) in
            print("Text input was saved")
        })
  
        alertController.addAction(yesAction)
        
        present(alertController, animated: true, completion: nil)
        
        saveData()
        
    }
    
    func saveData() {
        
        guard let thought = mainTextField.text,
            !thought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        let fileManager = FileManager.default
        let newIdea = ["Thought" : thought]
        
        var idea = getAllItemsFrom("idea.plist")
        
        if let _ = idea {
            idea?.append(newIdea)
        } else {
            idea = [newIdea]
        }
        
        do {
            let serializedData = try PropertyListSerialization.data(fromPropertyList: idea!, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
            let documents = try fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            let file = documents.appendingPathComponent("idea.plist")
            try serializedData.write(to: file)
        } catch {
            print(error.localizedDescription)
        }
        showResults()
    }
    
    func getAllItemsFrom(_ plist: String) -> [Dictionary<String, String>]? {
        
        let fileManager = FileManager.default
        var plistFormat = PropertyListSerialization.PropertyListFormat.xml
        
        do {
            let documents = try fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            let file = documents.appendingPathComponent(plist)
            let plistData = try Data(contentsOf: file)
            let idea = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &plistFormat) as! [Dictionary<String, String>]
            return idea
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    func showResults() {
        performSegue(withIdentifier: "showIdeas", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showIdeas", let nextScene = segue.destination as? IdeaViewController {
            
            if let idea = getAllItemsFrom("idea.plist") {
                nextScene.idea = idea
            } else {
                return
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


