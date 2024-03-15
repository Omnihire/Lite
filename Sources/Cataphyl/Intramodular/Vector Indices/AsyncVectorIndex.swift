//
// Copyright (c) Vatsal Manot
//

import LargeLanguageModels
import Swallow

public protocol AsyncVectorIndex<Key> {
    associatedtype Key: Hashable
    
    func query<Query: VectorIndexQuery<Key>>(
        _ query: Query
    ) async throws -> [VectorIndexSearchResult<Self>]
}

public protocol MutableAsyncVectorIndex<Key>: AsyncVectorIndex {
    mutating func insert(
        contentsOf pairs: some Sequence<(Key, [Double])>
    ) async throws
    
    mutating func remove(
        _ items: Set<Key>
    ) async throws
    
    mutating func removeAll() async throws
}

// MARK: - Extensions -

extension MutableAsyncVectorIndex {
    public mutating func insert(
        _ vector: [Double],
        forKey key: Key
    ) async throws {
        try await insert(contentsOf: [(key, vector)])
    }
    
    public mutating func insert(
        contentsOf pairs: some Sequence<(Key, _RawTextEmbedding)>
    ) async throws {
        try await insert(contentsOf: pairs.lazy.map({ ($0, $1.rawValue) }))
    }
    
    public mutating func remove(
        forKey key: Key
    ) async throws {
        try await remove([key])
    }
}
