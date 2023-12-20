//
//  MainView.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 13.09.2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State private var showAlert = (show: false, message: "")
    @State private var pullRequest = (needStart: false, isStart: false)
    @State private var offsetY: CGFloat = 0 {
        didSet {
            if !pullRequest.needStart && pullRequest.isStart && offsetY == 0 {
                pullRequest.isStart = false
            }
        }
    }

    @State private var activeTab: Tab = .photos
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap {
        AnimatedTab(tab: $0)
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                NavigationStack {
                    MainViewList()
                }
                .setUpTab(.photos)

                NavigationStack {
                    FollowingList()
                }
                .setUpTab(.chat)

                NavigationStack {
                    VStack {

                    }
                    .navigationTitle(Tab.apps.title)
                }
                .setUpTab(.apps)

                NavigationStack {
                    VStack {

                    }
                    .navigationTitle(Tab.notifications.title)
                }
                .setUpTab(.notifications)

                NavigationStack {
                    PersonCabinet()
                }
                .setUpTab(.profile)
            }
            CustomTabBar()
        }
        .environmentObject(viewModel)
    }
}

// MARK: - MainView

private extension MainView {

    @ViewBuilder
    func MainViewList() -> some View {
        VStack {
            if showAlert.show {
                NotConnectedView(errorMessage: showAlert.message, handler: FetchData)
            } else {
                GeometryReader { proxy in
                    let cityWidth = proxy.size.width  / .divider - .gridSpacer / .divider - .borderWidth * 4
                    if pullRequest.needStart {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    ScrollView(showsIndicators: false) {
                        VStack {
                            AuthorsScroll()
                            Divider()
                                .foregroundStyle(.foreground)
                            CitiesScroll(cityWidth)
                        }
                        .offset(coordingateSpace: .named("SCROLL")) { offset in
                            pullRequest.needStart = offset > 72
                            offsetY = offset
                            if !pullRequest.isStart && pullRequest.needStart {
                                FetchData()
                            }
                        }
                    }
                    .coordinateSpace(name: "SCROLL")
                }
                .navigationTitle("Викинги")
            }
        }
        .onAppear(perform: FetchData)
        .environmentObject(viewModel)
    }
}

private extension MainView {
    
    /// Скролл вью авторов
    func AuthorsScroll() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.authorViewModel.authors) { author in
                    NavigationLink {
                        AuthorView(author: author)
                    } label: {
                        AuthorCircle(
                            username: author.id == viewModel.currentUser.id
                            ? .yourName
                            : author.authorName,
                            imageConfiguration: .authorImageConfiguration(url: author.imageURL)
                        )
                    }
                }
            }
            .padding(.vertical, .lineWidth * 2)
            .padding(.horizontal)
        }
    }
    
    /// Скролл вью городов
    @ViewBuilder
    func CitiesScroll(_ cityWidth: CGFloat) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(
                columns: [
                    GridItem(
                        .fixed(cityWidth),
                        spacing: .gridSpacer
                    ),
                    GridItem(
                        .fixed(cityWidth),
                        spacing: .zero
                    )
                ],
                spacing: 10
            ) {
                ForEach(viewModel.cityViewModel.cities) { city in
                    NavigationLink {
                        DetailCityView(city: city)
                        
                    } label: {
                        CityView(
                            cityName: city.cityName ?? .emptyCity,
                            imageConfiguration: .cityImageConfiguration(
                                url: city.imageURL,
                                imageSize: CGSize(width: cityWidth, height: 150)
                            )
                        )
                        .borderRectangle(.primary, .cityImageCornerRadius, .borderWidth)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 5)
            .padding(.top, 10)
        }
    }
}

// MARK: - Network

private extension MainView {

