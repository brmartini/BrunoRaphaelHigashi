//
//  StatesRegisterViewController.swift
//  BrunoRaphaelHigashi
//
//  Created by Bruno  Juliano Fernandes Martini on 18/04/17.
//  Copyright © 2017 Bruno  Juliano Fernandes Martini. All rights reserved.
//

import UIKit
import CoreData


enum ProductAlertType {
    case add
    case edit
}

enum SettingsType: String{
    
    case dolar = "dolar"
    case iof = "iof"
}

class StatesRegisterViewController: UIViewController {
    
    @IBOutlet weak var tfUstobrl: UITextField!
    @IBOutlet weak var tfIof: UITextField!
    @IBOutlet weak var tvStates: UITableView!
    var fetchedResultController: NSFetchedResultsController<States>!
    
    
    var state: States!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvStates.delegate = self
        tvStates.dataSource = self
        loadStates()
        // Do any additional setup after loading the view.
    }
    
    //add
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(tfUstobrl.text, forKey: SettingsType.dolar.rawValue)
        UserDefaults.standard.set(tfIof.text, forKey: SettingsType.iof.rawValue)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dolar = UserDefaults.standard.string(forKey: SettingsType.dolar.rawValue){
            tfUstobrl.text = dolar
        }
        
        if let iof = UserDefaults.standard.string(forKey: SettingsType.iof.rawValue){
            
            tfIof.text = iof
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    
   
    
    func loadStates(){
        
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do{
            
            try fetchedResultController.performFetch()
            fetchedResultController.delegate = self
            
            tvStates.reloadData()
        } catch {
            print(error.localizedDescription)
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
    @IBAction func addStateData(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
        
    }
    
    
    func showAlert(type: ProductAlertType, state: States?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Taxa do estado"
            if let tax = state?.tax {
                textField.text = String(tax)
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let state = state ?? States(context: self.context)
            state.name = alert.textFields?.first?.text
            state.tax = Double((alert.textFields?[1].text!)!)!
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension StatesRegisterViewController: UITableViewDelegate {
    
}


extension StatesRegisterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        let count = fetchedResultController.fetchedObjects!.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statecell", for: indexPath)
        
        let stateTaxTable = fetchedResultController.object(at: indexPath)
        cell.textLabel?.text = stateTaxTable.name
        cell.detailTextLabel?.text = String(stateTaxTable.tax)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            
            let state =  self.fetchedResultController.object(at: indexPath)
            
            
            context.delete(state)
            do{
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    
}

extension StatesRegisterViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tvStates.reloadData()
    }
}

