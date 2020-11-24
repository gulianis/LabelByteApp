//
//  ImageTableViewController.swift
//  try
//
//  Created by Sandeep Guliani on 8/4/20.
//

import UIKit
import CoreData

class DataTableView: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var account: Account?
    
    var zipFileObject: ZipFile?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        // Only Call if never been accessed before
        // Images in a zip file can never change
        if zipFileObject!.clicked == false {
            imageNames()
        }
        zipFileObject!.clicked = true
        save()
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
            return frc.sections!.count
        }
        return 0
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Categorizes into has been labeled or not
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
        // Number of image calls left
        cell.detailTextLabel?.text = String(10 - image.clicked_count)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = ImageViewController()
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let image = object as! Data
        // Check Core Data to see if image has been accessed less than 10 times
        // Mechanism to limit server requests
        if image.clicked_count < 10 {
            // Update image count with server count
            // Only push new view if image has been accessed less than 10 times
            let count = Int(CallImageRequestCount(image.name!))
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
