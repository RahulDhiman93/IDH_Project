import Foundation

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

//MARK: PatientRecords class for CRUD operations
class PatientRecords {
    
    //MARK: Patients dictionary to record patient data
    private var patientsRecord: [Int: Patient] = [:]
    
    //MARK: Parsing instructions.txt file to retrieve operations information
    fileprivate func processInstructions() {
        
        //Getting file from resources using guard statement
        guard let filePath = Bundle.main.path(forResource: "instructions", ofType: "txt") else {
            print("No such file found!")
            return
        }
        do {
            //Converting .txt file contents to String
            let contents = try String(contentsOfFile: filePath)
            
            //Separating operations line by line
            let lines = contents.components(separatedBy: .newlines)
            
            //Iterating throught every line
            for line in lines {
                
                //Separating every single word (using space as separator)
                let components = line.split(separator: " ").map { String($0) }
                
                //Safeguarding components word count
                guard components.count > 0, let operation = components.first else {
                    continue
                }
                
                //Collecting first component as record entity
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
            
            //Error handling if file doesn't exist in resources
            print("Error reading file: \(error)")
        }
    }
    
    //MARK: Add patient to Dictionary
    fileprivate func addPatient(patientId: Int, name: String) {
        
        //If patientId doesn't exist in records, add patient to records
        if !patientsRecord.keys.contains(patientId) {
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
records.processInstructions()
records.printFinalList()
