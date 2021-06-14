import Foundation

class StockMaximize {

    
    var resultProfit: Int = 0
    var maxProfitIndex: Int = -1
    
    func countProfit(prices: [Int]) -> Int {
        
        if prices.count == 0 || prices.count == 1 {
            return 0
        }
        
        // цикл поиска макс профита на конкретном участке и прибавления к результирующему
        while maxProfitIndex < prices.count {
            maxProfitIndex += 1
            resultProfit += sumMaxProfit(array: prices, start: maxProfitIndex, end: prices.count - 1)
        }
        
        print("resultProfit", resultProfit)
        return resultProfit
    }
    
    
    // функция пробегает по диапазону массива и, если значения не убывают, считает макс профит на диапазоне и индекс дня макс профита
    func sumMaxProfit(array: [Int], start: Int, end: Int) -> Int {
//            print("maxProfitIndex Input", maxProfitIndex)
            // проверка входящих индексов
            if start >= end || start < 0 || end > array.count - 1  {
                return 0
            }
            
            var maxProfit: Int = 0
            var currentProfit: Int = 0
            var sellPrice: Int = 0
            var buyPrice: Int = 0
            var dayCounter: Int = 0
            for i in start..<end {
                if array[i] <= array[i + 1] {
                    dayCounter += 1
                    buyPrice += array[i]
                    sellPrice = array[i + 1] * dayCounter
                    currentProfit = sellPrice - buyPrice
                }
                if maxProfit < currentProfit {
                    maxProfit = currentProfit
                    maxProfitIndex = i
                }
            }
//            print("maxProfit", maxProfit)
//            print("maxProfitIndex Output", maxProfitIndex)
            return maxProfit
        }
    
}
