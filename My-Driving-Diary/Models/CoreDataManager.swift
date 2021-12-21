import CoreData

struct CoreDataManager {
    
    // MARK: PROPERTIES
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Simple-cms")
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of stores failed \(err)")
            }
        })
        return container
    }()
    
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
    
    
    
}
