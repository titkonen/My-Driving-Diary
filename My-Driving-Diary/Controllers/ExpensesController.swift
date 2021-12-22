import UIKit

class ExpensesController: UITableViewController, UISearchBarDelegate {

    // MARK: Properties
    let searchController = UISearchController(searchResultsController: nil)
    fileprivate var expenses = [Expense]()
    fileprivate var filteredExpenses = [Expense]()
    var cachedText: String = ""
    fileprivate let CELL_ID:String = "CELL_ID"
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Expenses"
        view.backgroundColor = .white
        setupTableView()
        setupExpenseSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.createNewExpense))
        let numberOfEntries = UIBarButtonItem(title: "\(expenses.count) Entries", style: .done, target: nil, action: nil)
        self.navigationItem.setRightBarButtonItems([editButton, numberOfEntries], animated: false)
        
        tableView.reloadData()
    }
    
    // MARK: Functions
    fileprivate func setupExpenseSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true /// true
        searchController.searchBar.delegate = self ///as! UISearchBarDelegate
    }
    
    @objc fileprivate func createNewExpense() {
        let expenseDetailController = ExpenseDetailController()
        expenseDetailController.delegate = self
        navigationController?.pushViewController(expenseDetailController, animated: true)
    }
    
    fileprivate func setupTableView() {
        tableView.register(ExpenseCell.self, forCellReuseIdentifier: CELL_ID)
    }
    
    // MARK: SEARCH: FILTERING DATA
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredExpenses = expenses.filter({ (expense) -> Bool in
            return expense.expenseType?.lowercased().contains(searchText.lowercased()) ?? false
        })
        if searchBar.text!.isEmpty && filteredExpenses.isEmpty {
            filteredExpenses = expenses
        }
        cachedText = searchText
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !cachedText.isEmpty && !filteredExpenses.isEmpty {
            searchController.searchBar.text = cachedText
        }
    }
        
} ///END

// MARK: EXTENSION TableView Data Source
extension ExpensesController {
    
    // MARK: Deleting
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            print("trying to delete item at indexpath", indexPath)
            
            let targetRow = indexPath.row
            
            if CoreDataManager.shared.deleteExpense(expense: self.expenses[targetRow]) {
                self.expenses.remove(at: targetRow)
                self.filteredExpenses.remove(at: targetRow)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } /// Deletes from Core Data
        }
        actions.append(deleteAction)
        return actions
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredExpenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ExpenseCell ///Casting =>  as! ExpenseCell  to custom cell
        let noteForRow = self.expenses[indexPath.row]
        cell.expenseData = noteForRow
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    ///Push content to ExpenseDetailController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expenseDetailController = ExpenseDetailController()
        let noteForRow = self.expenses[indexPath.row]
        expenseDetailController.expenseData = noteForRow
        navigationController?.pushViewController(expenseDetailController, animated: true)
    }
}

// MARK: EXTENSION ExpenseDelegate
extension ExpensesController: ExpenseDelegate {
    func saveNewExpense(
        timestamp: Date,
        amount: String,
        expenseType: String,
        details: String
        ) {
        let newExpense = CoreDataManager.shared.createNewExpense(
            timestamp: timestamp,
            amount: amount,
            expenseType: expenseType,
            details: details
        ) ///Creates new expense to the list and coredata
        expenses.append(newExpense)
        filteredExpenses.append(newExpense)
        self.tableView.insertRows(at: [IndexPath(row: expenses.count - 1, section: 0)], with: .fade)
    }
}
