import Foundation
import XCTest

//MARK: Patient Model
struct Patient {
    let id: Int
    let name: String
    var exams: Set<Int> = []
}

//MARK: Operations ENUM
enum Operations : String {
    case add = "ADD"
    case delete = "DEL"
}

//MARK: RecordType ENUM
enum RecordType: String {
    case patient = "PATIENT"
    case exam = "EXAM"
}

//MARK: PatientRecords class for operations
class PatientRecords {
    
    //MARK: Patients dictionary to record patient data
    fileprivate var patientsRecord: [Int: Patient] = [:]
    
    //MARK: Parsing text file to retrieve operations information
    fileprivate func processInstructions(fileName: String) throws {
        
        //Getting file from resources
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") ?? "Invalid File Path"
        
        do {
            //Converting file contents to String
            let contents = try String(contentsOfFile: filePath)
            
            //Separating operations line by line
            let lines = contents.components(separatedBy: .newlines)
            
            //Iterating throught every line
            for line in lines {
                
                //Separating every single word (using space as separator)
                let components = line.split(separator: " ").map { String($0) }
                
                //Safeguarding components word count
                guard components.count > 1, let operation = components.first else {
                    continue
                }
                
                //Collecting second component as record entity
                let recordEntity = components[1]
                
                //Switching first character over operations ENUM
                switch Operations(rawValue: operation) {
                case .add:

                    //Guarding ADD operations to have atleast 4 components
                    guard components.count > 3 else {
                        break
                    }
                    
                    //Switching over record type for patient and exam changes
                    switch RecordType(rawValue: recordEntity) {
                    case .patient:
                        guard let patientId = Int(components[2]) else {
                            break
                        }
                        
                        //Collecting components[3] and beyong as patient name
                        let patientName = components[3...].joined(separator: " ")
                        
                        //Adding patient to records
                        addPatient(patientId: patientId, name: patientName)
                    case .exam:
                        guard let patientId = Int(components[2]), let examId =  Int(components[3]) else {
                            break
                        }
                        
                        //Adding exam to records
                        addExam(patientId: patientId, examId:  examId)
                    default:
                        break
                    }
                case .delete:
                    //Guarding DEL operations to have atleast 3 components
                    guard components.count > 2 else {
                        break
                    }
                    
                    //Switching over record type for patient and exam changes
                    switch RecordType(rawValue: recordEntity) {
                    case .patient:
                        guard let patientId = Int(components[2]) else {
                            break
                        }
                        
                        //Deleting patient from records
                        deletePatient(id: patientId)
                    case .exam:
                        guard let examId =  Int(components[2])  else {
                            break
                        }
                        
                        //Deleting exam from records
                        deleteExam(examId: examId)
                    default:
                        break
                    }
                default:
                    break
                }
            }
        } catch {
            throw error
        }
    }
    
    //MARK: Add patient to Dictionary
    fileprivate func addPatient(patientId: Int, name: String) {
        
        //If patientId doesn't exist in records, add patient to records
        if patientId > 0 && !patientsRecord.keys.contains(patientId) {
            patientsRecord[patientId] = Patient(id: patientId, name: name)
        }
    }
    
    //MARK: Add Exam to patient
    fileprivate func addExam(patientId: Int, examId: Int) {

        //If patientId exist and examId doesn't exist, we map exam to the patient
        if var patient = patientsRecord[patientId], !patient.exams.contains(examId) {
            patient.exams.insert(examId)
            patientsRecord[patientId] = patient
        }
    }
    
    //MARK: Delete Patient from Dictionary
    fileprivate func deletePatient(id: Int) {
        
        //Making key value to NIL (hence deleting record)
        patientsRecord[id] = nil
    }
    
    //MARK: Delete Exam from Patient
    fileprivate func deleteExam(examId: Int) {
        
        //Assuming one examId can exist for multiple patients
        for (patientId, _) in patientsRecord {
            if var patient = patientsRecord[patientId] {
                patient.exams.remove(examId)
                patientsRecord[patientId] = patient
            }
        }
    }
    
    //MARK: Print final list
    fileprivate func printFinalList() {
        
        //Iterating through all patient values and logging output
        for patient in patientsRecord.values {
            print("Name: \(patient.name), Id: \(patient.id), Exam Count: \(patient.exams.count)")
        }
    }
}

