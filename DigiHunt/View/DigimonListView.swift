import SwiftUI

struct DigimonListView: View {
    @StateObject var digimonViewModel = DigimonViewModel(
        apiManager: APIServiceManager())
    
    var body: some View {
        TabView {
            NavigationStack {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.3), Color.cyan.opacity(0.3),
                        ]),
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    VStack {
                        switch digimonViewModel.digimonViewState {
                        case .loading:
                            ProgressView("Loading Digimons...")
                                .frame(width: 200, height: 200)
                                .font(.title2)
                                .foregroundColor(.blue)
                        case .loaded(let digimonList):
                            showDigimonList(digimonList: digimonList)
                        case .error(let error):
                            showError(error: error)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .ignoresSafeArea()
                    .searchable(
                        text: $digimonViewModel.searchWord,
                        prompt: "Search Digimon"
                    )
                    .onAppear {
                        digimonViewModel.fetchDigimon()
                    }
                    .padding()
                    .navigationTitle("Digimon List")
                }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            Text("Favorites")
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
    
    @ViewBuilder
    func showDigimonList(digimonList: [Digimon]) -> some View {
        if digimonList.isEmpty {
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                Text("No Digimon Found")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(digimonList) { digimon in
                NavigationLink {
                    DigimonDetailView(digimon: digimon, digimonViewModel: digimonViewModel)
                } label: {
                    HStack {
                        DigimonListCell(digimon: digimon)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func showError(error: Error) -> some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Failed to load Digimon")
                .font(.headline)
                .foregroundColor(.red)
            Text("\(error.localizedDescription)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    DigimonListView()
}
