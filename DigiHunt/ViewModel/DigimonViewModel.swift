//
//  DigimonViewModel.swift
//  DigiHunt
//
//  Created by Sahil ChowKekar on 3/3/25.
//

import Combine
import Foundation

enum DigimonViewState: Equatable {
    case loading
    case loaded([Digimon])
    case error(Error)
    
    static func == (lhs: Self, rhs: Self) -> Bool{
        switch(lhs,rhs){
            
        case(.loading, .loading):
            return true
            
        case(.error(let lError), .error(let rError)):
            return lError.localizedDescription == rError.localizedDescription
        
        default:
            return true
        }
    }
}

class DigimonViewModel: ObservableObject {

    @Published var digimonList: [Digimon] = []
    private var originalDigimonList: [Digimon] = []
    @Published var digimonViewState: DigimonViewState = .loading
    @Published var searchWord: String = ""
    @Published var favsDigimonList: [Digimon] = []
    @Published var favoriteDigimons: [Digimon] = []
    

    private var cancelable = Set<AnyCancellable>()

    let apiManager: APIService

    init(apiManager: APIService) {
        self.apiManager = apiManager
        setUpSearchBinding()
    }

    func setUpSearchBinding() {
        $searchWord
            //            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { searchText in
                self.filterDigimon(searchText: searchText)

            }.store(in: &cancelable)
    }

    func filterDigimon(searchText: String) {
        if searchText.isEmpty {
            self.digimonList = self.originalDigimonList
            self.digimonViewState = .loaded(self.digimonList)
        } else {
            self.digimonList = self.originalDigimonList.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            self.digimonViewState = .loaded(self.digimonList)
        }
    }

    func fetchDigimon() {
        self.apiManager.fetchDataFromURL(
            url: APIConstants.DigimonEndPoint, modelType: [Digimon].self
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {

            case .finished:
                print("Task is finished")
            case .failure(let error):
//                self.digimonViewState = .error(error)
                switch error {
                case is DecodingError:
                    self.digimonViewState = .error(APIError.parsingError)
                case APIError.invalidURLError:
                    self.digimonViewState = .error(APIError.invalidURLError)
                case APIError.noDataError:
                    self.digimonViewState = .error(APIError.noDataError)
                case APIError.responsError(let code):
                    self.digimonViewState = .error(APIError.responsError(code))
                case APIError.parsingError:
                    self.digimonViewState = .error(APIError.parsingError)
                    
                default:
                    self.digimonViewState = .error(APIError.noDataError)
                }
            }
        } receiveValue: { [weak self] list in
            print(list)
            self?.digimonList = list
            self?.digimonViewState = .loaded(list)
            self?.originalDigimonList = list

        }.store(in: &cancelable)

    }

    func cancelOnGoingRequests() {
        cancelable.first?.cancel()
    }
    
    func addToFavs(_ digimon: Digimon) {
        favsDigimonList.append(digimon)
    }
    
    func favoriteDigimon(digimon: Digimon) {
            if let index = favoriteDigimons.firstIndex(where: { $0.id == digimon.id }) {
                favoriteDigimons.remove(at: index) // Remove if already in favorites
            } else {
                favoriteDigimons.append(digimon) // Add if not in favorites
            }
        }
        
        // MARK: - Check if a Digimon is Favorite
        func isFavorite(digimon: Digimon) -> Bool {
            return favoriteDigimons.contains { $0.id == digimon.id }
        }
}
