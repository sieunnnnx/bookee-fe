//
//  TermViewModel.swift
//  Bookee
//
//  Created by sieunnnx on 5/12/26.
//

import Foundation
import Combine

@MainActor
final class TermViewModel: ObservableObject {
    
    @Published var terms: [TermItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var isAllChecked: Bool {
        !terms.isEmpty && terms.allSatisfy { $0.isChecked }
    }
    
    var isAllRequiredChecked: Bool {
        let requiredTerms = terms.filter { $0.required }
        return !requiredTerms.isEmpty && requiredTerms.allSatisfy { $0.isChecked }
    }
    
    var termAgreements: [TermAgreement] {
        terms.map {
            TermAgreement(termId: $0.termId, agreed: $0.isChecked)
        }
    }
    
    func toggleAll() {
        let newValue = !isAllChecked
        terms = terms.map {
            var term = $0
            term.isChecked = newValue
            return term
        }
    }
    
    func toggleTerm(_ term: TermItem) {
        if let index = terms.firstIndex(where: { $0.id == term.id }) {
            terms[index].isChecked.toggle()
        }
    }
    
    func fetchTerms() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await APIClient.shared.request(
                endpoint: TermEndpoint.terms,
                responseType: [TermResponse].self
            )
            
            terms = response.map {
                TermItem(
                    termId: $0.termId,
                    title: $0.title,
                    required: $0.required
                )
            }
            
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
        }
    }
}
