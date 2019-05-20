//
//  ReplacementTests.swift
//  RegExTests
//
//  Created by Eneko Alonso on 5/19/19.
//

import XCTest
import RegEx

class ReplacementTests: XCTestCase {

    let donQuixote = """
        En un lugar de la Mancha, de cuyo nombre no quiero acordarme, no ha
        mucho tiempo que vivía un hidalgo de los de lanza en astillero, adarga
        antigua, rocín flaco y galgo corredor. Una olla de algo más vaca que
        carnero, salpicón las más noches, duelos y quebrantos los sábados,
        lantejas los viernes, algún palomino de añadidura los domingos,
        consumían las tres cuartas partes de su hacienda. El resto della
        concluían sayo de velarte, calzas de velludo para las fiestas, con
        sus pantuflos de lo mesmo, y los días de entresemana se honraba con
        su vellorí de lo más fino. Tenía en su casa una ama que pasaba de
        los cuarenta, y una sobrina que no llegaba a los veinte, y un mozo
        de campo y plaza, que así ensillaba el rocín como tomaba la podadera.
        Frisaba la edad de nuestro hidalgo con los cincuenta años; era de
        complexión recia, seco de carnes, enjuto de rostro, gran madrugador y
        amigo de la caza. Quieren decir que tenía el sobrenombre de Quijada,
        o Quesada, que en esto hay alguna diferencia en los autores que deste
        caso escriben; aunque, por conjeturas verosímiles, se deja entender
        que se llamaba Quejana. Pero esto importa poco a nuestro cuento; basta
        que en la narración dél no se salga un punto de la verdad.
        """

    func testReplaceAll() throws {
        let regex = try RegEx(pattern: #"(\w+)a\b"#)
        let output = regex.stringByReplacingMatches(in: donQuixote, withTemplate: "$1o")
        XCTAssertTrue(output.hasPrefix("En un lugar de lo Mancho"))
    }

    func testDuplicateWordsEndingInAWithTemplate() throws {
        let regex = try RegEx(pattern: #"(\w+a)\b"#)
        let output = regex.stringByReplacingMatches(in: donQuixote, withTemplate: "$1$1")
        XCTAssertTrue(output.hasPrefix("En un lugar de lala ManchaMancha"))
    }

    func testDuplicateWordsEndingInAWithCustomLogic() throws {
        let regex = try RegEx(pattern: #"(\w+a)\b"#)
        let output = regex.stringByReplacingMatches(in: donQuixote) { match in
            let value = String(match.values[0] ?? "")
            return value + value
        }
        XCTAssertTrue(output.hasPrefix("En un lugar de lala ManchaMancha"))
    }

    func testReverseWordsEndingInA() throws {
        let regex = try RegEx(pattern: #"(\w+)a\b"#)
        let output = regex.stringByReplacingMatches(in: donQuixote) { match in
            let value = String(match.values[0] ?? "")
            return String(value.reversed())
        }
        XCTAssertTrue(output.hasPrefix("En un lugar de al ahcnaM"))
    }

    func testCapitalizeWordsEndingInA() throws {
        let regex = try RegEx(pattern: #"(\w+a)\b"#)
        let output = regex.stringByReplacingMatches(in: donQuixote) { match in
            let value = String(match.values[0] ?? "")
            return value.uppercased()
        }
        XCTAssertTrue(output.hasPrefix("En un lugar de LA MANCHA"))
    }

    func testInitializeWordsEndingInA() throws {
        let regex = try RegEx(pattern: #"(\w+a)\b"#)
        let output = regex.stringByReplacingMatches(in: donQuixote) { match in
            let value = String(match.values[0] ?? "")
            let initial = String(value[..<value.index(after: value.startIndex)])
            return initial.uppercased() + "."
        }
        XCTAssertTrue(output.hasPrefix("En un lugar de L. M."))
    }
}
