within HTSE.GeneralCircuitry.Interfaces;
partial model PartialTwoPort  "Partial element transporting fluid between two ports without storage of mass or energy"

//________________________________________________________________________________//

// ________________________________________________________________________________________________
//          Imports and Class Hierarchy
import Modelica.Units.SI;
import Modelica.Fluid.Utilities.regStep;
import Modelica.Media.Interfaces.Choices.IndependentVariables;

replaceable package Medium =Modelica.Media.Interfaces.PartialMedium
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
   Dialog(group="Fluid"));
// _________________________________________________________________________________________________

// _________________________________________________________________________________________________
//         Interfaces
  Modelica.Fluid.Interfaces.FluidPort_a In(p(final start=p_start),final m_flow(final start=m_flow_start),
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b Out(p(final start=p_start),m_flow(final start=m_flow_start),
    redeclare package Medium = Medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
// _________________________________________________________________________________________________

  // _________________________________________________________________________________________________
  //              Visible Parameters & Variables
public
  parameter SI.MassFlowRate m_flow_start=0 "Simulation start value mass flow at fluid interfaces" annotation (Dialog(group="Initial values"));

  parameter SI.Pressure p_start=1*1e5 "Simulation start value pressure " annotation (Dialog(group="Initial values"));

  parameter Boolean use_T_start= true  "= true, use T_start (one-phase fluid), otherwise h_start (two-phase fluid)"  annotation(Dialog(group="Initial values"), Evaluate=true);

  parameter SI.Temperature T_start=if Medium.ThermoStates == IndependentVariables.ph or   Medium.ThermoStates == IndependentVariables.phX then
               Medium.temperature_phX(p_start,h_start,X_start) else Medium.T_default  "Start value of temperature (one-phase fluid)"   annotation(Dialog(enable=use_T_start,group="Initial values"), Evaluate=true);

  parameter SI.SpecificEnthalpy h_start=if Medium.ThermoStates == IndependentVariables.ph or   Medium.ThermoStates == IndependentVariables.phX then
                Medium.h_default else Medium.specificEnthalpy_pTX(p_start, T_start, X_start)  "Start value of specific enthalpy (two-phase fluid)"  annotation(Dialog(enable=not                        (use_T_start),group="Initial values"),Evaluate=true);

  parameter SI.MassFraction[Medium.nX] X_start=Medium.X_default "initial temperature" annotation (Dialog(group="Initial values"));

  parameter Boolean from_dp=true "= true, use m_flow = f(dp) else dp = f(m_flow)"  annotation (Dialog(group="Simulations"));

  parameter SI.MassFlowRate m_flow_small=1e-5 "small flow regularization" annotation (Dialog(group="Simulations"));

  parameter SI.Pressure dp_small=1 "small flow regularization" annotation (Dialog(group="Simulations"));

   // Inflow thermodynamic states
  Medium.ThermodynamicState state "State depending of flow direction";
  Medium.ThermodynamicState state_in "State for medium inflowing through In";
  Medium.ThermodynamicState state_out "State for medium inflowing through Out";

  Units.SI.Ratio dir "Flow direction: 1 = a to b, 0 = b to a";
  Units.SI.Ratio w_dir[2] "Inflow ports weights";

  // Variables
  //  SI.MassFlowRate m_flow "Mass flow rate in design flow direction";
  SI.Pressure dp(final start=0) "Pressure drop between In and Out (= In.p - Out.p)";
  SI.SpecificEnthalpy h(start=h_start) "Inlet Fluid specific enthalpy depending of flow direction";
  SI.Pressure p(start=p_start) "Inlet pressure depending of flow direction";
  SI.MassFraction Xi[Medium.nXi](start=X_start[1:Medium.nXi]) "Mass fraction depending of flow direction";

equation

  dp=In.p - Out.p;

  //flow direction
  dir=if from_dp then regStep(In.p - Out.p, 1, 0, dp_small) else regStep(In.m_flow, 1, 0, m_flow_small);
  w_dir={dir,1 - dir};

  //State
  p=if from_dp then regStep(dp,In.p,Out.p,dp_small) else regStep(In.m_flow,In.p,Out.p,m_flow_small);
  h=if from_dp then regStep(dp,inStream(In.h_outflow),inStream(Out.h_outflow),dp_small) else regStep(In.m_flow,inStream(In.h_outflow),inStream(Out.h_outflow),m_flow_small);
  Xi=if from_dp then regStep(dp,inStream(In.Xi_outflow),inStream(Out.Xi_outflow),dp_small) else regStep(In.m_flow,inStream(In.Xi_outflow),inStream(Out.Xi_outflow),m_flow_small);

  // p=w_dir[1]*In.p+w_dir[2]*Out.p;
  // h=w_dir[1]*inStream(In.h_outflow)+w_dir[2]*inStream(Out.h_outflow);
  // for i in 1:Medium.nXi loop
  //   Xi[i]=w_dir[1]*inStream(In.Xi_outflow[i])+w_dir[2]*inStream(Out.Xi_outflow[i]);
  // end for;

  state=Medium.setState_phX(p,h,Xi);
  state_in=Medium.setState_phX(In.p,inStream(In.h_outflow),inStream(In.Xi_outflow));
  state_out=Medium.setState_phX(Out.p,inStream(Out.h_outflow),inStream(Out.Xi_outflow));

  annotation (Documentation(info="<html>
<p></span><b><span style=\"font-size: 10.8pt;\">Object Role</b></p>
<p>This partial model, featuring two input/output interfaces, is designed for the development of piping elements such as valves, sensors, and pipes.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Interfaces and Components</b></p>
<p>The model includes:</p>
<ul>
<li>Two fluid interfaces, In and Out</li>
<li>A media type must also be selected</li>
</ul>
<p></span><b><span style=\"font-size: 10.8pt;\">Performance Enhancement Functions</b></p>
<p>The <span style=\"font-family: Courier New;\">regStep</span> function from the Modelica Standard Library (MSL) is used to regularize flow rates when the CheckValve option, which blocks reverse flow from Out to In, is enabled.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Tips</b></p>
<p>There are several ways to calculate the inlet fluid state based on the flow direction: directly via <span style=\"font-family: Courier New;\">regStep</span> or through the calculation of an intermediate parameter <span style=\"font-family: Courier New;\">dir</span>.</p>
</html>"));
end PartialTwoPort;
