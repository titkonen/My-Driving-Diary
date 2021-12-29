import UIKit

protocol NoteDelegate {
    func saveNewNote(
        timestamp: Date,
        endingPlace: String,
        startingPlace: String,
        startingKm: String,
        distanceKm: String,
        endingKm: String,
        driveDescription: String
    )
}

class NoteDetailController: UIViewController {
    
    // MARK: Properties
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY hh:mm"
        return dateFormatter
    }()
    
    var noteData: Note! {
        didSet {
            dateLabel.text = dateFormatter.string(from: noteData.timestamp ?? Date())
            endingPlace.text = noteData.endingPlace
            startingPlace.text = noteData.startingPlace
            startingKm.text = noteData.startingKm
            distanceKm.text = noteData.distanceKm
            endingKm.text = noteData.endingKm
            driveDescription.text = noteData.driveDescription
        }
    }
    
    var delegate: NoteDelegate?
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        label.text = dateFormatter.string(from: Date())
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var endingPlace: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 10, y: 10, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Route ending place"
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var startingPlace: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 10, y: 10, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Route starting place"
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var startingKm: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 10, y: 10, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Starting Km"
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var distanceKm: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 10, y: 10, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Total Distance"
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var endingKm: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 10, y: 10, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Ending Km"
        textField.textColor = .black
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate var driveDescription: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Drive description"
        textField.isEditable = true
        textField.textColor = .gray
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.isSelectable = true
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
        
        if self.noteData == nil {
            delegate?.saveNewNote(
                timestamp: Date(),
                endingPlace: endingPlace.text ?? "Route ending place",
                startingPlace: startingPlace.text ?? "Route starting place",
                startingKm: startingKm.text ?? "Starting Km",
                distanceKm: distanceKm.text ?? "Total Distance",
                endingKm: endingKm.text ?? "Ending Km",
                driveDescription: driveDescription.text
            )
        } else {
            /// updates title text
            guard let newEndingPlace = self.endingPlace.text else {
                return
            }
            /// Updates Description text
            guard let newStartingPlace = self.startingPlace.text else {
                return
            }
            
            /// Updates Jobtitle text
            guard let newStartingKm = self.startingKm.text else {
                return
            }

            /// Updates email text
            guard let newDistanceKm = self.distanceKm.text else {
                return
            }
            
            /// Updates phoneNumber text
            guard let newEndingKm = self.endingKm.text else {
                return
            }
            
            /// Updates phoneNumber text
            guard let newDriveDescription = self.driveDescription.text else {
                return
            }
            
            CoreDataManager.shared.saveUpdatedNote(
                note: self.noteData,
                newEndingPlace: newEndingPlace,
                newStartingPlace: newStartingPlace,
                newStartingKm: newStartingKm,
                newDistanceKm: newDistanceKm,
                newEndingKm: newEndingKm,
                newDriveDescription: newDriveDescription
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let items: [UIBarButtonItem] = [
////            UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil),
////            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
////            UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil),
////            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
////            UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil),
////            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
////            UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil),
////            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
////            UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
//        ]
//
//        self.toolbarItems = items
//
//        let topItems: [UIBarButtonItem] = [
//            UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil),
//            UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
//        ]
//
//        self.navigationItem.setRightBarButtonItems(topItems, animated: false)
    }
    
    // MARK: Functions
    fileprivate func setupUI() {
        view.addSubview(dateLabel)
        view.addSubview(endingPlace)
        view.addSubview(startingPlace)
        view.addSubview(startingKm)
        view.addSubview(distanceKm)
        view.addSubview(endingKm)
        view.addSubview(driveDescription)
        
        dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        endingPlace.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        endingPlace.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        endingPlace.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        endingPlace.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -720).isActive = true
        
        startingPlace.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        startingPlace.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        startingPlace.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        startingPlace.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -660).isActive = true
    
        startingKm.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        startingKm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        startingKm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        startingKm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -610).isActive = true
  
        distanceKm.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        distanceKm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        distanceKm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        distanceKm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -560).isActive = true
  
        endingKm.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
        endingKm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        endingKm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        endingKm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -510).isActive = true
  
        driveDescription.topAnchor.constraint(equalTo: view.topAnchor, constant: 420).isActive = true
        driveDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        driveDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        driveDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -310).isActive = true
    }

}
