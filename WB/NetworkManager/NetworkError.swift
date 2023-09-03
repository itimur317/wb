import Foundation

enum NetworkError: String, Error {
    case notNet = "Отсутствует подключение к сети."
    case authenticationError = "Неправильный логин или пароль."
    case serverError = "Не удалось подключиться к серверу."
    case emptyDataError = "Данные отсутствуют."
    case emptyResponseError = "Не удалось получить данные с сервера."
    case badRequest = "Неправильный запрос."
    case parsingError = "Не удалось получить данные."
    case failed = "Неизвестная ошибка."
}
