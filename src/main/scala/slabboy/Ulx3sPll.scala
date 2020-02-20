package slabboy

import spinal.core._

case class Ulx3sPll() extends BlackBox{
  setDefinitionName("pll")
  val clkin = in Bool()
  val clkout0 = out Bool()
  val locked = out Bool()
}
