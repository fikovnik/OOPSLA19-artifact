package example

/**
  * An Example of a simple JSON serialization using type classes
  */
object TypeClass  {

    // type class
    trait Jsonable[T] {
      def toJson(x: T): String
    }

    // this is a function using the `Jsonable` type class
    def asJson[T](x: T)(implicit tc: Jsonable[T]): String = {
      tc.toJson(x)
    }

    // an instance of the type class for `Int`
    implicit val intJsonable = new Jsonable[Int] {
      def toJson(x: Int): String = x.toString
    }

    // an implicit type class derivation method which based on an instance of `Jsonable[T]`
    // derives a type class that works for `Jsonable[Seq[T]]`
    implicit def seqJsonable[T: Jsonable] = new Jsonable[Seq[T]] {
      def toJson(xs: Seq[T]): String = {
        xs.map(asJson(_)).mkString("[", ",", "]")
      }
    }
}

object Main extends App {
  import TypeClass._

  println(asJson(Seq(1,2,3)))
}