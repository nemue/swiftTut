//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Nele Müller on 28.03.18.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var meals = [Meal] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use edit button item provided by table view controller:
        navigationItem.leftBarButtonItem = editButtonItem
        
        // load data from user directory:
        if let savedMeals = loadMeals() {
            meals += savedMeals
        }
        else {
            // load sample data
            loadSampleMeals()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // section = visual grouping of cells -> here: only 1 ?? "no sender" needed
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell" // specified in storyboard
        // identifier tells dequeueReusableCell which kind of cell to use
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            // as? -> typecast, returns optional -> guard to safely unwrap
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // .dequeueReusableCell (...) requests a cell from table view
        // if no cell available -> instantiates new one, otherwise, reuses old one
        
        // fetches appropriate meal for the data source layout:
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController
                else {
                    fatalError("Unexpected destination: \(segue.destination).")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell
                else {
                    fatalError("Unexpected sender: \(sender ?? "no sender").")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell)
                else {
                    fatalError("The selected cell is not displayed by the table.")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier \(segue.identifier ?? "no identifier")")
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow { // if row in table view is selected -> editing meal
                
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                
            } else { // add a new meal:
                
                let newIndexPath = IndexPath(row: meals.count, section: 0)  // location where new meal will be inserted in table view
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            
            // save the meals:
            saveMeals()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadSampleMeals(){
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1.")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2.")
        }

        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3.")
        }
        
        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals() {
        // attempts to archive the meals array to a specific location, and returns true if it’s successful:
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save meals ...", log: OSLog.default, type: .debug)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }

}
