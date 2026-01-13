//
//  FiltersViewModel.swift
//  Tracker
//
//  Created by МAK on 11.01.2026.
//

import Combine
import Foundation

final class FiltersViewModel {
    private enum StorageKeys {
        static let selectedFilterIndex = "selectedFilterIndex"
    }
    @Published var selectedFilterIndex: Int = 0 {
        didSet {
            UserDefaults.standard.set(selectedFilterIndex, forKey: StorageKeys.selectedFilterIndex)
        }
    }
    @Published private(set) var filteredTrackers: [Tracker] = []
    @Published var selectedDate: Date = .init()
    @Published var searchText: String = ""
    var selectedCategory: TrackerCategory?
    var onFilteredTrackersUpdated: (() -> Void)?
    var onSingleTrackerUpdated: ((Tracker, Bool) -> Void)?
    private let trackersProvider: () -> [Tracker]
    private let isCompletedProvider: (Tracker, Date) -> Bool
    private let dateFilter: TrackersDateFilter
    private var cancellables = Set<AnyCancellable>()
    private var hasInitialDataLoaded = false
    private var isApplyingFilters = false
    private var lastAppliedDate: Date?
    private var lastAppliedFilterIndex: Int?
    private var applyFiltersWorkItem: DispatchWorkItem?
    
    init(trackersProvider: @escaping () -> [Tracker],
         isCompletedProvider: @escaping (Tracker, Date) -> Bool,
         dateFilter: TrackersDateFilter) {
        self.trackersProvider = trackersProvider
        self.isCompletedProvider = isCompletedProvider
        self.dateFilter = dateFilter
        self.selectedFilterIndex = UserDefaults.standard.integer(forKey: StorageKeys.selectedFilterIndex)
        setupFilteringPipeline()
    }
    
    private func setupFilteringPipeline() {
        Publishers.CombineLatest3($selectedDate, $selectedFilterIndex, $searchText)
            .debounce(for: .milliseconds(150), scheduler: DispatchQueue.main)
            .sink { [weak self] date, _, _ in
                guard let self, self.hasInitialDataLoaded else { return }
                self.applyAllFiltersDebounced(for: date)
            }
            .store(in: &cancellables)
    }
    func setInitialDataLoaded() {
        hasInitialDataLoaded = true
        applyAllFiltersDebounced(for: selectedDate)
    }
    func applyAllFiltersDebounced(for date: Date) {
        applyFiltersWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.applyAllFiltersOnce(for: date)
        }
        applyFiltersWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: workItem)
    }
    private func applyAllFiltersOnce(for date: Date) {
        if lastAppliedDate == date && lastAppliedFilterIndex == selectedFilterIndex {
            
            return
        }
        lastAppliedDate = date
        lastAppliedFilterIndex = selectedFilterIndex
        applyAllFilters(for: date)
    }
    func applyAllFilters(for date: Date) {
        guard !isApplyingFilters else { return }
        isApplyingFilters = true
        defer { isApplyingFilters = false }

        var trackers = trackersProvider()
        trackers = dateFilter.filterTrackersByDay(trackers, date: date)
        trackers = dateFilter.filterTrackersByIndex(
            trackers,
            selectedFilterIndex: selectedFilterIndex,
            currentDate: date,
            searchText: searchText,
            completionChecker: isCompletedProvider
        )

        if trackers.map({ $0.id }) != filteredTrackers.map({ $0.id }) {
            filteredTrackers = trackers
            onFilteredTrackersUpdated?()
        }
    }
    func selectFilter(index: Int) {
        selectedFilterIndex = index
    }
    func updateTracker(_ tracker: Tracker) {
        if let index = filteredTrackers.firstIndex(where: { $0.id == tracker.id }) {
            filteredTrackers[index] = tracker
            onFilteredTrackersUpdated?()
        } else {
        }
    }
    func updateSingleTracker(_ tracker: Tracker, completed: Bool) {
        onSingleTrackerUpdated?(tracker, completed)
    }
}
