import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURL = URL(string: "https://ballonnote.shop/app.php")!
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case serverError(String)
        case decodingError
    }
    
    func sendRequest<T: Decodable>(method: String, body: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var bodyWithMethod = body
        bodyWithMethod["metod"] = method
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyWithMethod, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode,
                  let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                    completion(.failure(NetworkError.serverError(serverError.error)))
                } else {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }.resume()
    }
    
    struct ServerErrorResponse: Decodable {
        let error: String
    }
    
    struct GenericSuccessResponse: Decodable {
        let success: String?
        let error: String?
    }
    
    struct User: Codable {
        let login: String
        let name: String?
        let email: String?
    }
    
    struct UserAuthResponse: Decodable {
        let success: String?
        let error: String?
        let user: User?
    }
    
    struct InspireModel: Codable, Identifiable {
        var id = UUID().uuidString
        var name: String
        var trought: [String]
    }
    
    struct InspireResponse: Decodable {
        let success: String?
        let error: String?
        let inspire: InspireModel?
    }
    
    struct SketchModel: Codable, Identifiable {
        let id: String
        let name: String
        let images: [String]
    }
    
    struct SketchResponse: Decodable {
        let success: String?
        let error: String?
        let sketch: SketchModel?
    }
    
    struct BallonCardResponse: Codable, Identifiable, Equatable {
        let id: String
        let name: String
        let ballons: [String]
        
        var uuid: UUID {
            UUID(uuidString: id) ?? UUID()
        }
        
        static func == (lhs: BallonCardResponse, rhs: BallonCardResponse) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    struct SketchesResponse: Decodable {
        let sketches: [SketchModel]?
        let error: String?
    }
    
    // MARK: - Методы API
    
    // 1) Регистрация
    func register(login: String, pass: String, name: String? = nil, email: String? = nil, completion: @escaping (Result<String, Error>) -> Void) {
        var body: [String: Any] = [
            "login": login,
            "pass": pass
        ]
        if let name = name { body["name"] = name }
        if let email = email { body["email"] = email }
        
        sendRequest(method: "registration", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 2) Авторизация
    func authorize(login: String, pass: String, name: String? = nil, completion: @escaping (Result<User, Error>) -> Void) {
        var body: [String: Any] = [
            "login": login,
            "pass": pass
        ]
        if let name = name { body["name"] = name }
        
        sendRequest(method: "autorization", body: body) { (result: Result<UserAuthResponse, Error>) in
            switch result {
            case .success(let response):
                if let user = response.user {
                    completion(.success(user))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 3) Сохранение мыслей
    func saveInspire(login: String, inspire: InspireModel, completion: @escaping (Result<String, Error>) -> Void) {
        let inspireDict: [String: Any] = [
            "id": inspire.id,
            "name": inspire.name,
            "trought": inspire.trought
        ]
        let body: [String: Any] = [
            "login": login,
            "inspire": inspireDict
        ]
        
        sendRequest(method: "save_inspire", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 4) Получение мыслей
    func getInspire(login: String, completion: @escaping (Result<InspireModel, Error>) -> Void) {
        let body = ["login": login]
        sendRequest(method: "get_inspire", body: body) { (result: Result<InspireResponse, Error>) in
            switch result {
            case .success(let response):
                if let inspire = response.inspire {
                    completion(.success(inspire))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    // 5) Редактирование мыслей
    func editInspire(login: String, inspire: InspireModel, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "login": login,
            "id": inspire.id,
            "name": inspire.name,
            "trought": inspire.trought
        ]
        
        sendRequest(method: "edit_inspire", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 6) Удаление конкретной мысли
    func deleteInspire(login: String, inspireId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "login": login,
            "id": inspireId
        ]
        
        sendRequest(method: "delete_inspire", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 7) Сохранение зарисовок
    func saveSketch(login: String, sketch: SketchModel, completion: @escaping (Result<String, Error>) -> Void) {
        let sketchDict: [String: Any] = [
            "id": sketch.id,
            "name": sketch.name,
            "images": sketch.images
        ]
        let body: [String: Any] = [
            "login": login,
            "sketch": sketchDict
        ]
        
        sendRequest(method: "save_sketch", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSketches(login: String, completion: @escaping (Result<[SketchModel], Error>) -> Void) {
        let body = ["login": login]
        sendRequest(method: "get_sketches", body: body) { (result: Result<SketchesResponse, Error>) in
            switch result {
            case .success(let response):
                if let sketches = response.sketches {
                    completion(.success(sketches))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 9) Редактирование зарисовок
    func editSketch(login: String, sketch: SketchModel, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "login": login,
            "id": sketch.id,
            "name": sketch.name,
            "images": sketch.images
        ]
        
        sendRequest(method: "edit_sketch", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 10) Удаление конкретной зарисовки
    func deleteSketch(login: String, sketchId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "login": login,
            "id": sketchId
        ]
        
        sendRequest(method: "delete_sketch", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 11) Изменение имени пользователя
    func changeUsername(login: String, newName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "login": login,
            "new_name": newName
        ]
        
        sendRequest(method: "change_username", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 12) Изменение email пользователя
    func changeEmail(login: String, newEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "login": login,
            "new_email": newEmail
        ]
        
        sendRequest(method: "change_email", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 13) Удаление аккаунта
    func deleteAccount(login: String, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "login": login
        ]
        
        sendRequest(method: "delete_account", body: body) { (result: Result<GenericSuccessResponse, Error>) in
            switch result {
            case .success(let response):
                if let success = response.success {
                    completion(.success(success))
                } else if let error = response.error {
                    completion(.failure(NetworkError.serverError(error)))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
