within HTSE.GeneralCircuitry.Source;
model Source_pT "Similar to MSL Source"
//François NEPVEU - CEA

import  Modelica.Units.SI;
 import Modelica.Constants;

replaceable package Medium =
     Modelica.Media.Interfaces.PartialMedium constrainedby Modelica.Media.Interfaces.PartialMedium
    annotation (       Dialog(group="Fluid"));

 parameter Integer N_port=1 "Port inlet";

 parameter SI.MassFlowRate m_flow_start=0 "Initial Mass Flow"
    annotation (Dialog(group="Initial values"));

  parameter SI.Pressure p=1*1e5 "Pressure"
    annotation (Dialog(group="Initial values"));

 parameter SI.Temperature T=293.15 "Temperature"    annotation (Dialog(group="Initial values"));

  parameter SI.MassFraction[Medium.nX] X=Medium.X_default "Mass Fraction"    annotation (Dialog(group="Initial values"));
  parameter SI.MassFraction[Medium.nC] C=Medium.C_default "Extra Properties"    annotation (Dialog(group="Initial values"));

     parameter Boolean use_p_in=true;
     parameter Boolean use_T_in=true;
     parameter Boolean use_C_in=true;
    parameter Boolean use_X_in=true;

  Modelica.Fluid.Interfaces.FluidPort_a port[N_port](
    redeclare each package Medium = Medium,
    each p(final start=p),
    each m_flow(final start=m_flow_start)) annotation (Placement(transformation(extent={{84,-18},{120,18}},rotation=0), iconTransformation(extent={{84,-18},{120,18}})));
  Modelica.Blocks.Interfaces.RealInput p_in(final start=p,final quantity="Pressure", final unit="Pa") if use_p_in annotation (Placement(transformation(extent={{-114,46},{-86,74}})));
  Modelica.Blocks.Interfaces.RealInput T_in(final start=T,final quantity="Temperature",final unit="K") if use_T_in annotation (Placement(transformation(extent={{-114,6},{-86,34}})));
  Modelica.Blocks.Interfaces.RealInput[Medium.nX] X_in(start=X,final quantity="MassFraction",final unit="1") if use_X_in annotation (Placement(transformation(extent={{-114,-34},{-86,-6}})));
  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_in(start=C,final quantity="MassFraction",final unit="1") if use_C_in annotation (Placement(transformation(extent={{-114,-74},{-86,-46}})));

protected
  Modelica.Blocks.Interfaces.RealInput p_int(final start=p,final quantity="Pressure", final unit="Pa");
  Modelica.Blocks.Interfaces.RealInput T_int(final start=T,final quantity="Temperature",final unit="K");
  Modelica.Blocks.Interfaces.RealInput[Medium.nX] X_int(final start=X,final quantity="MassFraction",final unit="1");
  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_int(final start=C,final quantity="MassFraction",final unit="1");

equation
  connect(p_in, p_int);
  connect(T_in, T_int);
  connect(X_in, X_int);
  connect(C_in, C_int);

if not use_p_in then
    p_int = p;
  end if;
  if not use_T_in then
    T_int = T;
  end if;
  if not use_X_in then
    X_int =X;
  end if;
  if not use_C_in then
    C_int =C;
  end if;
 for i in 1:N_port loop
    port[i].p=p_int;
    port[i].h_outflow=Medium.specificEnthalpy(Medium.setState_pTX(p_int,T_int,X_int));
    port[i].Xi_outflow=X_int[1:Medium.nXi];
     port[i].C_outflow=C_int[1:Medium.nC];

 end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                   Ellipse(
          extent={{-100,100},{100,-100}},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p></span><b><span style=\"font-size: 10.8pt;\">Object Role</b></p>
<p>This object serves as a pressure boundary condition with imposed temperature for an outgoing flow from the source.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Interfaces and Components</b></p>
<p>The model includes:</p>
<ul>
<li>One multiple fluid port interface <span style=\"font-family: Courier New;\">port[]</span></li>
<li>Four RealInput interfaces to define pressure, temperature, mass fraction XXX, and traces when the <span style=\"font-family: Courier New;\">use_..._in</span> booleans are used</li>
<li>A media type must also be selected</li>
</ul>
<p></span><b><span style=\"font-size: 10.8pt;\">Performance Enhancement Functions</b></p>
<p></span><b><span style=\"font-size: 10.8pt;\">Modeling</b></p>
<p>The model is very similar to the one in the MSL (Modelica Standard Library). Since the boundary condition is pressure-based, the number and connection of these ports do not impact the simulation. If the <span style=\"font-family: Courier New;\">use_..._in</span> option is used for a given variable (pressure, temperature, mass fraction, trace), the user must impose the variable via the RealInput port. Otherwise, the variable is considered constant at its parameterized value. Note that temperature, mass fraction, and traces only impact the case of an outgoing flow from the source.</p>
</html>"));
end Source_pT;
