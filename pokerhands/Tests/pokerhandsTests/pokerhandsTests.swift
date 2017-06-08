import XCTest
@testable import pokerhands

class pokerhandsTests: XCTestCase {
  let input = "Black: 2H 3D 5S 9C KD  White: 2C 3H 4S 8C AH"

  func testParsesPlayers() {
    let parser = Parser(input: input)
    let players = parser.parse()
    XCTAssertEqual(2, players.count)
    XCTAssertEqual(["Black", "White"], players.map { $0.name })
  }

  func testParsesPlayerHands() {
    let parser = Parser(input: input)
    let players = parser.parse()
    let cards = players[0].cards
    XCTAssertEqual(5, cards.count)
    let expectedCards = [
      Card.parse("2H"),
      Card.parse("3D"),
      Card.parse("5S"),
      Card.parse("9C"),
      Card.parse("KD"),
    ].flatMap { $0 }
    XCTAssertEqual(expectedCards, cards)
  }

  func testParsesCards() {
    let cardString = "5H"
    let card = Card.parse(cardString)
    XCTAssertEqual(5, card?.value)
    XCTAssertEqual(Suit.hearts, card?.suit)
  }

  func testDetectsHighCard() {
    let cards = [ "2H", "3D", "5S", "9C", "KD" ].flatMap(Card.parse)

    let hand = Poker(cards: cards).judge()
    XCTAssertNotNil(hand)

    if case let .highCard(cardValue)? = hand {
      XCTAssertEqual(13, cardValue)
    } else {
      XCTFail()
    }
  }

  func testDetectsPair() {
    let cards = [ "2H", "2D", "5S", "9C", "KD" ].flatMap(Card.parse)

    let hand = Poker(cards: cards).judge()
    XCTAssertNotNil(hand)

    if case let .pair(cardValue)? = hand {
      XCTAssertEqual(2, cardValue)
    } else {
      XCTFail()
    }
  }
}
