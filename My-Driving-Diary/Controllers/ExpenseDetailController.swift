import UIKit

protocol ExpenseDelegate {
    func saveNewExpense(
        timestamp: Date,
        amount: String,
        expenseType: String,
        details: String
    )
}

class ExpenseDetailController: UIViewController {
    
    // MARK: Properties
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY hh:mm"
        return dateFormatter
    }()

    var expenseData: Expense! {
        didSet {
            dateLabel.text = dateFormatter.string(from: expenseData.timestamp ?? Date())
            amount.text = expenseData.amount
            expenseType.text = expenseData.expenseType
            details.text = expenseData.details
        }
    }
    
    var delegate: ExpenseDelegate?
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.text = dateFormatter.string(from: Date())
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var amount: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 10, y: 10, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Amount of Expense"
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var expenseType: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 10, y: 10, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type of Expense"
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var details: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 10, y: 10, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Details of Expense"
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.expenseData == nil {
            delegate?.saveNewExpense(
                timestamp: Date(),
                amount: amount.text ?? "Amount of Expense",
                expenseType: expenseType.text ?? "Type of Expense",
                details: details.text ?? "Details of Expense"
            )
        } else {
            /// Amount
            guard let newAmount = self.amount.text else {
                return
            }
            /// ExpenseType
            guard let newExpenseType = self.expenseType.text else {
                return
            }
            
            /// Details
            guard let newDetails = self.details.text else {
                return
            }

            CoreDataManager.shared.saveUpdatedExpense(
                expense: self.expenseData,
                newAmount: newAmount,
                newExpenseType: newExpenseType,
                newDetails: newDetails
            )
        }
    }
    
    // MARK: Functions
    fileprivate func setupUI() {
        view.addSubview(dateLabel)
        view.addSubview(amount)
        view.addSubview(expenseType)
        view.addSubview(details)
        
        dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        amount.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        amount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        amount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        amount.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -710).isActive = true
        
        expenseType.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        expenseType.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        expenseType.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        expenseType.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -660).isActive = true
    
        details.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        details.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        details.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        details.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -610).isActive = true
  
    }

}