    func FetchData() {
        print("FETCH")
        if pullRequest.needStart {
            pullRequest.isStart = true
        }
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            NetworkService.shared.request(
                router: .cities,
                method: .get,
                type: CitiesEntity.self,
                parameters: nil) { result in
                    switch result {
                    case .success(let city):
                        viewModel.cityViewModel = city.mapper
                        group.leave()
                    case .failure(let error):
                        showAlert.message = error.localizedDescription
                        showAlert.show = true
                        group.leave()
                    }
                }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            NetworkService.shared.request(
                router: .authors,
                method: .get,
                type: AuthorsEntity.self,
                parameters: nil) { result in
                    switch result {
                    case .success(let authors):
                        viewModel.authorViewModel = authors.mapper
                        guard let currentUser = viewModel.authorViewModel.authors.first else {
                            showAlert.message = "Не найден текущий пользователь"
                            showAlert.show = true
                            group.leave()
                            return
                        }
                        viewModel.currentUser = currentUser
                        group.leave()
                    case .failure(let error):
                        showAlert.message = error.localizedDescription
                        showAlert.show = true
                        group.leave()
                    }
                }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            NetworkService.shared.request(
                router: .userSubscriptions,
                method: .get,
                type: UserSubscriptionsEntity.self,
                parameters: ["user_id": viewModel.currentUser.id]
            ) { result in
                switch result {
                case .success(let userSubscriptions):
                    viewModel.currentUserSupliers = userSubscriptions.subscriptionsIdArray
                    showAlert.show = false
                    group.leave()

                case .failure(let error):
                    showAlert.message = error.localizedDescription
                    showAlert.show = true
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            pullRequest.needStart = false
            showAlert.show = false
        }
    }
}

// MARK: - Image Configuration

private extension MKRImageView.Configuration {
    
    static func authorImageConfiguration(
        url: URL?
    ) -> Self {
        .basic(
            kind: .custom(
                url: url,
                mode: .fill,
                imageSize: .imageSize,
                imageCornerRadius: .imageCornerRadius,
                imageBorderWidth: .zero,
                imageBorderColor: nil,
                placeholderLineWidth: .zero,
                placeholderImageSize: .zero
            )
        )
    }
    
    static func cityImageConfiguration(
        url: URL?,
        imageSize: CGSize
    ) -> Self {
        .basic(
            kind: .custom(
                url: url,
                mode: .fill,
                imageSize: imageSize,
                imageCornerRadius: .cityImageCornerRadius,
                imageBorderWidth: .zero,
                imageBorderColor: nil,
                placeholderLineWidth: .cityPlaceholderLineWidth,
                placeholderImageSize:  min(imageSize.width, 25)
            )
        )
    }
}

// MARK: - Custom Bar

private extension MainView {

    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.down.byLayer, value: animatedTab.isAnimating)

                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 5)
//                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete) {
                        activeTab = tab
                        animatedTab.isAnimating = true
                    } completion: {
                        var trasnaction = Transaction()
                        trasnaction.disablesAnimations = true
                        withTransaction(trasnaction) {
                            animatedTab.isAnimating = nil
                        }
                    }
                }
            }
        }
        .background(.bar)
    }
}

// MARK: - Constants

private extension CGSize {

    static let imageSize = CGSize(edge: 82)
}

private extension String {

    static let emptyCity = "Название отсутсвует"
    static let yourName = "Вы"
}

private extension CGFloat {

    static let widthCard: CGFloat = 100
    static let divider: CGFloat = 2
    static let gridSpacer: CGFloat = 5
    static let heightCard: CGFloat = 100
    static let lineWidth: CGFloat = 2.5
    static let borderWidth: CGFloat = 1
    static let shadowRadius: CGFloat = 13
    static let imageCornerRadius: CGFloat = CGSize.imageSize.width / 2
    static let cityImageCornerRadius: CGFloat = 20
    static let cityPlaceholderLineWidth: CGFloat = 1
}

// MARK: - Preview

#Preview {
    MainView()
        .preferredColorScheme(.dark)
        .environmentObject(MainViewModel())
}

