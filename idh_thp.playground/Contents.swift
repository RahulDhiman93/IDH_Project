import Foundation

//MARK: Patient Model
struct Patient {
    let id: Int
    let name: String
    var exams: Set<Int> = []
}

//MARK: PatientRecords class for CRUD operations
class PatientRecords {
    
    //MARK: Patients dictionary to record patient data
    private var patients: [Int: Patient] = [:]
    
    //MARK: Parsing instructions.txt file to retrieve operations information
    func processInstructions() {
        guard let filePath = Bundle.main.path(forResource: "instructions", ofType: "txt") else {
            print("No such file found!")
            return
        }
        do {
            let contents = try String(contentsOfFile: filePath)
            let lines = contents.components(separatedBy: .newlines)
            print(lines)
        } catch {
            print("Error reading file: \(error)")
        }
    }
}

//MARK: Using PatientRecords Class and it's functions
let records = PatientRecords()
records.processInstructions()
