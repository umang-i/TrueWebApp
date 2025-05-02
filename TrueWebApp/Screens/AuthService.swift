//
//  AuthService.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 24/04/25.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    
    func registerUser(with model: RegisterModel, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://goappadmin.zapto.org/api/register") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(model)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned."])))
                return
            }
            
            do {
                let responseString = try JSONDecoder().decode([String: String].self, from: data)
                print(responseString)
                let message = responseString["message"] ?? "Success"
                completion(.success(message))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loginUser(with model: LogInModel, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "https://goappadmin.zapto.org/api/login") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(model)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                // Save token locally
                UserDefaults.standard.set(loginResponse.token, forKey: "authToken")
                UserDefaults.standard.set(loginResponse.user, forKey: "userId")
                UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(loginResponse.expires_in)), forKey: "tokenExpiry")
                
                completion(.success(loginResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                completion(.failure(NSError(domain: "No token found", code: 401)))
                return
            }

            guard let url = URL(string: "https://goappadmin.zapto.org/api/user-profile") else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -2)))
                    return
                }

                do {
                    let profile = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                    completion(.success(profile.user))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}
