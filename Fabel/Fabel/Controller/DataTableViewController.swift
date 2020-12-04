//
//  ImageTableViewController.swift
//  try
//
//  Created by Sachin Guliani on 8/4/20.
//

import UIKit
import CoreData

// class DataTableView: UITableViewController, NSFetchedResultsControllerDelegate
class DataTableView: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var objectListUnSaved = [Data]()
    //var objectListSaved = [Data]()
    
    //var objectListUnSaved = [String]()
    //var objectListSaved = [String]()
    
    var account: Account?
    
    var zipFileObject: ZipFile?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    
    /*
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        let sortByTitle = NSSortDescriptor(key: "saved", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortByTitle, sortByName]
        let predicate = NSPredicate(format: "ofZipFile == %@", zipFileObject!)
        fetchRequest.predicate = predicate
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "saved", cacheName: nil)
        frc.delegate = self
        return frc
    }()
    */
    deinit {
        print("Data View DeAllocated")
    }
    
    func save() {
        // Save to Core Data
        do {
            try self.context.save()
        } catch {
            print("Failed saving")
        }
    }
    func fetchCall() {
        // Load Image Names for current account
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        let sortByTitle = NSSortDescriptor(key: "saved", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortByTitle, sortByName]
        let predicate = NSPredicate(format: "ofZipFile == %@", zipFileObject!)
        //let predicate = NSPredicate(format: "ofZipFile.name == %@", zipName!)
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "saved", cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }

    /*
    func otherFetch() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        let sortByTitle = NSSortDescriptor(key: "saved", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortByTitle, sortByName]
        let predicate = NSPredicate(format: "ofZipFile == %@", zipFileObject!)
        fetchRequest.predicate = predicate
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            for item in fetchedResults {
                if (item as! Data).saved == true {
                    objectListSaved.append(item as! Data)
                } else {
                    objectListUnSaved.append(item as! Data)
                }
            }
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
    }
    */
    func recieveImageNameDict(_ name: String) -> [String: String] {
        // Gets Image Names from server
        var DictString = ""
        // Uses semaphore to wait for network call till data recieved
        let semaphore = DispatchSemaphore(value: 0)
        RecieveImageNames(name) { output in
            DictString = output
            semaphore.signal()
        }
        semaphore.wait()
        // Converts DictString to usable format
        let jsonData = DictString.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
        if let dataDictionary = dictionary as? [String: String] {
            return dataDictionary
        }
        return [:]
        
    }
    
    func imageNames() {
        // Saves image names to Core Data
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
        // Gets Image Count from server
        let semaphore = DispatchSemaphore(value: 0)
        // Uses semaphore to wait for network call till data recieved
        ImageRequestCount(zipFileObject!.name!, imageName) { output in
            result = output
            semaphore.signal()
        }
        semaphore.wait()
        // Converts DictString to usable format
        let jsonData = result.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
        if let Data = dictionary as? [String: Int] {
            return Data["result"]!
        }
        return 0
    }
    /*
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
 
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        

        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        // Only Call if never been accessed before
        // Images in a zip file can never change
        tableView.tableFooterView = UIView()
        //imageNames()
        if zipFileObject!.clicked == false {
            imageNames()
        }
        zipFileObject!.clicked = true
        save()
        //clearCache()
        //otherFetch()

    }
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //context.refreshObject(managedObject, mergeChanges: false)
        //context.reset()
        //fetchCall()
        //tableView.reloadData()
        /*
        var index = [Int]()
        for i in 0...(objectListUnSaved.count-1) {
            if (objectListUnSaved[i].saved == true) {
                index.append(i)
            }
        }
        for i in index {
            //tableView
            let first = IndexPath(row: i, section: 0)
            let second = IndexPath(row: objectListSaved.count - 1, section: 1)
            tableView.beginUpdates()
            print(tableView.numberOfSections)
            print(tableView.numberOfRows(inSection: 0))
            print(tableView.numberOfRows(inSection: 1))
            objectListSaved.append(objectListUnSaved.remove(at: i))
            tableView.moveRow(at: first, to: second)
            //tableView.deleteRows(at: [first], with: .fade)
            //tableView.insertRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
            tableView.endUpdates()
            tableView.deselectRow(at: second, animated: false)
        }
        //tableView.reloadData()
        didReceiveMemoryWarning()
        */
        fetchCall()
        clearCache()
        //tableView.reloadData()
    }

    /*
    override func viewDidAppear(_ animated: Bool) {
        /*
        super.viewDidAppear(animated)
        var index = [Int]()
        for i in 0...(objectListUnSaved.count-1) {
            if (objectListUnSaved[i].saved == true) {
                index.append(i)
            }
        }
        */
        /*
        for i in index {
            //tableView
            let first = IndexPath(row: i, section: 0)
            let second = IndexPath(row: 0, section: 1)
            tableView.beginUpdates()
            print(tableView.numberOfSections)
            print(tableView.numberOfRows(inSection: 0))
            print(tableView.numberOfRows(inSection: 1))
            objectListSaved.append(objectListUnSaved.remove(at: i))
            tableView.moveRow(at: first, to: second)
            //tableView.deleteRows(at: [first], with: .fade)
            //tableView.insertRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
            tableView.endUpdates()
            tableView.deselectRow(at: second, animated: false)
        }
        */
        //tableView.reloadData()
        //fetchCall()
    }
    */

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let frc = fetchedResultsController {
            return frc.sections!.count
        }
        return 0
        //return 2
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Categorizes into has been labeled or not
        /*
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
        */
        /*
        switch(section) {
        case 0:
            return "UnLabeled"
        default:
            return "Labeled"
        }
        */
        switch (zipFileObject?.completed) {
        case true:
            return "Labeled"
        default:
            switch (section) {
            case 0:
                return "UnLabeled"
            default:
                return "Labeled"
            }
        }
        //return "UnLabeled"
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sections = self.fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
        /*
        switch(section) {
        case 0:
            return objectListUnSaved.count
        default:
            return objectListSaved.count
        }
        */
        //return objectListUnSaved.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = tableView.dequeueReusableCell(style: UITableViewCell.CellStyle, withIdentifier: "cellId", for: indexPath)
        // Configure the cell...
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let image = object as! Data
        cell.textLabel?.text = image.name
        print(image.clicked_count)
        cell.detailTextLabel?.text = String(10 - image.clicked_count)
        print(cell.detailTextLabel?.text)
        */
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") else {
                return UITableViewCell(style: .value1, reuseIdentifier: "cellId")
                    }
                    return cell
                }()
        // At this point, we definitely have a cell -- either dequeued or newly created,
        // so let's force unwrap the optional into a UITableViewCell
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let image = object as! Data
        cell.textLabel?.text = image.name
        cell.detailTextLabel?.text = String(10 - image.clicked_count)

        return cell
        /*
        if indexPath < objectListUnSaved.count {
            cell.textLabel?.text = objectListUnSaved[indexPath].name
            cell.detailTextLabel?.text = String(10 - image.clicked_count)
        }
        cell.textLabel?.text = image.name
        // Number of image calls left
        cell.detailTextLabel?.text = String(10 - image.clicked_count)
        */
        /*
        switch (indexPath.section) {
        case 0:
            cell.textLabel?.text = objectListUnSaved[indexPath.row].name
            cell.detailTextLabel?.text = String(10 - objectListUnSaved[indexPath.row].clicked_count)
        default:
            cell.textLabel?.text = objectListSaved[indexPath.row].name
            cell.detailTextLabel?.text = String(10 - objectListSaved[indexPath.row].clicked_count)
        }
        */
        //cell.textLabel?.text = objectListUnSaved[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = ImageViewController()
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        /*
        var image: Data
        switch (indexPath.section) {
        case 0:
            image = objectListUnSaved[indexPath.row]
        default:
            image = objectListSaved[indexPath.row]
        }
        */
        // Check Core Data to see if image has been accessed less than 10 times
        // Mechanism to limit server requests
        let image = object as! Data
        if image.clicked_count < 10 {
            // Update image count with server count
            // Only push new view if image has been accessed less than 10 times
            let count = Int(CallImageRequestCount(image.name!))
            //let count = 7
            image.clicked_count = Int16(count)
            save()
            if image.clicked_count < 10 {
                image.clicked_count += 1
                save()
                VC.imageData = image
                self.navigationController?.pushViewController(VC, animated: true)
            } else {
                showLimitView()
            }
        } else {
            showLimitView()
        }
    }
    
    func showLimitView() {
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
extension DataTableView: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            self.tableView.insertRows(at: [indexPath!], with: .fade)
        }
    }


    func controller(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>, didChange
        sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex
        sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch (type) {
        case .insert:
            self.tableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            self.tableView.deleteSections([sectionIndex], with: .fade)
        case .move:
            self.tableView.deleteSections([sectionIndex], with: .fade)
            self.tableView.insertSections([sectionIndex], with: .fade)
        case .update:
            self.tableView.reloadSections([sectionIndex], with: .fade)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension DataTableView {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }

        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        configureCell(cell, at: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pet = fetchedResultsController.object(at: indexPath)

    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            //let user = viewModel.user(for: indexPath.row)
            let dataStuff = fetchedResultsController.object(at: indexPath)
            //Delete pet and reload table
        }
    }

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let pet = fetchedResultsController.object(at: indexPath)
    }
}
*/
