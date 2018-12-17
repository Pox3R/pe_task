//
//  XMLToYAMLConverter.swift
//
//  Created by Eldar Goloviznin on 12/12/2018.
//

import Foundation
import SWXMLHash

/// An error that can occur on `XMLToYAMLConverter.convertToYAML(fromXML xml: String)` method calling.
fileprivate enum ConverterError: String, Error {
    
    /// There is no XML root in the input.
    case badInput
    /// There is no element in the node
    case elementNotFound
    
}

/// Class for building YAML-formatted string of given XML-formatted string.
final class XMLToYAMLConverter {
    
    /// There is no reason to create instance of `XMLToYAMLConverter`.
    private init() {
        fatalError("XMLToYAMLConverter should not be initialized")
    }
    
    // MARK: - Public methods
    
    /**
     Converts given XML string to YAML-formatted string.
     
     - Parameters:
        - xml: XML-formatted string.
     
     - Throws:
        - `ConverterError.badInput`:  if `xml` is invalid.
        - `ConverterError.elementNotFound`: if element not found
     
     - Returns: YAML-formatted string of given XML input.
     */
    static func convertToYAML(fromXML xml: String) throws -> String {
        let parsedXML = SWXMLHash.parse(xml)
        
        guard let rootIndexer = parsedXML.children.first else {
            throw ConverterError.badInput
        }
        
        return try process(indexer: rootIndexer)
    }
    
}

// MARK: - Private converter implementation

private extension XMLToYAMLConverter {
    
    /**
     Recursively called to build YAML-formatted string.
     
     - Parameters:
        - indexer: Indexer of current level root element.
        - level: An integer, which used to create prefix of `level` whitespaces.
        - shouldPrintName: A bool, which used to determine if `indexer` name should be printed, e.g. where given `indexer` is an element of list.
     
     - Throws:
         - `ConverterError.badInput`:  if `xml` is invalid.
         - `ConverterError.elementNotFound`: if element not found.
     
     - Returns: YAML-formatted string of given XML input.
     */
    static func process(indexer: XMLIndexer, level: Int = 0, shouldPrintName: Bool = true) throws -> String {
        guard let element = indexer.element else {
            throw ConverterError.elementNotFound
        }
        
        let childrenDictionary = try indexer.children.reduce(into: [String: [XMLIndexer]]()) { dictionary, indexer in
            guard let element = indexer.element else {
                throw ConverterError.elementNotFound
            }
            
            var indexers = dictionary[element.name] ?? []
            indexers.append(indexer)
            
            dictionary[element.name] = indexers
        }
        
        var output = String(repeating: " ", count: level)
        output += shouldPrintName ? "\(element.name): " : " "
        output += childrenDictionary.isEmpty ? element.text : ""
        
        if output.trimmingCharacters(in: [" "]).isEmpty {
            output = ""
        } else {
            output += "\r\n"
        }
        
        for pair in childrenDictionary {
            if pair.value.count > 1 {
                output += String(repeating: " ", count: level + 1) + "\(pair.key):\r\n"
                for indexer in pair.value {
                    output += String(repeating: " ", count: level + 2) + "-\r\n"
                    output += try process(indexer: indexer, level: level + 2, shouldPrintName: false)
                }
            } else {
                output += try process(indexer: pair.value.first!, level: level + 1)
            }
        }
        
        return output
    }
    
}
