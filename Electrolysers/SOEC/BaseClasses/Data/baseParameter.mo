within HTSE.Electrolysers.SOEC.BaseClasses.Data;
partial record baseParameter "basic values common il all characteristics records"
    extends Modelica.Icons.Record;

  import      Modelica.Units.SI;
  import Cst =  Modelica.Constants;

 parameter SI.Volume MolarGasVolume = Cst.R*273.15*1000/(1.013e5) "volume of a mole of gas at standard conditions";

   //diffusions volumes
 parameter SI.Volume VdiffO2 = 16.3 "diffusion volume of O2";
 parameter SI.Volume VdiffN2 = 18.5 "diffusion volume of N2";
 parameter SI.Volume VdiffH2 = 6.12 "diffusion volume of H2";
 parameter SI.Volume VdiffH2O = 13.1 "diffusion volument of H2O";

  //molar mass
 parameter SI.MolarMass MO2 = 31.99 "Molar mass of O2";
 parameter SI.MolarMass MN2 = 28.02 "Molar mass of N2";
 parameter SI.MolarMass MH2 = 2.02 "Molar mass of H2";
 parameter SI.MolarMass MH2O = 18.01 "Molar mass of H2O";

  //Definition of intermediate molar masses
 parameter Real MO2N2 = 2/(1/MO2 + 1/MN2) "computed intermediate molar mass";
 parameter Real MH2H2O = 2/(1/MH2 + 1/MH2O) "computed intermediate molar mass";
 parameter Real MH2N2 = 2/(1/MH2 + 1/MN2) "computed intermediate molar mass";
 parameter Real MH2ON2 = 2/(1/MH2O + 1/MN2) "computed intermediate molar mass";

end baseParameter;
