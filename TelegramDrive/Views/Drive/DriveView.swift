import SwiftUI

public struct DriveView: View {
    @EnvironmentObject var state: AppState

    @State private var isShowingSearch: Bool = false
    @State private var isShowingSpeedDial: Bool = false
    @State private var isShowingDocumentPicker: Bool = false
    @State private var isVaultUpload: Bool = false
    @State private var selectedFileForDetail: DriveFile? = nil

    private var colors: ThemeColors {
        ThemeManager.colors(for: state.currentTheme)
    }

    private let gridColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 14) {
                    // Top App Bar
                    topAppBar

                    // Search Bar (if toggled)
                    if isShowingSearch {
                        searchBarView
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // Unlimited Cloud Storage Metric Banner
                    storageMetricBanner

                    // Folder Selection Chips Strip
                    folderSelectionStrip

                    // Category Filter Strip
                    categoryFilterStrip

                    // Files Content (Empty State or Grid/List)
                    if state.filteredFiles.isEmpty {
                        realEmptyStateView
                    } else {
                        filesContentView
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 90) // space for bottom dock
            }

            // Speed Dial & FAB
            floatingSpeedDialView

            // Multi-Select Floating Bar (if files selected)
            if !state.selectedFileIds.isEmpty {
                multiSelectBarView
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(colors.background.ignoresSafeArea())
        .fileImporter(
            isPresented: $isShowingDocumentPicker,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                state.intakeFiles(urls: urls, isVault: isVaultUpload)
                isVaultUpload = false
            case .failure(let err):
                state.showToast("File selection canceled: \(err.localizedDescription)")
            }
        }
        .sheet(item: $selectedFileForDetail) { file in
            FileDetailSheet(file: file, colors: colors)
                .environmentObject(state)
        }
    }

    // MARK: - Top App Bar
    private var topAppBar: some View {
        HStack(spacing: 12) {
            // User Avatar
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(LinearGradient(colors: [colors.accentCyan, colors.accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 38, height: 38)
                Text("TG")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(.white)
                Circle()
                    .fill(colors.accentEmerald)
                    .frame(width: 9, height: 9)
                    .overlay(Circle().stroke(colors.background, lineWidth: 1.5))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Telegram Drive")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colors.textPrimary)
                HStack(spacing: 5) {
                    Circle()
                        .fill(colors.accentEmerald)
                        .frame(width: 6, height: 6)
                    Text(state.activeFolder.name)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(colors.textSecondary)
                }
            }

            Spacer()

            // Search Toggle
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isShowingSearch.toggle()
                    if !isShowingSearch { state.searchQuery = "" }
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(isShowingSearch ? colors.accentCyan : colors.textPrimary)
                    .padding(8)
                    .background(colors.surfaceElevated)
                    .cornerRadius(10)
            }

            // Grid / List Toggle
            Button(action: {
                withAnimation { state.isGridView.toggle() }
                state.showToast(state.isGridView ? "Grid layout active" : "List layout active")
            }) {
                Image(systemName: state.isGridView ? "square.grid.2x2" : "list.bullet")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(colors.textPrimary)
                    .padding(8)
                    .background(colors.surfaceElevated)
                    .cornerRadius(10)
            }
        }
    }

    // MARK: - Search Bar
    private var searchBarView: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(colors.textDim)
            TextField("Search in this folder...", text: $state.searchQuery)
                .foregroundColor(colors.textPrimary)
                .font(.system(size: 13))
            if !state.searchQuery.isEmpty {
                Button(action: { state.searchQuery = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(colors.textDim)
                }
            }
        }
        .padding(10)
        .background(colors.surface)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(colors.border, lineWidth: 1))
    }

    // MARK: - Unlimited Cloud Storage Banner
    private var storageMetricBanner: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(colors.accentCyan)
                    .frame(width: 8, height: 8)
                Text("Telegram Cloud")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(colors.textPrimary)
                Text("UNLIMITED")
                    .font(.system(size: 9, weight: .heavy))
                    .foregroundColor(colors.accentCyan)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(colors.accentCyan.opacity(0.12))
                    .cornerRadius(6)
            }

            Spacer()

            HStack(spacing: 6) {
                Text("\(state.files.count) files · \(state.formattedStorageUsed)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(colors.textSecondary)
                Text("🔒 Vault")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.accentEmerald)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(colors.accentEmerald.opacity(0.12))
                    .cornerRadius(6)
            }
        }
        .padding(12)
        .background(colors.surface)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(colors.border, lineWidth: 1))
    }

    // MARK: - Folder Selection Strip
    private var folderSelectionStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Cloud Storage Folders")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(colors.textDim)
                    .textCase(.uppercase)
                Spacer()
                Button(action: {
                    state.createFolder(title: "New Projects")
                }) {
                    Text("+ New Folder")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(colors.accentCyan)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(state.folders) { folder in
                        Button(action: {
                            state.activeFolder = folder
                            state.showToast("Folder: \(folder.name)")
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: folder.icon)
                                    .font(.system(size: 12))
                                    .foregroundColor(folder.isVault ? colors.accentEmerald : colors.accentCyan)
                                Text(folder.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(state.activeFolder.id == folder.id ? .white : colors.textPrimary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(state.activeFolder.id == folder.id ? colors.accentCyan.opacity(0.25) : colors.surface)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(state.activeFolder.id == folder.id ? colors.accentCyan : colors.border, lineWidth: 1)
                            )
                        }
                    }
                }
            }
        }
    }

    // MARK: - Category Filter Strip
    private var categoryFilterStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(FileCategory.allCases) { cat in
                    Button(action: {
                        state.activeCategory = cat
                    }) {
                        Text("\(cat.displayName) (\(state.countForCategory(cat)))")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(state.activeCategory == cat ? .white : colors.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(state.activeCategory == cat ? colors.accentCyan : colors.surface)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(state.activeCategory == cat ? Color.clear : colors.border, lineWidth: 1)
                            )
                    }
                }
            }
        }
    }

    // MARK: - Real Empty State
    private var realEmptyStateView: some View {
        VStack(spacing: 14) {
            Image(systemName: "icloud.and.arrow.up.fill")
                .font(.system(size: 46))
                .foregroundColor(colors.accentCyan.opacity(0.8))
                .padding(.top, 24)

            Text("Your Telegram Drive is Empty")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(colors.textPrimary)

            Text("Upload files to store them securely in your Telegram cloud with 2GB limit per file.")
                .font(.system(size: 12))
                .foregroundColor(colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Button(action: {
                isVaultUpload = false
                isShowingDocumentPicker = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 13, weight: .bold))
                    Text("Upload Real Files")
                        .font(.system(size: 13, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(colors.accentCyan)
                .cornerRadius(12)
            }
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(colors.surface)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(colors.border, style: StrokeStyle(lineWidth: 1, dash: [6])))
        .padding(.top, 10)
    }

    // MARK: - Files Grid / List Content
    private var filesContentView: some View {
        Group {
            if state.isGridView {
                LazyVGrid(columns: gridColumns, spacing: 12) {
                    ForEach(state.filteredFiles) { file in
                        FileGridCard(
                            file: file,
                            isSelected: state.selectedFileIds.contains(file.id),
                            colors: colors,
                            onTap: {
                                if !state.selectedFileIds.isEmpty {
                                    state.toggleSelection(file.id)
                                } else {
                                    selectedFileForDetail = file
                                }
                            },
                            onLongPress: {
                                state.toggleSelection(file.id)
                            }
                        )
                    }
                }
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(state.filteredFiles) { file in
                        FileListRow(
                            file: file,
                            isSelected: state.selectedFileIds.contains(file.id),
                            colors: colors,
                            onTap: {
                                if !state.selectedFileIds.isEmpty {
                                    state.toggleSelection(file.id)
                                } else {
                                    selectedFileForDetail = file
                                }
                            },
                            onLongPress: {
                                state.toggleSelection(file.id)
                            }
                        )
                    }
                }
            }
        }
    }

    // MARK: - Floating Speed Dial & FAB
    private var floatingSpeedDialView: some View {
        VStack(alignment: .trailing, spacing: 12) {
            if isShowingSpeedDial {
                // Vault Upload Action
                Button(action: {
                    isShowingSpeedDial = false
                    isVaultUpload = true
                    isShowingDocumentPicker = true
                }) {
                    HStack(spacing: 8) {
                        Text("Encrypted Vault Upload")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(colors.textPrimary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(colors.surfaceElevated)
                            .cornerRadius(8)
                        Circle()
                            .fill(colors.accentEmerald)
                            .frame(width: 44, height: 44)
                            .overlay(Image(systemName: "lock.shield.fill").foregroundColor(.white))
                    }
                }

                // Normal File Upload Action
                Button(action: {
                    isShowingSpeedDial = false
                    isVaultUpload = false
                    isShowingDocumentPicker = true
                }) {
                    HStack(spacing: 8) {
                        Text("Upload Documents")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(colors.textPrimary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(colors.surfaceElevated)
                            .cornerRadius(8)
                        Circle()
                            .fill(colors.accentBlue)
                            .frame(width: 44, height: 44)
                            .overlay(Image(systemName: "doc.fill").foregroundColor(.white))
                    }
                }
            }

            // Main FAB
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isShowingSpeedDial.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [colors.accentCyan, colors.accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 56, height: 56)
                        .shadow(color: colors.accentCyan.opacity(0.4), radius: 10, y: 5)
                    Image(systemName: isShowingSpeedDial ? "xmark" : "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 80)
    }

    // MARK: - Multi-Select Floating Bar
    private var multiSelectBarView: some View {
        HStack {
            Text("\(state.selectedFileIds.count) selected")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(colors.textPrimary)

            Spacer()

            Button(action: {
                state.deleteSelected()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "trash.fill")
                    Text("Delete")
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(colors.accentRose)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(colors.accentRose.opacity(0.15))
                .cornerRadius(8)
            }

            Button(action: {
                state.clearSelection()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(colors.textDim)
                    .padding(8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(colors.surfaceElevated)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(colors.border, lineWidth: 1))
        .padding(.horizontal)
        .padding(.bottom, 80)
    }
}
