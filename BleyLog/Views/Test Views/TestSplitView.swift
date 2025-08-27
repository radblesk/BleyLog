//
//  TestSplitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 25/08/2025.
//

import SwiftUI

// MARK: - Data Models (Identifiable & Hashable for selection)
struct Location: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let items: [Folder]
}

struct Folder: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

// MARK: - Main View
struct TestSplitView: View {
    /// An enum to identify your tabs
    enum Tab {
        case browse, recent, shared
    }
    /// An enum for each Tab that tracks the views of the Tab
    enum HomeNavigation: Hashable {
        case child, secondChild
    }

    // MARK: State
    /// State for the selected tab
    @State private var selectedTab: Tab = .browse

    /// Declare navigationStacks for each of the tabs
    @State private var homeNavigationStack: [HomeNavigation] = []

    /// State for the NavigationSplitView's selections. This is what we need to reset.
    @State private var sidebarSelection: Location.ID?
    @State private var contentSelection: Folder.ID?

    /// State for path
    @State private var path = NavigationPath()

    // Sample Data
    let locations = [
        Location(
            name: "iCloud Drive",
            items: [Folder(name: "Documents"), Folder(name: "Downloads")]
        ),
        Location(
            name: "On My iPhone",
            items: [Folder(name: "Pages"), Folder(name: "Keynote")]
        ),
    ]

    /// A custom binding to intercept tab selection changes.
    private var tabSelection: Binding<Tab> {
        Binding {
            // Standard getter
            self.selectedTab
        } set: { tappedTab in
            // This 'set' block runs when a tab is tapped.

            // If the user tapped the tab that was already active...
            if tappedTab == self.selectedTab {
                // ...reset the navigation state for that tab.
                print("Browse tab re-tapped. Resetting navigation state.")
                sidebarSelection = nil
                contentSelection = nil
            }

            // Finally, always update the selected tab.
            self.selectedTab = tappedTab
        }
    }

    // MARK: - Sidebar View
    fileprivate func sidebarView() -> NavigationStack<NavigationPath, some View>
    {
        return NavigationStack(path: $path) {
            List(locations, selection: $sidebarSelection) {
                location in
                // Use .tag() to link selection to the item's ID
                NavigationLink(location.name, value: location.id)
                    .navigationDestination(
                        for: Location.ID.self
                    ) { value in
                        if value == location.id {
                            contentView()
                        }
                    }
            }
            .navigationTitle("Locations")
        }
    }

    // MARK: - Content View
    fileprivate func contentView() -> NavigationStack<
        NavigationPath, _ConditionalContent<some View, Text>
    > {
        return  // Find the selected location from the ID
            NavigationStack(path: $path) {
                if let sidebarSelection,
                    let location = locations.first(where: {
                        $0.id == sidebarSelection
                    })
                {
                    List(location.items, selection: $contentSelection) {
                        folder in
                        NavigationLink(folder.name, value: folder.id)
                            .navigationDestination(
                                for: Folder.ID.self
                            ) { value in
                                if value == folder.id {
                                    detailView()
                                }
                            }
                    }
                    .navigationTitle(location.name)
                } else {
                    Text("Select a Location")
                }
            }
    }

    // MARK: - Detail View
    fileprivate func detailView() -> NavigationStack<
        NavigationPath, _ConditionalContent<some View, Text>
    > {
        return  // Find the selected folder from the ID
            NavigationStack(path: $path) {
                if let contentSelection,
                    let location = locations.first(where: {
                        $0.id == sidebarSelection
                    }),
                    let folder = location.items.first(where: {
                        $0.id == contentSelection
                    })
                {
                    Text("Details for \(folder.name)")
                        .navigationTitle(folder.name)
                } else {
                    Text("Select a Folder")
                }
            }
    }

    var body: some View {
        // Use our custom binding for the TabView selection
        TabView(selection: tabSelection) {

            // MARK: - Browse Tab
            NavigationSplitView(
                sidebar: {
                    sidebarView()
                },
                content: {
                    contentView()
                },
                detail: {
                    detailView()
                }
            )
            .tabItem {
                Label("Browse", systemImage: "folder.fill")
            }
            .tag(Tab.browse)

            // MARK: - Other Tabs
            Text("Recent")
                .tabItem { Label("Recent", systemImage: "clock.fill") }
                .tag(Tab.recent)

            Text("Shared")
                .tabItem { Label("Shared", systemImage: "person.2.fill") }
                .tag(Tab.shared)
        }
    }
}

#Preview {
    TestSplitView()
}
