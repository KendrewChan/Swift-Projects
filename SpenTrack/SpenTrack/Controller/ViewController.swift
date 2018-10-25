//
//  ViewController.swift
//  SpenTrack
//
//  Created by Kendrew Chan on 15/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    // currentGoals -> reset monthlySpending every month
    
    var controller: NSFetchedResultsController<Item>!
    var monthlySpending: Double = 0
    var resetted = false
    var savedDate = Date()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createTestData()
        
        self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.automatic
        
        tableView.delegate = self
        tableView.dataSource = self
        let tableHeight: CGFloat = 50
        tableView.rowHeight = tableHeight
        tableView.sectionHeaderHeight = tableHeight
        
        initialFetch()
        updateTitle()
        
        resetDataAtStartOfMonth()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateTitle()
        initialFetch()
        
        tableView.reloadData()
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) { //redirect to 'View' to fetch the 'titleLabel'
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    } // configures each cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let objs = controller.fetchedObjects, objs.count > 0 {
//            let item = objs[indexPath.row]
//            performSegue(withIdentifier: "TrackerVC", sender: item)
//        } // fetches objects following the exact order of 'controller.fetchedObjects', but indexPath resets in each new section
        let row = indexPath.row
        let section = indexPath.section
        print("Section: " + "\(section)" + "Row: " + "\(row)")
        let item = controller.object(at: indexPath) // the only way to obtain the row after it has been separated by sections using 'sectionNameKeyPath'
        print(item)
        performSegue(withIdentifier: "TrackerVC", sender: item)
    } // fetches objects following order of 'controller.fetchedObjects', but indexPath does not reset for each new sections
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TrackerVC" {
            if let destination = segue.destination as? TrackerVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = controller.object(at: indexPath)
            context.delete(item)
            ad.saveContext()
            updateTitle()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sections = controller.sections else {
                        fatalError("No sections in fetchedResultsController")
                    }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yy"
        let currentDate = dateFormatter.date(from: sections[section].name)

        dateFormatter.dateFormat = "mm-dd-yy"
        let convertedDateString = dateFormatter.string(from: currentDate!)

        let label = UILabel()
        label.text = "  " + convertedDateString
        label.backgroundColor = UIColor(red: 243/255, green: 176/255, blue: 90/255, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 20)

        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = controller.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section] // 'section' refers to the indexPath
        return sectionInfo.numberOfObjects
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "edited", ascending: false), NSSortDescriptor(key: "dailySpending", ascending: false)] //sorting according to date
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "edited", cacheName: nil)

        controller.delegate = self
        
        self.controller = controller
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func updateTitle() {
        monthlySpending = 0.0
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            let items = results as [Item]
            for i in items {
                monthlySpending += Double(String(format: "%.2f", i.dailySpending))!
            }
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationItem.title = "Spent: $\(monthlySpending)"
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) { //controller of tableView, to add, delete, move(switch places) & update the instances by fetching data from the PersistentStore
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                //update cell data by clicking
            }
            break
        }
    }
    // animation for deletion of sections
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
    }
    
    func resetDataAtStartOfMonth() {
        print("trying Reset trying Reset trying Reset trying Reset trying Reset trying Reset")
        //Here I’m creating the calendar instance that we will operate with:
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        //Now asking the calendar what month are we in today’s date:
        let currentMonthInt = (calendar?.component(NSCalendar.Unit.month, from: Date()))!
        let savedDate = UserDefaults.standard.object(forKey: "savedDate") as? Int
        
        if savedDate != currentMonthInt {
            UserDefaults.standard.set(currentMonthInt, forKey: "savedDate")
            
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            
            do {
                let results = try context.fetch(fetchRequest)
                let items = results as [Item]
                for i in items {
                    context.delete(i)
                    ad.saveContext()
                }
            } catch {
                fatalError("Failed to fetch entities: \(error)")
            }
            
        }
    }
    
    func createTestData() {
        let item = Item(context: context)
        item.edited = "06/01/18"
        item.dailySpending = 6.2
        item.spentText = "Lunch"
        
        let item2 = Item(context: context)
        item2.edited = "06/02/18"
        item2.dailySpending = 125
        item2.spentText = "Ultility bills"
        
        let item3 = Item(context: context)
        item3.edited = "06/01/18"
        item3.dailySpending = 5.5
        item3.spentText = "Dinner"
        
        let item4 = Item(context: context)
        item4.edited = "06/02/18"
        item4.dailySpending = 25
        item4.spentText = "Children's Toys"
        
        ad.saveContext()
    }
    
}
