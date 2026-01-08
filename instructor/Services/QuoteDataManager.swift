//
//  QuoteDataManager.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import Foundation

// MARK: - 数据管理协议
protocol QuoteDataManaging {
    func getAllQuotes() -> [Quote]
    func getQuotes(for situation: Situation) -> [Quote]
    func getRandomQuote(for situation: Situation) -> Quote?
    func saveRecord(_ record: QuoteRecord)
    func getAllRecords() -> [QuoteRecord]
    func clearAllRecords()
}

// MARK: - 语录数据管理器
final class QuoteDataManager: QuoteDataManaging {
    static let shared = QuoteDataManager()
    
    private let userDefaults: UserDefaults
    private let recordsKey = "quoteRecords"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - 获取语录
    func getAllQuotes() -> [Quote] {
        return defaultQuotes
    }
    
    func getQuotes(for situation: Situation) -> [Quote] {
        return defaultQuotes.filter { $0.situation == situation }
    }
    
    func getRandomQuote(for situation: Situation) -> Quote? {
        let quotes = getQuotes(for: situation)
        return quotes.randomElement()
    }
    
    // MARK: - 记录管理
    func saveRecord(_ record: QuoteRecord) {
        var records = getAllRecords()
        records.append(record)
        
        if let data = try? JSONEncoder().encode(records) {
            userDefaults.set(data, forKey: recordsKey)
        }
    }
    
    func getAllRecords() -> [QuoteRecord] {
        guard let data = userDefaults.data(forKey: recordsKey),
              let records = try? JSONDecoder().decode([QuoteRecord].self, from: data) else {
            return []
        }
        return records.sorted { $0.timestamp > $1.timestamp }
    }
    
    func clearAllRecords() {
        userDefaults.removeObject(forKey: recordsKey)
    }
    
    // MARK: - 默认语录数据
    private var defaultQuotes: [Quote] {
        return [
            // 犹豫时该看的
            Quote(content: "没有调查，就没有发言权。", source: "反对本本主义", situation: .hesitating),
            Quote(content: "实践是检验真理的唯一标准。", source: "实践论", situation: .hesitating),
            Quote(content: "不做正确的调查同样没有发言权。", source: "反对本本主义", situation: .hesitating),
            Quote(content: "你要知道梨子的滋味，你就得变革梨子，亲口吃一吃。", source: "实践论", situation: .hesitating),
            Quote(content: "调查就像'十月怀胎'，解决问题就像'一朝分娩'。", source: "反对本本主义", situation: .hesitating),
            
            // 退缩时该看的
            Quote(content: "革命不是请客吃饭，不是做文章，不是绘画绣花，不能那样雅致，那样从容不迫，文质彬彬，那样温良恭俭让。", source: "湖南农民运动考察报告", situation: .retreating),
            Quote(content: "凡是反动的东西，你不打，他就不倒。", source: "抗日战争胜利后的时局和我们的方针", situation: .retreating),
            Quote(content: "在战略上我们要藐视一切敌人，在战术上我们要重视一切敌人。", source: "关于帝国主义和一切反动派是不是真老虎的问题", situation: .retreating),
            Quote(content: "枪杆子里面出政权。", source: "战争和战略问题", situation: .retreating),
            Quote(content: "与天奋斗，其乐无穷！与地奋斗，其乐无穷！与人奋斗，其乐无穷！", source: "奋斗自述", situation: .retreating),
            
            // 硬撑时该看的
            Quote(content: "星星之火，可以燎原。", source: "星星之火，可以燎原", situation: .struggling),
            Quote(content: "坚定正确的政治方向，艰苦朴素的工作作风，灵活机动的战略战术。", source: "中国革命战争的战略问题", situation: .struggling),
            Quote(content: "下定决心，不怕牺牲，排除万难，去争取胜利。", source: "愚公移山", situation: .struggling),
            Quote(content: "世上无难事，只要肯登攀。", source: "水调歌头·重上井冈山", situation: .struggling),
            Quote(content: "雄关漫道真如铁，而今迈步从头越。", source: "忆秦娥·娄山关", situation: .struggling),
            
            // 被动挨打时该看的
            Quote(content: "敌进我退，敌驻我扰，敌疲我打，敌退我追。", source: "中国的红色政权为什么能够存在？", situation: .passive),
            Quote(content: "打得赢就打，打不赢就走。", source: "论持久战", situation: .passive),
            Quote(content: "存人失地，人地皆存；存地失人，人地皆失。", source: "论持久战", situation: .passive),
            Quote(content: "战略上藐视敌人，战术上重视敌人。", source: "中国革命战争的战略问题", situation: .passive),
            Quote(content: "集中优势兵力，各个歼灭敌人。", source: "中国革命战争的战略问题", situation: .passive)
        ]
    }
}