//MARK: Using PatientRecords Class and it's functions
let records = PatientRecords()
do {
    try records.processInstructions(fileName: "instructions")
    records.printFinalList()
} catch {
    print("[ERROR]: \(error.localizedDescription)")
}


//MARK: ---------- PatientRecords Test Cases ------------------


class PatientRecordsTests: XCTestCase {
    
    //MARK: New instance of records
    var records: PatientRecords!
    
    //MARK: Setting up test environment
    override func setUp() {
        super.setUp()
        records = PatientRecords()
    }
    
    //MARK: Teardown to make records NIL
    override func tearDown() {
        records = nil
        super.tearDown()
    }
    
    //MARK: Testing for valid file processing
    func testProcessInstructions() {
        do {
            // Processing instructions from the test file
            try records.processInstructions(fileName: "test_instructions")
            
            // Asserting for expected number of patients after processing instructions
            XCTAssertEqual(records.patientsRecord.count, 4)
            
            // Asserting for expected number of exams for a particular patient
            XCTAssertEqual(records.patientsRecord[1]?.exams.count, 0)
        } catch {
            XCTFail()
        }
    }
    
    //MARK: Testing for Invalid file processing
    func testInvalidProcessInstructions() {
        //Processed file throws an error
        XCTAssertThrowsError(try records.processInstructions(fileName: "test_instructions_fail"))
    }
    
    
    //MARK: Testing for Add Patient
    func testAddPatient() {
        records.addPatient(patientId: 1, name: "John Doe")
        XCTAssertEqual(records.patientsRecord.count, 1)
        
        // Adding patient with existing ID should not add duplicate
        records.addPatient(patientId: 1, name: "Jane Doe")
        XCTAssertEqual(records.patientsRecord.count, 1)
        
        // Adding multiple patients
        records.addPatient(patientId: 2, name: "Alice")
        records.addPatient(patientId: 3, name: "Bob")
        XCTAssertEqual(records.patientsRecord.count, 3)
        
        // Attempt to add patient with invalid ID
        records.addPatient(patientId: -1, name: "Invalid ID")
        XCTAssertEqual(records.patientsRecord.count, 3)
    }
    
    //MARK: Testing for Add Exam
    func testAddExam() {
        records.addPatient(patientId: 1, name: "John Doe")
        
        // Adding exam to existing patient
        records.addExam(patientId: 1, examId: 101)
        XCTAssertEqual(records.patientsRecord[1]?.exams.count, 1)
        
        // Adding exam to non-existing patient should not add
        records.addExam(patientId: 2, examId: 102)
        XCTAssertNil(records.patientsRecord[2])
        
        // Adding same exam multiple times should add only once
        records.addExam(patientId: 1, examId: 101)
        XCTAssertEqual(records.patientsRecord[1]?.exams.count, 1)
    }
    
    //MARK: Testing for Delete Patient
    func testDeletePatient() {
        records.addPatient(patientId: 1, name: "John Doe")
        
        // Deleting existing patient
        records.deletePatient(id: 1)
        XCTAssertEqual(records.patientsRecord.count, 0)
        
        // Deleting non-existing patient should not change
        records.deletePatient(id: 2)
        XCTAssertEqual(records.patientsRecord.count, 0)
        
        // Deleting patient with associated exams
        records.addPatient(patientId: 1, name: "John Doe")
        records.addExam(patientId: 1, examId: 101)
        records.deletePatient(id: 1)
        XCTAssertEqual(records.patientsRecord.count, 0)
    }
    
    //MARK: Testing for Delete Exam
    func testDeleteExam() {
        records.addPatient(patientId: 1, name: "John Doe")
        records.addPatient(patientId: 2, name: "Jane Doe")
        
        // Adding exams to patients
        records.addExam(patientId: 1, examId: 101)
        records.addExam(patientId: 2, examId: 102)
        
        // Deleting existing exam
        records.deleteExam(examId: 101)
        XCTAssertFalse(records.patientsRecord[1]?.exams.contains(101) ?? true)
        
        // Deleting non-existing exam should not change
        records.deleteExam(examId: 103)
        XCTAssertEqual(records.patientsRecord.count, 2)
    }
    
}

print("\n---- Testing for Patient Records Service -----\n")
PatientRecordsTests.defaultTestSuite.run()