// MARK: - Test data

private extension CityViewModel {
    
    static let description = """
    Гарри Джеймс Поттер родился 31 июля 1980 года у волшебников Джеймса и Лили Поттеров. После рождения сына семья жила в укрытии, поскольку стало известно, что лорд Волан-де-Морт охотится за Гарри (см. «Пророчество»). Они жили в Годриковой впадине под защитой заклинания Фиделиус. Лучший друг Джеймса Поттера Сириус Блэк являлся крёстным отцом Гарри, и вначале планировали сделать хранителем его, но, по совету самого Сириуса, в последний момент и тайком ото всех сделали им Питера Петтигрю, который, как они считали, мог вызвать меньше подозрений. В этом была их фатальная ошибка, так как Петтигрю к этому моменту переметнулся к Волан-де-Морту. Он выдал место, где прятались Джеймс и Лили, Тёмному Лорду и тем обрёк их на смерть, а заодно и подставил Сириуса Блэка, который стал в глазах всех предателем.

    Вечером 31 октября 1981 года Тёмный Лорд появился в Годриковой впадине, чтобы убить Гарри. Джеймс пытался защитить семью, но погиб. Когда Волан-де-Морт уже собрался убить ребёнка, Лили встала на его пути, закрывая своим телом кроватку малыша. Безоружная, она кричала, что пусть лучше Тёмный Лорд убьёт её, а не сына. Волан-де-Морт, который сначала собирался оставить Лили в живых по просьбе Северуса Снегга, убил её, устраняя препятствие. Как он думал. Но магический контракт был произнесён и заключён, (убив Лили, Тёмный Лорд согласился с условиями этого контракта) и подписан материнской кровью, которую он пролил. Своею смертью Лили создала несокрушимый барьер для своего сына. И когда Волан-де-Морт применил убивающее заклятие к ребёнку, оно отразилось от него, и Волан-де-Морт потерял всю свою силу и исчез. Так Гарри стал единственным, кому удалось испытать на себе заклятье Авада Кедавра и выжить после этого. На память о событиях в Годриковой Впадине ему остался только шрам в виде молнии.
    """

    static let data = CityViewModel(cities: [
        CityModel(id: 0, cityName: "Просто город 1", imageURL: .spider2, description: description),
        CityModel(id: 1, cityName: "Просто город 2", imageURL: .spider3, description: description),
        CityModel(id: 2, cityName: "Просто город 3", imageURL: .mockDragonUrl, description: description),
        CityModel(id: 3, cityName: "Просто город 4", imageURL: .spider1, description: description),
        CityModel(id: 4, cityName: "Просто город 5", imageURL: .spider3, description: description),
        CityModel(id: 5, cityName: "Просто город 6", imageURL: .spider2, description: description),
        CityModel(id: 6, cityName: "Просто город 7", imageURL: .spider1, description: description),
        CityModel(id: 7, cityName: "Просто город 8", imageURL: .mockDragonUrl, description: description),
    ])
}

private extension AuthorViewModel {
    
    static let data = AuthorViewModel(authors: [
        AuthorModel(id: 0, authorName: "mightyKingRichard", post: "Директор", imageURL: .mockLoadingUrl),
        AuthorModel(id: 1, authorName: "king", post: "Директор", imageURL: .spider2),
        AuthorModel(id: 2, authorName: "legend", post: "Директор", imageURL: .spider3),
        AuthorModel(id: 3, authorName: "richard", post: "Директор", imageURL: .spider1),
        AuthorModel(id: 4, authorName: "poly", post: "Директор", imageURL: .spider1),
        AuthorModel(id: 5, authorName: "mark", post: "Директор", imageURL: .spider1),
        AuthorModel(id: 6, authorName: "blackElshad", post: "Директор", imageURL: nil),
        AuthorModel(id: 7, authorName: "aosimo", post: "Директор", imageURL: nil),
    ])
}
