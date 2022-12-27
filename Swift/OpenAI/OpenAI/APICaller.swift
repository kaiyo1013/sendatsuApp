//
//  APICaller.swift
//  OpenAI
//
//  Created by 富永開陽 on 2022/12/14.
//

import Foundation
import OpenAISwift

final class APICaller {
    
    static let shared = APICaller()
    
    private var client: OpenAISwift?
    
    private init() {}
    
    public func setUp() {
        self.client = OpenAISwift(authToken: "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")
    }
    
    public func getResponse(input: String, completion: @escaping(Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, completionHandler: { result in
            switch result{
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
