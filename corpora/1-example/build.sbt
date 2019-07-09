lazy val commonSettings = Seq(
  scalaVersion := "2.12.8",
  organization := "cz.cvut.fit.prl.scala.implicits.example",
  version := "1.0-SNAPSHOT"
)

lazy val root = (project in file("."))
  .aggregate(typeclass, conversion)
  .settings(commonSettings)

lazy val typeclass = (project in file("typeclass"))
  .settings(commonSettings)

lazy val conversion = (project in file("conversion"))
  .settings(commonSettings)
  .dependsOn(typeclass)
  .settings(
    libraryDependencies +=  "org.scalatest" %% "scalatest" % "3.2.0-SNAP10" % Test,
    libraryDependencies +=  "org.scalacheck" %% "scalacheck" % "1.13.5" % Test,
  )