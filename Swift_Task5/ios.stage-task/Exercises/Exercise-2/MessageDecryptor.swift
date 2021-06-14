import UIKit

class MessageDecryptor: NSObject {
    
    let emptyString = ""
    
    func decryptMessage(_ message: String) -> String {
        
//        let emptyString = ""
        var outputMessage = emptyString
        
        // создаю сет для проверки всех char входящей строки
        var characterSet = CharacterSet()
        characterSet.formUnion(.decimalDigits)
        characterSet.formUnion(.lowercaseLetters)
        characterSet.insert("[")
        characterSet.insert("]")
        
        // проверка всех char входящей строки
        for char in message.unicodeScalars {
            if !characterSet.contains(char) {
                return emptyString
            }
        }
        
        // проверка длины входящей строки
        if message.count < 1 || message.count > 60 {
            return emptyString
        }

        // main
        outputMessage = addMessage(string: message)
        return outputMessage
    }
    
    // функция создания субстроки из строки и записи в вывод
    func addMessage(string: String) -> String {
//        print("Input string in addMessage: ", string)
        var bufferString: String = emptyString
        var addString: String = emptyString
        var multiplier: String = emptyString
        
        var i = string.startIndex
        
        // проверка - один ли элемент в сабстроке, если да - возвращаем строку
        if string.count == 1 {
            return string
        }
        
        // итерация по символам до конца строки(субстроки)
        while i < string.endIndex {
            
            // собираем число-мультипликатор
            if string[i].isNumber {
                multiplier.append(string[i])
                i = string.index(after: i)
            }
            
            //находим начало новой субстроки
            else if string[i] == "[" {
                let indexStart = string.index(after: i)
//                    print("Char at indexStart", string[indexStart])
                let indexEnd = findSubstringEndIndex(string: string, start: indexStart)
//                    print("Char at indexEnd", string[indexEnd])
                let substring = string[indexStart..<indexEnd]
//                    print("Substring:", substring)
                addString = addMessage(string: String(substring))
                
                // проверка числа-множителя
                if multiplier != emptyString && Int(multiplier)! > 300 {
                    multiplier = "0"
                }
                // если множителя нету, то = 1
                if multiplier == emptyString {
                    multiplier = "1"
                }
                for _ in 0..<Int(multiplier)! { bufferString.append(addString) }
                multiplier = emptyString
                i = string.index(after: indexEnd)
                
            }
            // запись букв в промежуточную строку
            else if string[i] != "]"  {
                bufferString.append(string[i])
                i = string.index(after: i)
            }
        }
        return bufferString
    }
    
    // функция поиска индекса  последнего символа строки(субстроки)
    func findSubstringEndIndex(string: String, start: String.Index) -> String.Index {
        var bracesCounter: Int = 1
        var i = start
        // тут идет подсчет скобок для определения момента "закрытия" строки
        while i < string.endIndex {
            if string[i] == "[" {
                bracesCounter += 1
                i = string.index(after: i)
            }
            else if string[i] == "]" {
                bracesCounter -= 1
                if bracesCounter == 0 {
                    return i
                }
                i = string.index(after: i)
            }
            else { i = string.index(after: i) }
        }
        return i
    }
}
