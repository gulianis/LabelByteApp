//
//  ImageTableViewController.swift
//  try
//
//  Created by Sandeep Guliani on 8/4/20.
//

import UIKit
import CoreData

/*
struct ImageItem {
    var name:String
    var saved:Bool
}
*/

//var zipFileName = ""

class DataTableView: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var account: Account?
    
    var zipFileObject: ZipFile?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var labelType = ""
    
    func save() {
        do {
            try self.context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchCall() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        let sortByTitle = NSSortDescriptor(key: "saved", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortByTitle, sortByName]
        let predicate = NSPredicate(format: "ofZipFile == %@", zipFileObject!)
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: "saved", cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func recieveImageNameDict(_ name: String) -> [String: String] {
        var DictString = ""
        let semaphore = DispatchSemaphore(value: 0)
        RecieveImageNames(name) { output in
            DictString = output
            semaphore.signal()
        }
        semaphore.wait()
        let jsonData = DictString.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
        if let dataDictionary = dictionary as? [String: String] {
            return dataDictionary
        }
        return [:]
        
    }
    
    func imageNames() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        let dataDictionary = recieveImageNameDict(zipFileObject!.name!)
        for (imageName, saved) in dataDictionary {
            let image = Data(context: context)
            image.name = imageName
            image.saved = false
            image.clicked_count = 0
            zipFileObject!.addToFile(image)
            zipFileObject!.unsaved_data_count += 1
            save()
        }
    }
    
    func CallImageRequestCount(_ imageName: String) -> Int {
        var result = ""
        let semaphore = DispatchSemaphore(value: 0)
        ImageRequestCount(zipFileObject!.name!, imageName) { output in
            result = output
            semaphore.signal()
        }
        semaphore.wait()
        let jsonData = result.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
        if let Data = dictionary as? [String: Int] {
            return Data["result"]!
        }
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        if zipFileObject!.clicked == false {
            imageNames()
        }
        zipFileObject!.clicked = true
        save()
        //imageNameList = imageNames()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCall()
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let frc = fetchedResultsController {
            print(frc.sections!.count)
            return frc.sections!.count
        }
        return 0
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (zipFileObject!.unsaved_data_count) {
            case 0:
                return "Labeled"
            default:
                switch (section) {
                    case 0:
                        return "UnLabeled"
                    default:
                        return "Labeled"
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        // Configure the cell...
        cell = UITableViewCell(style: .value1, reuseIdentifier: "cellId")
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let image = object as! Data
        cell.textLabel?.text = image.name
        cell.detailTextLabel?.text = String(10 - image.clicked_count)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = ImageViewController()
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let image = object as! Data
        print("WE REACHED")
        if image.clicked_count < 10 {
            let count = Int(CallImageRequestCount(image.name!))
            print("HERE IS COUNT:")
            image.clicked_count = Int16(count)
            print(count)
            save()
            print(image.clicked_count)
            if image.clicked_count < 10 {
                image.clicked_count += 1
                save()
                VC.imageData = image
                self.navigationController?.pushViewController(VC, animated: true)
            } else {
                self.definesPresentationContext = true
                let vc = SuccessViewController()
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.message = "Reached Access Limit"
                present(vc, animated: true, completion: nil)
                tableView.reloadData()
            }
        } else {
            self.definesPresentationContext = true
            let vc = SuccessViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.message = "Reached Access Limit"
            present(vc, animated: true, completion: nil)
            tableView.reloadData()
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = dataList[indexPath.row]

        return cell
    }
    */
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
