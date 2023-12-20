//
//  Completions.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 18.09.2023.
//

import Foundation

typealias MKREmptyBlock = () -> Void
typealias MKRIntBlock = (Int) -> Void
typealias MKRResultBlock<T> = (Result<T, Error>) -> Void
