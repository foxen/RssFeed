import Foundation

func makeUpdatedString(_ date: Date?) -> String {
    return str(date, "обновлена dd.MM.yy в HH:mm")
}

func str(_ date: Date?, _ format: String) -> String {
    guard let d = date else {
        return ""
    }
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: d)
}

func makeDateString(_ date: Date?) -> String {
    return str(date, "dd.MM.yy HH:mm")
}

