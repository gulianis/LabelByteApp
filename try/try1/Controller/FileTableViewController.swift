//
//  FileTableViewController.swift
//  try
//
//  Created by Sandeep Guliani on 8/12/20.
//

import UIKit
import CoreData

class FileTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var account: Account?
    
    func save() {
        do {
            try self.context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchCall() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
        let sortByTitle = NSSortDescriptor(key: "completed", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortByTitle, sortByName]
        let predicate = NSPredicate(format: "ofAccount = %@", account!)
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: "completed", cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func recieveZipNameDict() -> [String: String] {
        var DictString = ""
        let semaphore = DispatchSemaphore(value: 0)
        GETZipNames() { output in
            DictString = output
            semaphore.signal()
        }
        semaphore.wait()
        let jsonData = DictString.data(using: .utf8)!
        let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
        //request.returnsObjectsAsFaults = false
        if let dictionary = jsonDictionary as? [String: String] {
            return dictionary
        }
        return [:]
    }
    
    func recieveFormatZipNames() {
        let dictionary = recieveZipNameDict()
        var zipNameList = [String: Int]()
        let count = Int(dictionary["Count"]!)!
        if count > 0 {
            for i in 0..<count {
                let zipName = dictionary["Data_" + String(i) + "_name"] ?? ""
                let finished = dictionary["Data_" + String(i) + "_saved"] ?? ""
                let Date = dictionary["Date"] ?? ""
                zipNameList[zipName + Date] = 1
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
                let predicateOne = NSPredicate(format: "name = %@", zipName)
                let predicateTwo = NSPredicate(format: "ofAccount = %@", account!)
                let predicateThree = NSPredicate(format: "date = %@", Date)
                request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo, predicateThree])
                do {
                    let results = try context.fetch(request)
                    switch (results.count) {
                        case 0:
                            let zipFile = ZipFile(context: self.context)
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
        print("ZIP NAME LIST:")
        print(zipNameList)
        do {
            let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
            let predicate = NSPredicate(format: "ofAccount= %@", account!)
            request2.predicate = predicate
            let result = try context.fetch(request2)
            var deleteObjects = [ZipFile]()
            for data in result as! [ZipFile] {
                //let val_name = (data.value(forKey: "name") ?? "") as! String
                //let val_date = (data.value(forKey: "date") ?? "") as! String
                let val_name = data.value(forKey: "name") as! String
                let val_date = data.value(forKey: "date") as! String
                print("TYPES:")
                print(val_name)
                print(val_date)
                print(val_name + val_date)
                if (zipNameList[val_name as! String + val_date as! String] == nil) {
                    print("OBJECT THAT GETS DELETED")
                    deleteObjects.append(data)
                }
                print("D")
            }
            while deleteObjects.count > 0 {
                //context.delete(deleteObjects.popLast()!)
                account?.removeFromFile(deleteObjects.popLast()!)
                save()
            }
                    
        } catch {
            print("Failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(Logout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(Refresh))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
        
        recieveFormatZipNames()
        fetchCall()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ZipFile")
        let predicate = NSPredicate(format: "ofAccount = %@", account!)
        request.predicate = predicate
        var completed = true
        do {
            let results = try context.fetch(request)
            for result in results {
                if ((result as! ZipFile).value(forKey: "completed") as! Bool) == false {
                    completed = false
                    break
                }
            }
        } catch {
            print("Failed")
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
    
    @objc func Refresh() {
        if block_refresh == true {
            self.definesPresentationContext = true
            let vc = SuccessViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.message = "Blocked 60 Seconds"
            present(vc, animated: true, completion: nil)
            return
        }
        let date = Date()
        let calendar = Calendar.current
        let current_year = calendar.component(.year, from:date)
        let current_day = calendar.component(.day, from:date)
        let current_hour = calendar.component(.hour, from: date)
        let current_minute = calendar.component(.minute, from: date)
        if current_year == year && current_day == day && current_hour == hour && current_minute == minute {
            date_count += 1
            if date_count > 5 {
                self.definesPresentationContext = true
                let vc = SuccessViewController()
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.message = "Blocked 60 Seconds"
                present(vc, animated: true, completion: nil)
                block_refresh = true
                blockRefresh()
                return
            }
        } else {
            date_count = 1
            year = current_year
            day = current_day
            hour = current_hour
            minute = current_minute
        }
        recieveFormatZipNames()
        fetchCall()
    }
    
    @objc func Logout() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
