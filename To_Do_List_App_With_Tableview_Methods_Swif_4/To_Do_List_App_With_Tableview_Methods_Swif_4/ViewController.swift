//
//  ViewController.swift
//  To_Do_List_App_With_Tableview_Methods_Swif_4
//
//  Created by DeEp KapaDia on 06/07/18.
//  Copyright © 2018 DeEp KapaDia. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TODOCellDelegate,MCBrowserViewControllerDelegate,MCSessionDelegate{
    
    

    var todoitems:[TodoItem]!
    
    //need this properties for all contents to share one side to another side.
    var PeerID:MCPeerID!
    var McSession:MCSession!
    var McAdvertiserAssistant:MCAdvertiserAssistant!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConnectivity()
        LoadData()
    
    }

    
    //for session
    func setupConnectivity(){
        
        PeerID = MCPeerID(displayName: UIDevice.current.name)
        McSession = MCSession(peer: PeerID, securityIdentity: nil, encryptionPreference: .required)
        McSession.delegate = self
    }
    //For Load Data into a table view.
    func LoadData(){
        
        todoitems = [TodoItem]()
        todoitems = DataManager.loadAll(TodoItem.self).sorted(by: {
            
            $0.createdAt < $1.createdAt
            
        })
        
        tableview.reloadData()
    }
    
    //Add Button Coding with allet fuinction.
    @IBAction func AddBTN(_ sender: Any) {
        
    
        let Alert = UIAlertController(title: "Add New ToDo", message: "Enter a Title", preferredStyle: .alert)
        
        Alert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "ToDo Item Title"
        }
 
        Alert.addAction(UIAlertAction(title: "create", style: .default, handler: { (action:UIAlertAction) in
            
            guard let title = Alert.textFields?.first?.text else {return}
            let NewToDo = TodoItem(title: title, completed: false, createdAt: Date(), itemIdentifier: UUID())
            NewToDo.saveItem()

            self.todoitems.append(NewToDo)
            
            let indexpath = IndexPath(row: self.tableview.numberOfRows(inSection: 0), section: 0)
            
            self.tableview.insertRows(at: [indexpath], with: .automatic)
            
        }))
        
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(Alert, animated: true, completion: nil)
        
    }
    //Delete Button Functions code Work
    func DidDelete(_ cell: TODOCell) {
        
        
        if let indexpath = tableview.indexPath(for: cell){
            
            todoitems[indexpath.row].deleteItem()
            todoitems.remove(at: indexpath.row)
            tableview.deleteRows(at: [indexpath], with: .automatic)
            
        }
        
        
    }
    
    //ShareButton code Work
    func DidShare(_ cell: TODOCell) {
        
        if let indexpath = tableview.indexPath(for: cell){
            
            let todoitm = todoitems[indexpath.row]
            sendTODO(todoitm)
           
        }
        
        
    }
    
    
    //Send To other Device With Session Code
    func sendTODO (_ todoitem:TodoItem){
        
        if McSession.connectedPeers.count > 0 {
            
            if let tdData = DataManager.loadData(todoitem.itemIdentifier.uuidString){
                
                do{
                    try McSession.send(tdData, toPeers: McSession.connectedPeers, with: .reliable)
                
                }catch{
                    
                    fatalError("Could not send TODO Item")
                    
                }
                
            }
            
        }else {
            
            print("you are not copnnected to other devices")
            
        }
        
    }
    
    func DidComplete(_ cell: TODOCell) {
        
        if let indexpath = tableview.indexPath(for: cell){
            
            var todoitm = todoitems[indexpath.row]
            todoitm.markAsCompleted()
            cell.LBLtxt.attributedText = strikeThroughText(todoitm.title)
            
        }
        
    }
    
    func strikeThroughText (_ text:String) -> NSAttributedString{

        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
        
    }

    
    @IBAction func ShareActionBtn(_ sender: UIBarButtonItem) {
    
     
        let Alert = UIAlertController(title: "ToDo Exchange", message: "Do you want to host or Join a Session?", preferredStyle: .actionSheet)
        
        
        Alert.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { (action:UIAlertAction) in
            
            self.McAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.McSession)
            self.McAdvertiserAssistant.start()
            
        }))
        
        Alert.addAction(UIAlertAction(title: "Join Session", style: .default, handler: { (action:UIAlertAction) in
            
            let MCBrowser = MCBrowserViewController(serviceType: "ba-td", session: self.McSession)
            MCBrowser.delegate = self
            
            self.present(MCBrowser, animated: true, completion: nil)
        }))
        
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(Alert, animated: true, completion: nil)
        
    
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TODOCell
        cell.layer.cornerRadius = 10
        cell.delegate = self
        
        let todoitm = todoitems[indexPath.row]
        
        cell.LBLtxt.text = todoitm.title
        
        if todoitm.completed{
            
            cell.LBLtxt.attributedText = strikeThroughText(todoitm.title)
            
        }
        
        return cell
        
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState){
        
        switch state {
        case MCSessionState.connected:
            print("Connected:\(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting:\(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected:\(peerID.displayName)")
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
        do{
        let todoitem = try JSONDecoder().decode(TodoItem.self, from: data)
            DataManager.save(todoitem, with: todoitem.itemIdentifier.uuidString)
            DispatchQueue.main.async {
                
                self.LoadData()
                
            }
        }catch{
            
            fatalError("Errrorrorororororororroroooorro ")
            
        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        
        
        
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        
        
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
        
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    

}

