within CEA_Energy_Process_library.GeneralCircuitry.Pipe.BaseClasses;
partial model PartialPipe

//François NEPVEU - CEA
//________________________________________________________________________________//

// ________________________________________________________________________________________________
//          Imports and Class Hierarchy
import Modelica.Units.SI;
import Modelica.Fluid.Utilities.regStep;
import Modelica.Media.Interfaces.Choices.IndependentVariables;

// _________________________________________________________________________________________________

// _________________________________________________________________________________________________
//         Interfaces
extends CEA_Energy_Process_library.GeneralCircuitry.Interfaces.PartialTwoPort;
// _________________________________________________________________________________________________

// _________________________________________________________________________________________________
//              Visible Parameters & Variables

public
   SI.Density Rho(start=
                   if Medium.ThermoStates == IndependentVariables.ph or   Medium.ThermoStates == IndependentVariables.phX then
                    Medium.density(Medium.setState_phX(p_start,h_start,X_start))
                   else
                    Medium.density(Medium.setState_pTX(p_start,T_start,X_start))) "Fluid Specific Heat Capacity";

   SI.VolumeFlowRate V_flow(start=
                   if Medium.ThermoStates == IndependentVariables.ph or   Medium.ThermoStates == IndependentVariables.phX then
                      m_flow_start/Medium.density(Medium.setState_phX(p_start,h_start,X_start))
                    else
                      m_flow_start/Medium.density(Medium.setState_pTX(p_start,T_start,X_start))) "Volume Flow Rate";

SI.MassFlowRate m_flow "Mass flow rate in design flow direction";

equation

// Mass balance (no storage)
In.m_flow=m_flow;
In.m_flow + Out.m_flow = 0;
Rho=Medium.density(state);
m_flow=Rho*V_flow;

//Energy balance
In.h_outflow=inStream(Out.h_outflow);
Out.h_outflow=inStream(In.h_outflow);

// Transport of substances
In.Xi_outflow = inStream(Out.Xi_outflow);
Out.Xi_outflow = inStream(In.Xi_outflow);

In.C_outflow = inStream(Out.C_outflow);
Out.C_outflow = inStream(In.C_outflow);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p></span><b><span style=\"font-size: 10.8pt;\">Object Role</b></p>
<p>This partial model is dedicated to the simulation of piping. It can be used to develop various piping models.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Interfaces and Components</b></p>
<p>The model includes:</p>
<ul>
<li>Two fluid interfaces, In and Out</li>
<li>One RealInput interface to define the valve opening (y)</li>
</ul>
<p></span><b><span style=\"font-size: 10.8pt;\">Performance Enhancement Functions</b></p>
<p>The <span style=\"font-family: Courier New;\">regStep</span> function evaluates the fluid state based on the flow direction. The parameter <span style=\"font-family: Courier New;\">dp_small</span> is crucial, and its proper configuration is important.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Modeling</b></p>
<p>The model incorporates a quasi-static mass balance: 0=m˙in+m˙out0 = \\dot{m}_{in} + \\dot{m}_{out}0=m˙in​+m˙out​ With equal inflows and outflows, the port variables Xi_outflowX_{i\\_outflow}Xi_outflow​ and CoutflowC_{outflow}Coutflow​ are directly derived. Assuming an adiabatic valve, the variables houtflowh_{outflow}houtflow​ are also determined. The fluid state is evaluated at the In or Out port depending on the flow direction.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Limitations</b></p>
<p></span><b><span style=\"font-size: 10.8pt;\">Tips</b></p>
<p>Pay attention to the correct configuration of <span style=\"font-family: Courier New;\">dp_small</span>.</p>
</html>"));
end PartialPipe;
