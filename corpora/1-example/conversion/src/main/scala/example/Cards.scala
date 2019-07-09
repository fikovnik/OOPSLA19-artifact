package example

// Example from the Figure 1 in the paper
// When run, it should throw java.lang.IndexOutOfBoundsException: 1
object Cards extends App {
  case class Card(n: Int, suit: String = "club") {
    def isInDeck(implicit deck: List[Card]) = deck contains this
  }

  implicit val dk = List(Card(1))
  implicit def iToC(n: Int) = Card(n)

  1.isInDeck
}
