import Foundation

// экстеншн для составления сочетаний
extension Array {
    var combinations: [[Element]] {
        if count == 0 {
            return [self]
        }
        else {
            let tail = Array(self[1..<endIndex])
            let head = self[0]

            let first = tail.combinations
            let rest = first.map { $0 + [head] }

            return first + rest
        }
    }
}


public typealias Supply = (weight: Int, value: Int)

public final class Knapsack {
    let maxWeight: Int
    let drinks: [Supply]
    let foods: [Supply]
    var maxKilometers: Int {
        findMaxKilometres()
    }

//    структура для "жадного" поиска - не пригодилась в итоге :(
//    struct supplyEfficiency {
//        let supply: Supply
//        let efficiency: Double
//        let index: Int
//    }
    
    struct Result {
        let distance: Int
        let wieght: Int
    }
    
    
    init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
        self.maxWeight = maxWeight
        self.drinks = drinks
        self.foods = foods
    }
    
    func findMaxKilometres() -> Int {
        
        if drinks == nil || drinks.isEmpty || foods == nil || foods.isEmpty {
            return 0
        }
        
        // добавляем в начало массивов нулевые пустышки чтобы работало создание таблиц
        let drinksInput = [(0,0)] + drinks
        let foodsInput = [(0,0)] + foods
        
        var foodKnackpack: [[Int]] = []
        var drinksKnackpack: [[Int]] = []
        
        // заполняем нулями
        for (i, _) in foodsInput.enumerated() {
            foodKnackpack.append([0])
            for _ in 0...maxWeight {
                foodKnackpack[i].append(0)
            }
        }
        
        for (i, _) in drinksInput.enumerated() {
            drinksKnackpack.append([0])
            for _ in 0...maxWeight {
                drinksKnackpack[i].append(0)
            }
        }
        
        // создаем две таблицы заполняемости рюкзаков
        for i in 1...foodsInput.count - 1 {
            for j in 0...maxWeight {
                if foodsInput[i].weight > j {
                    foodKnackpack[i][j] = foodKnackpack[i - 1][j]
                }
                else {
                    foodKnackpack[i][j] = max(foodKnackpack[i - 1][j], foodKnackpack[i - 1][j - foodsInput[i].weight] + foodsInput[i].value)
                }
            }
        }
        
        for i in 1...drinksInput.count - 1 {
            for j in 0...maxWeight {
                if drinksInput[i].weight > j {
                    drinksKnackpack[i][j] = drinksKnackpack[i - 1][j]
                }
                else {
                    drinksKnackpack[i][j] = max(drinksKnackpack[i - 1][j], drinksKnackpack[i - 1][j - drinksInput[i].weight] + drinksInput[i].value)
                }
            }
        }
        
        var summDistance = 0
        var maxSummDistance = 0
        let foodLastIndex = foodKnackpack.count - 1
        let drinkLastIndex = drinksKnackpack.count - 1
        
        // находим макс длину при ограниченной массе
        for i in 0...maxWeight {
            var j = maxWeight - i
                if drinksKnackpack[drinkLastIndex][i] < foodKnackpack[foodLastIndex][j] {
                    summDistance = drinksKnackpack[drinkLastIndex][i]
                }
                else { summDistance = foodKnackpack[foodLastIndex][j]}
                
                if i + j <= maxWeight && maxSummDistance < summDistance {
                    maxSummDistance = summDistance
            }
        }

        return maxSummDistance
    }
}

// метод брутфорса
//
//import Foundation
//
//// экстеншн для составления сочетаний
//extension Array {
//    var combinations: [[Element]] {
//        if count == 0 {
//            return [self]
//        }
//        else {
//            let tail = Array(self[1..<endIndex])
//            let head = self[0]
//
//            let first = tail.combinations
//            let rest = first.map { $0 + [head] }
//
//            return first + rest
//        }
//    }
//}
//
//
//public typealias Supply = (weight: Int, value: Int)
//
//public final class Knapsack {
//    let maxWeight: Int
//    let drinks: [Supply]
//    let foods: [Supply]
//    var maxKilometers: Int {
//        findMaxKilometres()
//    }
//
////    структура для "жадного" поиска - не пригодилась в итоге :(
////    struct supplyEfficiency {
////        let supply: Supply
////        let efficiency: Double
////        let index: Int
////    }
//
//    struct Result {
//        let distance: Int
//        let wieght: Int
//    }
//
//
//    init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
//        self.maxWeight = maxWeight
//        self.drinks = drinks
//        self.foods = foods
//    }
//
//    func findMaxKilometres() -> Int {
//
//        if drinks == nil || drinks.isEmpty || foods == nil || foods.isEmpty {
//            return 0
//        }
//        // создаем массивы комбинаций
//        let drinksCombination = drinks.combinations
//        let foodsCombination = foods.combinations
//
//        //создаем массивы результатов масс и дистанций
//        let drinksResult = createResultArray(array: drinksCombination)
//        let foodsResult = createResultArray(array: foodsCombination)
//
//        var summDistance = 0
//        var maxSummDistance = 0
//
//        // находим макс длину при ограниченной массе
//        for drink in drinksResult {
//            for food in foodsResult {
//                if drink.distance <= food.distance {
//                    summDistance = drink.distance
//                }
//                else { summDistance = food.distance }
//
//                if drink.wieght + food.wieght <= maxWeight && maxSummDistance < summDistance {
//                    maxSummDistance = summDistance
//                }
//            }
//        }
//
//        return maxSummDistance
//    }
//
//    // функция преобразует входящий массив массивов supply елементов в массив с суммированными массами и дистанциями
//    func createResultArray(array: [[Supply]]) -> [Result] {
//        var result: [Result] = []
//        for elementSet in array {
//            var distance = 0
//            var weight = 0
//            for element in elementSet {
//                distance += element.value
//                weight += element.weight
//            }
//            // сразу выбрасываем суммы с овермассой
//            if weight < maxWeight {
//                result.append(Result(distance: distance, wieght: weight))
//            }
//        }
//        return result
//    }
//}
//

