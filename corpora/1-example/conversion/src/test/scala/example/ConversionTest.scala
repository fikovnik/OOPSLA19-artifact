package example

import org.scalatest.{FunSuite, Matchers}
import example.Conversion._
import example.TypeClass._

class ConversionTest extends FunSuite with Matchers {

  test("JSON conversion should convert a sequence of integers") {
      Seq(1,2,3).toJson shouldBe "[1,2,3]"
  }

}
