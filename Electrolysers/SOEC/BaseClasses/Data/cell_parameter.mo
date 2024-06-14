within CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Data;
record cell_parameter "Record used for Basic specification of an empirical model of Electrolyzer SOEC stack"

  extends BaseClasses.Data.baseParameter;
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Modelica.Icons.Record;

  import      Modelica.Units.SI;
  import Cst =  Modelica.Constants;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

 parameter Integer n_cells = 25 "number of cells for each stacks";
 parameter SI.Area SOEC_area = 70.44e-4 "cells active area";
 parameter SI.MassFlowRate m_flow_nom = 1.03e-5 "nominal mass flow rate of 1 cell for SC = 0.7 et x_H2O = 0.9";
 parameter SI.Density d_nom = 1.92e-7 "nominal density";
 parameter SI.CurrentDensity i_nom= 1.1 "A/cm²";
 parameter SI.Pressure dp_nom_SOEC = 0.1e5 "pressure loss under nominal conditions";

 //material characteristics
 parameter Real epsc=0.4 "cathode porosity";
 parameter Real tauc=4 "cathode tortuosity";
 parameter SI.Radius  rbc=1e-6 "average radius of the cathode pores";

 parameter Real epsa=0.4   "anode porosity";
 parameter Real taua=4 "anode tortuosity";
 parameter SI.Radius  rba=1e-6 "average radius of the anode pores";

  //electric conductivity

 parameter SI.Conductivity rhoLSM=72e2 "conductivity of the anode";
 parameter SI.Conductivity rhoNI8YSZ=800e2 "conductivity of the cathode and electrolyte";

 /*____________________________________________________________________________________
 computed parameter
 _____________________________________________________________________________________*/

 parameter Real deffO2N2 = epsa/taua*0.00143/((MO2N2)^0.5*(VdiffO2^(1/3) +
      VdiffN2^(1/3))^2)*1e-4 "effective diffusivity between O2 and N2";
 parameter Real deffH2H2O = epsc/tauc*0.00143/((MH2H2O)^0.5*(VdiffH2^(1/3) +
      VdiffH2O^(1/3))^2)*1e-4 "effective diffusivity between H2 and H2O";
 parameter Real deffH2N2 = epsc/tauc*0.00143/((MH2N2)^0.5*(VdiffH2^(1/3) +
      VdiffN2^(1/3))^2)*1e-4 "effective diffusivity between H2 and N2";
 parameter Real deffH2ON2 = epsc/tauc*0.00143/((MH2ON2)^0.5*(VdiffH2O^(1/3) +
      VdiffN2^(1/3))^2)*1e-4 "effective diffusivity between H2O and N2";

 //Knudsen diffusion coefficients

 parameter Real deffO2k= epsa/taua*rba*2/3*(8*Cst.R/(Cst.pi*MO2*1e-3))^0.5 "Knudsen diffusivity of O2";
 parameter Real deffN2ak=epsa/taua*rba*2/3*(8*Cst.R/(Cst.pi*MN2*1e-3))^0.5 "Knudsen diffusivity of N2 in the anode";
 parameter Real deffH2k= epsc/tauc*rbc*2/3*(8*Cst.R/(Cst.pi*MH2*1e-3))^0.5 "Knudsen diffusivity of H2";
 parameter Real deffH2Ok=epsc/tauc*rbc*2/3*(8*Cst.R/(Cst.pi*MH2O*1e-3))^0.5 "Knudsen diffusivity of H2O";
 parameter Real deffN2ck=epsc/tauc*rbc*2/3*(8*Cst.R/(Cst.pi*MN2*1e-3))^0.5 "Knudsen diffusivity of N2 in the cathode";

 //width of components
 parameter Real epa=50e-6 "width of anode";
 parameter Real epe=90e-6 "width of electrolyte";
 parameter Real epc=50e-6 "width of cathode";

 //electric resistance

 parameter SI.Resistance Ra = epa/rhoLSM "anode resistance";
 parameter SI.Resistance Rc = epc/rhoNI8YSZ "cathode resistance";

 // activation overpotential
 parameter SI.Energy Eact_an = 120000 "activation energy of the anode reaction";
 parameter SI.Current I00_an=2.05e9 "activation current in the anode";
 parameter Real alpha_O2=1/4 " importance of O2 in the activation overpotential";
 parameter SI.Energy Eact_cath=120000  "activation energy of the cathode reaction";
 parameter SI.Current I00_cath=1.26e11 "activation current in the cathode";
 parameter Real alpha_H2=1 "importance of H2 in the activation overpotential";
 parameter Real beta_H2O=1 "importance of H2O in the activation overpotential";

  annotation (Documentation(info="<html>
<p>Data record </p>
<p>In/out : </p>
<p>none</p>
<p><br>parameters : </p>
<p><span style=\"font-family: Courier New;\">MolarGasVolume&nbsp;: <span style=\"color: #006400;\">volume&nbsp;of&nbsp;a&nbsp;mole&nbsp;of&nbsp;gas&nbsp;at&nbsp;standard&nbsp;conditions</span></p>
<p><span style=\"font-family: Courier New;\">n_cells : number of cell in one stack</span></p>
<p><span style=\"font-family: Courier New;\">SOEC_area&nbsp;: area of the cell</span></p>
<p><span style=\"font-family: Courier New;\">m_flow_nom&nbsp;: <span style=\"color: #006400;\">nominal&nbsp;mass&nbsp;flow&nbsp;rate&nbsp;of&nbsp;1&nbsp;cell&nbsp;for&nbsp;SteamConversion&nbsp;=&nbsp;0.7&nbsp;et&nbsp;x_H2O&nbsp;=&nbsp;0.9</span></p>
<p><span style=\"font-family: Courier New;\">d_nom&nbsp;: <span style=\"color: #006400;\">nominal&nbsp;density of gas</span></p>
<p><span style=\"font-family: Courier New;\">i_nom : nominal current density corresponding to the nominal mass flow rate</span></p>
<p><span style=\"font-family: Courier New;\">dp_nom_SOEC&nbsp;: nominal pressure loss at the end of the stack</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;<span style=\"color: #006400;\">//diffusions&nbsp;volumes</span></p>
<p><span style=\"font-family: Courier New;\">VdiffO2 diffusion model parameter</span></p>
<p><span style=\"font-family: Courier New;\">VdiffN2&nbsp;: diffusion model parameter</span></p>
<p><span style=\"font-family: Courier New;\">VdiffH2&nbsp;: diffusion model parameter</span></p>
<p><span style=\"font-family: Courier New;\">VdiffH2O&nbsp;: diffusion model parameter</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;<span style=\"color: #006400;\">//material&nbsp;characteristics</span></p>
<p><span style=\"font-family: Courier New;\">epsc : <span style=\"color: #006400;\">cathode&nbsp;porosity</span></p>
<p><span style=\"font-family: Courier New;\">tauc : <span style=\"color: #006400;\">cathode&nbsp;tortuosity</span></p>
<p><span style=\"font-family: Courier New;\">rbc : <span style=\"color: #006400;\">average&nbsp;radius&nbsp;of&nbsp;the&nbsp;cathode&nbsp;pores</span></p>
<p><br><span style=\"font-family: Courier New;\">epsa : <span style=\"color: #006400;\">anode&nbsp;porosity</span></p>
<p><span style=\"font-family: Courier New;\">taua : <span style=\"color: #006400;\">anode&nbsp;tortuosity</span></p>
<p><span style=\"font-family: Courier New;\">rba : <span style=\"color: #006400;\">average&nbsp;radius&nbsp;of&nbsp;the&nbsp;anode&nbsp;pores</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;<span style=\"color: #006400;\">//molar&nbsp;mass</span></p>
<p><span style=\"font-family: Courier New;\">MO2&nbsp;: molar mass if dioxygen (g/mol)</span></p>
<p><span style=\"font-family: Courier New;\">MN2&nbsp;: molar mass if dinitrogen (g/mol)</span></p>
<p><span style=\"font-family: Courier New;\">MH2&nbsp;: molar mass if dihydrogen (g/mol)</span></p>
<p><span style=\"font-family: Courier New;\">MH2O&nbsp;: molar mass if water (g/mol)</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #006400;\">//electric&nbsp;conductivity</span></p>
<p><br><span style=\"font-family: Courier New;\">rhoLSM : electric conductivity of the anode </span></p>
<p><span style=\"font-family: Courier New;\">rhoNI8YSZ : electric conductivity of the cathode and electrolyte</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;<span style=\"color: #006400;\">/*____________________________________________________________________________________</span></p>
<p><span style=\"font-family: Courier New; color: #006400;\">&nbsp;computed&nbsp;parameter</span></p>
<p><span style=\"font-family: Courier New; color: #006400;\">&nbsp;_____________________________________________________________________________________*/</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #006400;\">//intermediate molar masses</span></p>
<p><span style=\"font-family: Courier New;\">MO2N2&nbsp;=&nbsp;2/(1/MO2&nbsp;+&nbsp;1/MN2)</span></p>
<p><span style=\"font-family: Courier New;\">MH2H2O&nbsp;=&nbsp;2/(1/MH2&nbsp;+&nbsp;1/MH2O)</span></p>
<p><span style=\"font-family: Courier New;\">MH2N2&nbsp;=&nbsp;2/(1/MH2&nbsp;+&nbsp;1/MN2)</span></p>
<p><span style=\"font-family: Courier New;\">MH2ON2&nbsp;=&nbsp;2/(1/MH2O&nbsp;+&nbsp;1/MN2)</span></p>
<p><br><span style=\"font-family: Courier New;\">// bi species diffusion</span></p>
<p><br><span style=\"font-family: Courier New;\">deffO2N2&nbsp;deffH2H2O&nbsp;deffH2N2&nbsp;deffH2ON2&nbsp;</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;<span style=\"color: #006400;\">//Knudsen&nbsp;diffusion&nbsp;coefficients</span></p>
<p><br><span style=\"font-family: Courier New;\">deffO2k deffN2ak deffH2k deffH2Ok deffN2ck</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;<span style=\"color: #006400;\">//width&nbsp;of&nbsp;components</span></p>
<p><span style=\"font-family: Courier New;\">epa : <span style=\"color: #006400;\">width&nbsp;of&nbsp;anode</span></p>
<p><span style=\"font-family: Courier New;\">epe : <span style=\"color: #006400;\">width&nbsp;of&nbsp;electrolyte</span></p>
<p><span style=\"font-family: Courier New;\">epc : <span style=\"color: #006400;\">width&nbsp;of&nbsp;cathode</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;<span style=\"color: #006400;\">//electric&nbsp;resistance</span></p>
<p><br><span style=\"font-family: Courier New;\">Ra&nbsp;: <span style=\"color: #006400;\">anode&nbsp;resistance</span></p>
<p><span style=\"font-family: Courier New;\">Rc&nbsp;: <span style=\"color: #006400;\">cathode&nbsp;resistance</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;<span style=\"color: #006400;\">//&nbsp;activation&nbsp;overpotential</span></p>
<p><span style=\"font-family: Courier New;\">Eact_an&nbsp;: anode activation energy</span></p>
<p><span style=\"font-family: Courier New;\">I00_an : anode activation current</span></p>
<p><span style=\"font-family: Courier New;\">alpha_O2 : importance of the O2 fraction at interface</span></p>
<p><span style=\"font-family: Courier New;\">Eact_cath : cathode activation energy</span></p>
<p><span style=\"font-family: Courier New;\">I00_cath : cathode activation current</span></p>
<p><span style=\"font-family: Courier New;\">alpha_H2 : importance of H2 at interface</span></p>
<p><span style=\"font-family: Courier New;\">beta_H2O : importance of water at interface</span></p>
<p><br><br>description :</p><p><br><br>data from the J&eacute;r&ocirc;me Laurencin publication Modelling of solid oxide steam electrolyser: Impact of the operating conditions on hydrogen production. regroup cells characteristics and nominal values.</p>
</html>"));
end cell_parameter;
