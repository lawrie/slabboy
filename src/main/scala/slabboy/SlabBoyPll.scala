package slabboy

import spinal.core._

case class SlabBoyPll() extends BlackBox{
  setDefinitionName("slabboy_pll")
  val clock_in = in Bool()
  val clock_out = out Bool()
  val locked = out Bool()
}
