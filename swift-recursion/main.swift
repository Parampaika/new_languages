import Foundation

struct Student {
    let name: String
    let age: Int
    let averageScore: Int
    let group: String
}

func quickSort(_ array: inout [Student], low: Int, high: Int) {
    if low < high {
        let pivotIndex = partition(&array, low: low, high: high)
        quickSort(&array, low: low, high: pivotIndex - 1)
        quickSort(&array, low: pivotIndex + 1, high: high)
    }
}

func partition(_ array: inout [Student], low: Int, high: Int) -> Int {
    let pivot = array[high].averageScore
    var i = low - 1

    for j in low..<high {
        if array[j].averageScore >= pivot {
            i += 1
            array.swapAt(i, j)
        }
    }

    array.swapAt(i + 1, high)
    return i + 1
}

func readStudentsFromFile() -> [Student]? {
    let fileURL = URL(fileURLWithPath: "students.json")

    do {
        let data = try Data(contentsOf: fileURL)
        let json = try JSONSerialization.jsonObject(with: data, options: [])

        if let groups = json as? [String: [String: [Int]]] {
            var students: [Student] = []
            
            for (groupName, studentsData) in groups {
                for (name, studentData) in studentsData {
                    let age = studentData[0]
                    let averageScore = studentData[1]
                    students.append(Student(name: name, age: age, averageScore: averageScore, group: groupName))
                }
            }

            return students
        }
    } catch {
        print("Error reading file:", error)
    }

    return nil
}


if var students = readStudentsFromFile() {
    quickSort(&students, low: 0, high: students.count - 1)
  
    for student in students {
        print("Name: \(student.name), \tAge: \(student.age), Group: \(student.group), \tAverage Score: \(student.averageScore)")
    }
}