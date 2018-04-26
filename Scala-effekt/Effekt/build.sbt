name := "Effekt"

version := "0.1"

scalaVersion := "2.12.5"

resolvers += Resolver.sonatypeRepo("snapshots")

scalacOptions ++= Seq(
  "-deprecation",
  "-encoding", "UTF-8",
  "-feature",
  "-unchecked"
)

libraryDependencies ++= Seq("de.b-studios" %% "effekt" % "0.2-SNAPSHOT")
