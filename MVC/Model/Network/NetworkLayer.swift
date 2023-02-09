//
//  NetworkLayer.swift
//  homework4.4
//
//  Created by Zhansuluu Kydyrova on 4/1/23.
//

import UIKit

final class NetworkLayer {
    
    static let shared = NetworkLayer()
    private init() { }
    
    var baseURL = URL(string: "https://dummyjson.com/products")
    
    func decodeOrderTypeData(_ json: String) -> [OrderTypeModel] {
        var orderTypeModelArray = [OrderTypeModel]()
        let orderTypeData = Data(json.utf8)
        let jsonDecoder = JSONDecoder()
        do { let orderTypeModelData = try jsonDecoder.decode([OrderTypeModel].self, from: orderTypeData)
            orderTypeModelArray = orderTypeModelData
        } catch {
            print(error.localizedDescription)
        }
        return orderTypeModelArray
    }
    
    
    
// RX GET
    func fetchProductsData() -> Observable<[ProductModel]> {
            return Observable<[ProductModel]>.create { [unowned self] observer in
                let task = URLSession.shared.dataTask(with: self.baseURL) { data, _, _ in
                    do {
                        guard let data = data else { return }
                        let model = try JSONDecoder().decode(MainProductModel.self, from: data)
                        observer.onNext(model.products)
                    } catch {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
                task.resume()
                return Disposables.create {
                    task.cancel()
                }
            }
        }
    
// -Async GET-
//    func fetchProductsData() async throws -> MainProductModel {
//        let (data, _) = try await URLSession.shared.data(from: baseURL!)
//        return try await decodeData(data: data)
//    }
    
// Async Decode
    func decodeData<T: Decodable>(data:Data) async throws -> T {
        let decoder = JSONDecoder()
        return try! decoder.decode(T.self, from: data)
    }

//Async encode
    func encodeData<T: Encodable>(product: T) async throws -> Data {
        let encoder = JSONEncoder()
        return try! encoder.encode(product)
    }
    
// Async POST
    func postProductsData(model: ProductModel) async throws -> Data {
        var encodedProductModel: Data?
        encodedProductModel = try await encodeData(product: model)
        var request = URLRequest(url: baseURL!.appendingPathComponent("add"))
        request.httpMethod = "POST"
        request.httpBody = encodedProductModel
// Метод с StackOverflow
        let (data, _) = try await URLSession.shared.upload(for: request, from: encodedProductModel!, delegate: nil)
        return data
    }
    
// Async PUT
    func putProductsData(id: Int) async throws -> Data {
        var encodedProductModel: Data?
        encodedProductModel = try await encodeData(product: encodedProductModel)
        var request = URLRequest(url: baseURL!.appendingPathComponent("\(id)"))
        request.httpMethod = "PUT"
        request.httpBody = encodedProductModel
        let (data, _) = try await URLSession.shared.upload(for: request, from: encodedProductModel!)
        return data
        }
    
// Async DELETE
    func deleteProductsData(id: Int) async throws -> Data {
        var encodedProductModel: Data?
        encodedProductModel = try await encodeData(product: encodedProductModel)
        var request = URLRequest(url: baseURL!.appendingPathComponent("\(id)"))
        request.httpMethod = "DELETE"
        let (data, _) = try await URLSession.shared.upload(for: request, from: encodedProductModel!)
        return data
    }
}

