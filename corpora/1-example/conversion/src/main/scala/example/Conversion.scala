package example

import example.TypeClass._

/**
  * Example of the syntax method pattern - a combination of extension methods and type classes
  */
object Conversion {
  implicit class XtensionJson[T: Jsonable](x: T) {
    def toJson: String = implicitly[Jsonable[T]].toJson(x)
  }
}