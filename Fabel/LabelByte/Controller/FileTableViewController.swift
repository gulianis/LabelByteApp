//
//  FileTableViewController.swift
//  LabelByte
//
//  Created by Sachin Guliani on 8/12/20.
//

import UIKit
import CoreData

class FileTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
 
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var account: Account?

    func fetchCall() {
        // Load Zip Files for current account
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
        let sortByTitle = NSSortDescriptor(key: "completed", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortByTitle, sortByName]
        let predicate = NSPredicate(format: "ofAccount = %@", account!)
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "completed", cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func downloadLabelFile() -> String {
        var DictString = ""
        let semaphore = DispatchSemaphore(value: 0)
        ReceiveLabelFile() { output in
            DictString = output
            semaphore.signal()
        }
        semaphore.wait()
        let jsonData = DictString.data(using: .utf8)!
        let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData)
        if let dictionary = jsonDictionary as? [String: String] {
            return dictionary["result"]!
        }
        return ""
    }
 
    
    func recieveZipNameDict() -> [String: String] {
        // Gets Zip Names from server
        var DictString = ""
        // Uses semaphore to wait for network call till data recieved
        let semaphore = DispatchSemaphore(value: 0)
        GETZipNames() { output in
            DictString = output
            semaphore.signal()
        }
        semaphore.wait()
        // Converts DictString to usable format
        let jsonData = DictString.data(using: .utf8)!
        let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
        if let dictionary = jsonDictionary as? [String: String] {
            return dictionary
        }
        return [:]
    }
    
    func recieveFormatZipNames() {
        // Updates and deletes current Zip File data
        let dictionary = recieveZipNameDict()
        var zipNameList = [String: Int]()
        let count = Int(dictionary["Count"]!)!
        do {
            let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
            let predicate = NSPredicate(format: "ofAccount= %@", account!)
            request2.predicate = predicate
            let result = try context.fetch(request2)
            var deleteObjects = [ZipFile]()
            for data in result as! [ZipFile] {
                deleteObjects.append(data)
            }
            while deleteObjects.count > 0 {
                account?.removeFromFile(deleteObjects.popLast()!)
                save()
            }
        } catch {
            print("Failed")
        }
        
        if count > 0 {
            for i in 0..<count {
                let zipName = dictionary["Data_" + String(i) + "_name"] ?? ""
                let finished = dictionary["Data_" + String(i) + "_saved"] ?? ""
                let Date = dictionary["Date_" + String(i) + "_date"] ?? ""
                zipNameList[zipName + Date] = 1
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
                let predicateOne = NSPredicate(format: "name = %@", zipName)
                let predicateTwo = NSPredicate(format: "ofAccount = %@", account!)
                let predicateThree = NSPredicate(format: "date = %@", Date)
                request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo, predicateThree])
                do {
                    // Add if Zip File doesn't exist in Core Data
                    let results = try context.fetch(request)
                    switch (results.count) {
                        case 0:
                            let zipFile = ZipFile(context: context)
                            zipFile.name = zipName
                            zipFile.clicked = false
                            zipFile.date = Date
                            switch (finished) {
                                case "true":
                                    zipFile.completed = true
                                default:
                                    zipFile.completed = false
                            }
                            account!.addToFile(zipFile)
                        default:
                            if finished == "true" {
                                (results[0] as! ZipFile).setValue(true, forKey: "completed")
                            } else {
                                (results[0] as! ZipFile).setValue(false, forKey: "completed")
                            }
                    }
                    save()
                } catch {
                    print("Failed")
                }
            }
        }
        /*
        do {
            // Delete objects that don't exist in server call
            let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
            let predicate = NSPredicate(format: "ofAccount= %@", account!)
            request2.predicate = predicate
            let result = try context.fetch(request2)
            var deleteObjects = [ZipFile]()
            for data in result as! [ZipFile] {
                let val_name = data.value(forKey: "name") as! String
                let val_date = data.value(forKey: "date") as! String
                if (zipNameList[val_name + val_date as! String] == nil) {
                    deleteObjects.append(data)
                }
            }
            while deleteObjects.count > 0 {
                account?.removeFromFile(deleteObjects.popLast()!)
                save()
            }
                    
        } catch {
            print("Failed")
        }
        */
    }
    
    func showSimpleActionSheet() {
        
        let alert = UIAlertController(title: "Options", message: "Please Select an Option", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: {
            (_) in
                self.Refresh(false)
        }))
        
        alert.addAction(UIAlertAction(title: "FAQ", style: .default, handler: {
            (_) in
                if let url = URL(string: "https://labelbyte.com/faq/") { UIApplication.shared.open(url)}
        }))

        alert.addAction(UIAlertAction(title: "Download Label Data", style: .default, handler: { (_) in
                let data = self.downloadLabelFile()
                let activityViewController = UIActivityViewController(activityItems: [data],
                                             applicationActivities: nil)
                self.present(activityViewController, animated: true)}))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {
                (_) in
                print("User click Dismiss button")
        }))

        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
                print("User clicked Logout button")
                self.navigationController?.popViewController(animated: true)
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(Options))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(Upload))
        self.navigationItem.title = "Uploaded Zip Files"
        tableView.tableFooterView = UIView()
        
        
        recieveFormatZipNames()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCall()
    }
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let frc = fetchedResultsController {
            return frc.sections!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var completed = true
        for items in fetchedResultsController.fetchedObjects! {
            if (items as! ZipFile).completed == false {
                completed = false
            }
        }
        switch (completed) {
        case true:
            return "Complete"
        default:
            switch (section) {
            case 0:
                return "Incomplete"
            default:
                return "Complete"
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sections = self.fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        // Configure the cell...

        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let zipFile = object as! ZipFile
        cell.textLabel?.text = zipFile.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = DataTableView()
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let zipFile = object as! ZipFile
        VC.zipFileObject = zipFile
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func Refresh(_ ignore: Bool) {
        // Clear data and get latest server data
        /*
        if RefreshOperation.incrementToLimit() == false && ignore == false {
            // Defense Mechanism to excessive server requests
            // returns before calls to server and gives blocked message
            self.definesPresentationContext = true
            let vc = SuccessViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.message = "Blocked 300 Seconds"
            present(vc, animated: true, completion: nil)
            return
        }
        */
        recieveFormatZipNames()
        fetchCall()
        print("Refresh Occured")
    }
    
    @objc func Upload() {
        self.definesPresentationContext = true
        let vc = UploadViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        return
    }
    
    @objc func Options() {
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.navigationController?.popViewController(animated: true)
        showSimpleActionSheet()
    }

}

