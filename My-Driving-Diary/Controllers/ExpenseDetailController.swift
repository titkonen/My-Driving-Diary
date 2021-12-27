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
    
    // MARK: Photo Properties
    var image: UIImage? /// Adding photo properties
    ///
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        label.text = dateFormatter.string(from: Date())
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var amount: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "amount"
        textField.isEditable = true
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        textField.isSelectable = true
        textField.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var expenseType: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "expenseType"
        textField.isEditable = true
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        textField.isSelectable = true
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var details: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "details"
        textField.isEditable = true
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        textField.isSelectable = true
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var myImageView: UIImageView = {
        let photobox = UIImageView()
        photobox.frame = CGRect(x: 20, y: 360, width: 300, height: 200)
        photobox.backgroundColor = .lightGray
        return photobox
    }()
    
    fileprivate var loadPhoto: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.frame = CGRect(x: 20, y: 300, width: 100, height: 40)
        button.setTitle("Load Photo", for: .normal)
        button.addTarget(self, action: #selector(loadPhotoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    fileprivate var savePhoto: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.frame = CGRect(x: 160, y: 300, width: 100, height: 40)
        button.setTitle("Save Photo", for: .normal)
        button.addTarget(self, action: #selector(savePhotoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        //Encoding
        let image = UIImage(named: "placeholder")
        let imageData:NSData = image!.pngData()! as NSData
        
        //Saved Image
        UserDefaults.standard.set(imageData, forKey: "savedImage")
        
        // Decode
        let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
        myImageView.image = UIImage(data: data as Data)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.expenseData == nil {
            delegate?.saveNewExpense(
                timestamp: Date(),
                amount: amount.text,
                expenseType: expenseType.text,
                details: details.text
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
    
    // MARK: Photo functions
    func show(image: UIImage) {
        myImageView.image = image
        myImageView.isHidden = false
      //addPhotoLabel.text = ""
        //imageHeight.constant = 260
        //tableView.reloadData()
    }
    
    @objc func loadPhotoButtonPressed() {
        pickPhoto()
    }
    
    @objc func savePhotoButtonPressed() {
        print("Save pressed")
    }
    
    
    
    // MARK: Functions
    fileprivate func setupUI() {
        view.addSubview(dateLabel)
        view.addSubview(amount)
        view.addSubview(expenseType)
        view.addSubview(details)
        view.addSubview(myImageView)
        view.addSubview(loadPhoto)
        view.addSubview(savePhoto)
        
        dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        amount.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        amount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        amount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        amount.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -720).isActive = true
        
        expenseType.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        expenseType.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        expenseType.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        expenseType.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -660).isActive = true
    
        details.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        details.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        details.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        details.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -610).isActive = true
    }

} // END

// MARK: EXTENSION FOR ADDING PHOTOS
extension ExpenseDetailController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK: - Image Helper Methods
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        showPhotoMenu()
      } else {
        choosePhotoFromLibrary()
      }
    }

    func showPhotoMenu() {
      let alert = UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: .actionSheet)

      let actCancel = UIAlertAction(
        title: "Cancel",
        style: .cancel,
        handler: nil)
      alert.addAction(actCancel)

      let actPhoto = UIAlertAction(
        title: "Take Photo",
        style: .default) { _ in
        self.takePhotoWithCamera()
      }
        
      alert.addAction(actPhoto)

      let actLibrary = UIAlertAction(
        title: "Choose From Library",
        style: .default) { _ in
          self.choosePhotoFromLibrary()
        }
      alert.addAction(actLibrary)

      present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Delegates
    ///This is for showing photo in view
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
          if let theImage = image {
            show(image: theImage) /// Calls show photo function
          }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


