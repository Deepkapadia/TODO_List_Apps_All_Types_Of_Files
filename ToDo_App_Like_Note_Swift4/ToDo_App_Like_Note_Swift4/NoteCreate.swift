//
//  NoteCreate.swift
//  ToDo_App_Like_Note_Swift4
//
//  Created by DeEp KapaDia on 19/06/18.
//  Copyright © 2018 DeEp KapaDia. All rights reserved.
//

import UIKit

class NoteCreate: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func DoneBTN(_ sender: UIButton) {
        
        if (textView.text != nil) && textView.text != ""{
            
            ToDoList?.append(textView.text!)
            textView.text = ""
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
