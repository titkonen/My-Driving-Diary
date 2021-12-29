import CoreData

struct CoreDataManager {
    
    // MARK: PROPERTIES
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Driving-Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of stores failed \(err)")
            }
        })
        return container
    }()
    
    // MARK: Save Image
    func saveImage(data: Data) {
        let context = persistentContainer.viewContext
        let imageInstance = Expense(context: context)
        imageInstance.storedImage = data
        
        do {
            try context.save()
            print("Image is saved")
        } catch let error {
            print("Failed to save image", error)
        }
    }
    
    // MARK: Fetch Image
    func fetchImage() -> [Expense] {
        let context = persistentContainer.viewContext
        var fetchingImage = [Expense]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        
        do {
            fetchingImage = try context.fetch(fetchRequest) as! [Expense]
        } catch {
            print("Error while fetching the image")
        }
        return fetchingImage
    }
    
    // MARK: SINGLE NOTE FUNCTIONS
    // MARK: Create New Note
    func createNewNote(
        timestamp: Date,
        endingPlace: String,
        startingPlace: String,
        startingKm: String,
        distanceKm: String,
        endingKm: String,
        driveDescription: String) -> Note {
        //noteFolder: ClientsCategory) -> Note {
        let context = persistentContainer.viewContext
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        newNote.timestamp = timestamp
        newNote.endingPlace = endingPlace
        newNote.startingPlace = startingPlace
        newNote.startingKm = startingKm
        newNote.distanceKm = distanceKm
        newNote.endingKm = endingKm
        newNote.driveDescription = driveDescription
        
        do {
            try context.save()
            return newNote
        } catch let err {
            print("Failed to save new note", err)
          return newNote
        }
    }
    
    // MARK: Fetch Notes
    func fetchNotes(from noteFolder: ClientsCategory) -> [Note] {
        guard let folderNotes = noteFolder.notes?.allObjects as? [Note] else {
            return []
        }
        return folderNotes
    }
    
    // MARK: Delete notes
    func deleteNote(note: Note) -> Bool {
        let context = persistentContainer.viewContext
        context.delete(note)
        
        do {
            try context.save()
            return true
        } catch let err {
            print("Error deleting note entity instance", err)
            return false
        }
    }
    
    // MARK: Update notes
    func saveUpdatedNote(
        note: Note,
        newEndingPlace: String,
        newStartingPlace: String,
        newStartingKm: String,
        newDistanceKm: String,
        newEndingKm: String,
        newDriveDescription: String
    ) {
        let context = persistentContainer.viewContext
        
        note.timestamp = Date()
        note.endingPlace = newEndingPlace
        note.startingPlace = newStartingPlace
        note.startingKm = newStartingKm
        note.distanceKm = newDistanceKm
        note.endingKm = newEndingKm
        note.driveDescription = newDriveDescription
        
        do {
            try context.save()
        } catch let err {
            print("Failed to update note", err)
        }
    }
    
    // MARK: Create New Expense
    func createNewExpense(
        timestamp: Date,
        amount: String,
        expenseType: String,
        details: String,
        storedImage: Data
    ) -> Expense {
        //noteFolder: ClientsCategory) -> Note {
        let context = persistentContainer.viewContext
        let newExpense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context) as! Expense
        
        newExpense.timestamp = timestamp
        newExpense.amount = amount
        newExpense.expenseType = expenseType
        newExpense.details = details
        newExpense.storedImage = storedImage
        
        do {
            try context.save()
            return newExpense
        } catch let error {
            print("Failed to save new expense", error)
          return newExpense
        }
    }
    
    // MARK: Fetch expenses
    func fetchExpenses() -> [Expense] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Expense>(entityName: "Expense")
        
        do {
            let noteFolders = try context.fetch(fetchRequest)
            return noteFolders
        } catch let error {
            print("Failed to fetch expenses",error)
            return []
        }
    }
    
    // MARK: Delete expense
    func deleteExpense(expense: Expense) -> Bool {
        let context = persistentContainer.viewContext
        context.delete(expense)
        
        do {
            try context.save()
            return true
        } catch let error {
            print("Error deleting expense entity instance", error)
            return false
        }
    }
    
    // MARK: Update expense
    func saveUpdatedExpense(
        expense: Expense,
        newAmount: String,
        newExpenseType: String,
        newDetails: String,
        newStoredImage: Data
    ) {
        let context = persistentContainer.viewContext
        
        expense.timestamp = Date()
        expense.amount = newAmount
        expense.expenseType = newExpenseType
        expense.details = newDetails
        expense.storedImage = newStoredImage
        
        do {
            try context.save()
        } catch let error {
            print("Failed to update note", error)
        }
    }
    
}
