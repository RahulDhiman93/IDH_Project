# Patient Records Management System
This Swift Playground provides a simple implementation of a patient records management system. It allows adding and deleting patients along with their associated exams. The system reads instructions from a text file and performs operations accordingly.

## Features
1. Add new patients
2. Add exams for existing patients
3. Delete patients
4. Delete exams associated with patients

## How to Run
1. **Open the Playground:** Open the Swift Playground file (idh_thp.playground) in Xcode or any compatible Swift development environment.
2. **Execute the Code:** Once the playground is open, execute the code by pressing the "Play" button. This will run the code and display the results in the console.
3. **Review Output:** The code will read instructions from the instructions.txt file and perform operations accordingly. The final list of patients and their exam counts will be printed in the console.
4. **Testing:** The playground also contains test cases to ensure the functionality of the Patient Records class. To run the tests, simply scroll down to the end of the playground code and review the test cases. The test results will be printed in the console.

## Operations Instructions
1. **Adding a patient:** `ADD PATIENT [PatientID] [PatientName]`
2. **Adding an Exam for a Patient:** `ADD EXAM [PatientID] [ExamID]`
3. **Deleting a Patient:** `DEL PATIENT [PatientID]`
4. **Deleting an Exam:** `DEL EXAM [ExamID]`

## Testing Instructions
1. The playground includes XCTest cases for testing various functionalities of the Patient Records class.
2. Test cases cover scenarios such as file processing, adding patients and exams, deleting patients and exams, and handling invalid operations.

## File Structure
1. **idh_thp.playground:** Swift Playground file containing the implementation of the patient records management system and test cases.
2. **instructions.txt:** Text file containing instructions for adding, and deleting patients or exams.

## Note
1. Ensure that the instructions.txt file is in the same directory as the playground file, or update the file path in the code to be under the resources folder.
2. Make sure to review the console output for any errors or expected results after running the code.

## Compatibility
1. This code is compatible with Swift 5 and above.
2. It is recommended to run the playground in Xcode for optimal execution and testing.


##
For any issues or suggestions, feel free to open an issue or submit a pull request.

**Happy Coding!**
