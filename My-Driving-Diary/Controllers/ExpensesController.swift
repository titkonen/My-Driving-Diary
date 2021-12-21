import UIKit

class ExpensesController: UITableViewController {

    // MARK: Properties
    fileprivate var expenses = [Expense]()
    var cachedText: String = ""
    fileprivate let CELL_ID:String = "CELL_ID"
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Expenses"
        view.backgroundColor = .white
        setupTableView()
        //setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.createNewExpense))
        self.navigationItem.setRightBarButtonItems([editButton], animated: false)
        
        tableView.reloadData()
    }
    
    // MARK: Functions
    fileprivate func setupTableView() {
        tableView.register(ExpenseCell.self, forCellReuseIdentifier: CELL_ID)
    }
    
    @objc fileprivate func createNewExpense() {
        let expenseDetailController = ExpenseDetailController()
        expenseDetailController.delegate = self
        navigationController?.pushViewController(expenseDetailController, animated: true)
    }
        
}

// MARK: EXTENSION TableView Data Source
extension ExpensesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ExpenseCell ///Casting =>  as! ExpenseCell  to custom cell
        
        let noteForRow = self.expenses[indexPath.row]
        cell.expenseData = noteForRow
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
        //filteredNotes.append(newNote)
        self.tableView.insertRows(at: [IndexPath(row: expenses.count - 1, section: 0)], with: .fade)
    }
}
