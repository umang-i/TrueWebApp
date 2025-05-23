//
//  ApiService.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 24/04/25.
//

import Foundation
import UIKit

struct BaseAPIResponse: Decodable {
    let status: Bool
    let message: String
}
enum AuthError: Error {
    case invalidURL
    case emptyData
    case decodingFailed
    case custom(String)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .emptyData:
            return "No data was returned from the server."
        case .decodingFailed:
            return "Failed to decode the response."
        case .custom(let message):
            return message
        }
    }
}


class ApiService {
    static let shared = ApiService()
    
    func registerUser(with model: RegisterModel, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://goappadmin.zapto.org/api/register") else {
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    // Login user
    func loginUser(with model: LogInModel, from viewController: UIViewController, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "https://goappadmin.zapto.org/api/login") else {
            print("❌ Invalid URL")
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Manually construct JSON string with email before password
        let jsonString = """
        {
            "email": "\(model.email)",
            "password": "\(model.password)"
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("❌ Failed to encode JSON string")
            completion(.failure(NSError(domain: "Invalid JSON encoding", code: -2)))
            return
        }
        
        // ✅ Print the payload
        print("🟨 Login Payload:\n\(jsonString)")
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Log HTTP status code
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            // Log raw response data
            if let data = data, let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 Raw Response:\n\(rawResponse)")
            }
            
            self.handleLoginResponse(data: data, response: response, error: error, from: viewController, completion: completion)
        }.resume()
    }
    
    // MARK: - Generic handler
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<String, Error>) -> Void) {
        if let error = error {
            print("❌ Request error: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            print("❌ No data received")
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned."])))
            return
        }
        
        do {
            let baseResponse = try JSONDecoder().decode(BaseAPIResponse.self, from: data)
            print("✅ Parsed Base Response: \(baseResponse)")
            
            if baseResponse.status {
                completion(.success(baseResponse.message))
            } else {
                let apiError = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: baseResponse.message])
                completion(.failure(apiError))
            }
        } catch {
            print("❌ JSON parsing error: \(error)")
            completion(.failure(error))
        }
    }
    
    // MARK: - Login-specific handler
    private func handleLoginResponse(data: Data?, response: URLResponse?, error: Error?, from viewController: UIViewController, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        if let error = error {
            print("❌ Login request error: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            print("❌ No data in login response")
            completion(.failure(NSError(domain: "No data", code: -2)))
            return
        }
        
        do {
            // Try decoding to a generic response to check status
            let baseResponse = try JSONDecoder().decode(BaseAPIResponse.self, from: data)
            print("✅ Parsed Base Response: \(baseResponse)")
            
            if baseResponse.status {
                // Proceed with decoding login response
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    print("✅ Parsed Login Response: \(loginResponse)")
                    
                    // Check for admin approval flag
                    if loginResponse.user.admin_approval == "Approved" {
                        // If admin_approval is true, navigate to DashboardController
                        print("⚡ Admin approval granted, navigating to DashboardController")
                        
                        // Save token and user info
                        UserDefaults.standard.set(loginResponse.token, forKey: "authToken")
                        UserDefaults.standard.set(loginResponse.user.id, forKey: "userId")
                        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(loginResponse.expires_in)), forKey: "tokenExpiry")
                        
                        do {
                            let userData = try JSONEncoder().encode(loginResponse.user)
                            UserDefaults.standard.set(userData, forKey: "userData")
                            
                            if let jsonString = String(data: userData, encoding: .utf8) {
                                print("📦 Encoded user JSON to save:", jsonString)
                            }
                        } catch {
                            print("❌ Failed to encode user for UserDefaults:", error.localizedDescription)
                        }
                        
                        
                        //                        // Navigate to the DashboardController
                        //                        DispatchQueue.main.async {
                        //                            let mainTabBarController = TabBarController(nibName: "TabBarController", bundle: nil)
                        //                            viewController.navigationController?.pushViewController(mainTabBarController, animated: true)
                        //                            viewController.navigationController?.setNavigationBarHidden(true, animated: true)
                        //                        }
                        
                        // Return success
                        completion(.success(loginResponse))
                    } else {
                        // If admin_approval is false, show the approval pending message
                        let adminApprovalMessage = "You have been successfully registered with us , you can login once admin approves our request within 24hours ."
                        print("⚠️ \(adminApprovalMessage)")
                        
                        // Display the admin approval message
                        DispatchQueue.main.async {
                            self.showAlert(message: adminApprovalMessage, from: viewController)
                        }
                        
                        // Return failure with the admin approval message
                        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: adminApprovalMessage])))
                    }
                } catch {
                    print("❌ Failed to decode LoginResponse: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                // Handle failure case if status is false
                let apiError = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: baseResponse.message])
                completion(.failure(apiError))
            }
        } catch {
            print("❌ Failed to decode base response: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // MARK: - Show alert for admin approval message
    func showAlert(message: String, from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Account Status", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert on the passed viewController
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Function to perform UI updates on the main thread after the API call
    private func updateUIOnMainThread(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            completion()
        }
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
            
            // Debugging: Print the raw response
            print("Raw response data:", String(data: data, encoding: .utf8) ?? "No data")
            
            do {
                let profile = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                completion(.success(profile.user))
            } catch {
                print("Decoding error:", error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchPageContent(completion: @escaping (Result<PageContentResponse, Error>) -> Void) {
        guard let url = URL(string: "https://truewebapp.com/api/page") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // If using camelCase property names:
                // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(PageContentResponse.self, from: data)
                completion(.success(result))
            } catch {
                print("🔴 Decoding error: \(error)")
                // print("🔎 Raw JSON: ", String(data: data, encoding: .utf8) ?? "")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    // ApiService.swift
    func fetchCategories(keyword : String , completion: @escaping (Result<APIResponseCat, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "No token found", code: 401)))
            return
        }
        
        var request = URLRequest(url: URL(string: "https://goappadmin.zapto.org/api/categories?search=\(keyword)")!, timeoutInterval: 30)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(noDataError))
                return
            }
            
            // Optional debug log
            if let jsonString = String(data: data, encoding: .utf8) {
                  print("🔵 Raw JSON:\n\(jsonString)")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponseCat.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("❌ JSON Decoding Error: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    func fetchBrowseBanners(completion: @escaping (Result<BrowseBannerResponse, Error>) -> Void) {
        guard let url = URL(string: "https://goappadmin.zapto.org/api/browse-banner") else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 🔐 Set your token here
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "No token found", code: 401)))
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let data = data else {
                return completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                // print("Response JSON:\n\(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(BrowseBannerResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                print("Decoding error:", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Core function to make a wishlist request
    func makeWishlistRequest(userId: String, productId: String, mVarientId : String , completion: @escaping (Bool, String?) -> Void) {
        let urlString = "https://goappadmin.zapto.org/api/wishlist/add"
        guard let url = URL(string: urlString) else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Retrieve the auth token
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(false, "Auth token not found")
            return
        }
        
        let body: [String: Any] = [
            "user_id": userId,
            "mproduct_id": productId,
            "mvariant_id" : mVarientId
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, "Failed to serialize JSON body")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "No response from server")
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("Succesfully added/removed userid \(userId) and productId \(productId) to wishlist")
                completion(true, nil) // Success
            } else{
                completion(false, "Failed with status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
    
    func fetchBrands(completion: @escaping (Result<BrandResponse, Error>) -> Void) {
        // Retrieve the userId from UserDefaults
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            // Return failure if no userId is found
            completion(.failure(NetworkError.missingUserId))
            return
        }
        
        guard let url = URL(string: "https://goappadmin.zapto.org/api/brands?user_id=\(userId)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Retrieve the authentication token from UserDefaults and add it to the request header
        if let authToken = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Pass the error through completion handler
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                // Return a custom error if no data is received
                completion(.failure(NetworkError.noData))
                return
            }
            
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw Response brands: \(rawString)")
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                // Return an error based on the HTTP status code
                completion(.failure(NetworkError.badStatusCode(httpResponse.statusCode)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let brandResponse = try decoder.decode(BrandResponse.self, from: data)
                
                // Check the status flag from the response
                if brandResponse.status {
                    completion(.success(brandResponse)) // Return success with data
                } else {
                    completion(.failure(NetworkError.apiError(brandResponse.message))) // Return error message from API
                }
            } catch {
                // Catch any decoding errors
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchFilteredCategories(selectedBrandIds: Set<String>, endChar : String ,completion: @escaping (Result<APIResponseCat, Error>) -> Void) {
        let brandIdArray = selectedBrandIds.joined(separator: ",")
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            // Return failure if no userId is found
            completion(.failure(NetworkError.missingUserId))
            return
        }
        let urlString = "https://goappadmin.zapto.org/api/categories?user_id=\(userId)&mbrand_id=\(brandIdArray)&search=\(endChar)"
        print("Fetching categories with URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let authToken = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponseCat.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchCartItems(completion: @escaping (Result<CartResponse, Error>) -> Void) {
            guard let authToken = UserDefaults.standard.string(forKey: "authToken"), !authToken.isEmpty else {
                completion(.failure(NSError(domain: "Auth Error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
                return
            }
         let cartURL = URL(string: "https://goappadmin.zapto.org/api/cart-item")!
            var request = URLRequest(url: cartURL)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "Data Error", code: 400, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(CartResponse.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
    func updateCartOnServer(completion: @escaping (Bool, String?) -> Void) {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken"), !authToken.isEmpty else {
            completion(false, "Error: User not logged in.")
            return
        }

        // Retrieve locally stored cart items
        let existingCartItems = UserDefaults.standard.array(forKey: "cart") as? [[String: Any]] ?? []
        print("Existing Cart Items from UserDefaults:", existingCartItems)
        
        let url = URL(string: "https://goappadmin.zapto.org/api/cart-item/update")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        let requestBody: [String: Any] = ["cart": existingCartItems]
        print("Updating Cart on Server with:", requestBody)
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Error updating cart: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Cart updated successfully on server.")
                    completion(true, nil)
                } else {
                    completion(false, "Failed to update cart. Status code: \(httpResponse.statusCode)")
                }
            } else {
                completion(false, "Unexpected server response.")
            }
        }.resume()
    }

    
    func fetchCompanyAddresses(authToken: String, completion: @escaping (Result<[CompanyAddress], Error>) -> Void) {
            guard let url = URL(string: "https://goappadmin.zapto.org/api/company-address") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0)))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(CompanyAddressResponse.self, from: data)
                    if decodedResponse.status {
                        // Return the addresses or empty array if nil
                        completion(.success(decodedResponse.company_addresses ?? []))
                    } else {
                        let apiError = NSError(domain: "API Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "API returned status = false"])
                        completion(.failure(apiError))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
    func postCompanyAddresses(requestBody: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void) {
           guard let authToken = UserDefaults.standard.string(forKey: "authToken"), !authToken.isEmpty else {
               completion(.failure(NSError(domain: "User not logged in.", code: 401, userInfo: nil)))
               return
           }
           
           guard let url = URL(string: "https://goappadmin.zapto.org/api/company-address/update") else {
               completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
               return
           }
        print("token \(authToken)")

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")

           do {
               let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
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
                   completion(.failure(NSError(domain: "No data in response", code: 500, userInfo: nil)))
                   return
               }

               do {
                   if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                       completion(.success(jsonResponse))
                   } else {
                       completion(.failure(NSError(domain: "Invalid response format", code: 500, userInfo: nil)))
                   }
               } catch {
                   completion(.failure(error))
               }
           }.resume()
       }
   }
