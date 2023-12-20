//
//  AnimatedTabBar.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 26/10/2023.
//

import SwiftUI

struct AnimatedTabBar: View {

    @State private var activeTab: Tab = .photos
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap {
        AnimatedTab(tab: $0)
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                NavigationStack {
                    VStack {

                    }
                    .navigationTitle(Tab.photos.title)
                }
                .setUpTab(.photos)

                NavigationStack {
                    VStack {

                    }
                    .navigationTitle(Tab.chat.title)
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
                    VStack {

                    }
                    .navigationTitle(Tab.profile.title)
                }
                .setUpTab(.profile)
            }
            CustomTabBar()
        }
    }

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
                .padding(.top, 15)
                .padding(.bottom, 10)
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

#Preview {
    AnimatedTabBar()
}

enum Tab: String, CaseIterable {
    case photos = "photo.stack"
    case chat = "bubble.left.and.text.bubble.right"
    case apps = "square.3.layers.3d"
    case notifications = "bell.and.waves.left.and.right"
    case profile = "person.2.crop.square.stack.fill"

    var title: String {
        switch self {
        case .photos:
            return "photos"
        case .chat:
            return "chat"
        case .apps:
            return "apps"
        case .notifications:
            return "notifications"
        case .profile:
            return "profile"
        }
    }
}

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}

extension View {

    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
