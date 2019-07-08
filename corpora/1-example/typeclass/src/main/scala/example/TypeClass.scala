package example

object TypeClass extends App {

    trait Jsonable[T] {
      def toJson(x: T): String
    }

    implicit val intJsonable = new Jsonable[Int] {
      def toJson(x: Int): String = x.toString
    }

    implicit def seqJsonable[T: Jsonable]: Jsonable[Seq[T]] = new Jsonable[Seq[T]] {
      def toJson(xs: Seq[T]): String = {
        xs.map(_.toJson).mkString(",")
      }
    }

    implicit class XtensionJson[T: Jsonable](x: T) {
      def toJson: String = implicitly[Jsonable[T]].toJson(x)
    }

    def asJson[T: Jsonable](x: T) {
      implicitly[Jsonable[T]].toJson(x)
    }

    Seq(1,2,3).toJson
    asJson(Seq(1,2,3))
}
