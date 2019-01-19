//
//  ContainerViewController.swift
//  TODO_App_With_Great_Design
//
//  Created by DeEp KapaDia on 07/07/18.
//  Copyright © 2018 DeEp KapaDia. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var ContainerView: UIView!
    
    @IBOutlet weak var ConnectionBTN: UIButton!
    
    @IBOutlet weak var AddBTN: UIButton!
    
    var TodoTableViewController:ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       AddBTN.layer.cornerRadius = AddBTN.frame.size.width / 2
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "todoVC" {
            
            TodoTableViewController = (segue.destination as! UINavigationController).childViewControllers.first as! ViewController
            TodoTableViewController.connectionBTN = ConnectionBTN
            
        }
        
    }
    
    @IBAction func AddBTN(_ sender: UIButton) {
        
        TodoTableViewController.AddBTN()
        
    }
    @IBAction func ConnectionStatusBTN(_ sender: UIButton) {
        
        TodoTableViewController.ShareActionBtn()
        
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
