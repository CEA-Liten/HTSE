within HTSE.GeneralCircuitry.Source;
model Source_m_flow_T "Similar to MSL Source"
//François NEPVEU - CEA
 import      Modelica.Units.SI;
import Modelica.Constants;

  replaceable package Medium =Modelica.Media.Interfaces.PartialMedium constrainedby Modelica.Media.Interfaces.PartialMedium
        annotation (       Dialog(group="Fluid"));

parameter Integer N_port=1 "Port inlet";
parameter SI.MassFlowRate m_flow=0 "Initial Mass Flow"  annotation (Dialog(group="Initial values"));
parameter SI.Pressure p_start=1e5 "Pressure"   annotation (Dialog(group="Initial values"));
parameter SI.Temperature T=293.15 "Temperature"    annotation (Dialog(group="Initial values"));
parameter SI.MassFraction[Medium.nX] X=Medium.X_default "Mass Fraction"    annotation (Dialog(group="Initial values"));
parameter SI.MassFraction[Medium.nC] C=Medium.C_default "Extra Properties"    annotation (Dialog(group="Initial values"));
parameter Boolean use_m_flow_in=true;
parameter Boolean use_T_in=true;
parameter Boolean use_C_in=true;
parameter Boolean use_X_in=true;

 Modelica.Fluid.Interfaces.FluidPort_a port[N_port](
   redeclare each package Medium = Medium,
   each p(start=p_start),
   each m_flow(start=m_flow)) annotation (Placement(transformation(extent={{84,-18},{120,18}},rotation=0), iconTransformation(extent={{84,-18},{120,18}})));
 Modelica.Blocks.Interfaces.RealInput m_flow_in(start=m_flow,final quantity="MassFlowRate", final unit="kg/s") if use_m_flow_in annotation (Placement(transformation(extent={{-114,46},{-86,74}})));
 Modelica.Blocks.Interfaces.RealInput T_in(start=T,final quantity="ThermodynamicTemperature",final unit="K") if use_T_in annotation (Placement(transformation(extent={{-114,6},{-86,34}})));
 Modelica.Blocks.Interfaces.RealInput[Medium.nX] X_in(start=X,final quantity="MassFraction",final unit="1") if use_X_in annotation (Placement(transformation(extent={{-114,-34},{-86,-6}})));
 Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_in(start=C,final quantity="MassFraction",final unit="1") if use_C_in annotation (Placement(transformation(extent={{-114,-74},{-86,-46}})));

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_int(
    final start=m_flow,
    final quantity="MassFlowRate",
    final unit="kg/s");
  Modelica.Blocks.Interfaces.RealInput T_int(
    final start=T,
    final quantity="ThermodynamicTemperature",
    final unit="K");
  Modelica.Blocks.Interfaces.RealInput[Medium.nX] X_int(
    final start=X,
    final quantity="MassFraction",
    final unit="1");
  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_int(
    final start=C,
    final quantity="MassFraction",
    final unit="1");

equation
 connect(m_flow_in, m_flow_int);
 connect(T_in, T_int);
 connect(X_in, X_int);
 connect(C_in, C_int);

  if not use_m_flow_in then
   m_flow_int = m_flow;
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
    port[i].m_flow=-m_flow_int;
   port[i].h_outflow=Medium.specificEnthalpy(Medium.setState_pTX(port[i].p, T_int, X_int));
   port[i].Xi_outflow=X_int[1:Medium.nXi];
   port[i].C_outflow=C_int;

end for;

 annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
       Rectangle(
         extent={{35,45},{100,-45}},
         fillPattern=FillPattern.HorizontalCylinder,
         fillColor={0,127,255}),
       Ellipse(
         extent={{-100,80},{60,-80}},
         lineColor={0,0,255},
         fillColor={255,255,255},
         fillPattern=FillPattern.Solid),
       Polygon(
         points={{-60,70},{60,0},{-60,-68},{-60,70}},
         lineColor={0,0,255},
         fillColor={0,0,255},
         fillPattern=FillPattern.Solid),
       Text(
         extent={{-54,32},{16,-30}},
         textColor={255,0,0},
         textString="m"),
       Ellipse(
         extent={{-26,30},{-18,22}},
         lineColor={255,0,0},
         fillColor={255,0,0},
         fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p></span><b><span style=\"font-size: 10.8pt;\">Object Role</b></p>
<p>This object serves as a mass flow rate boundary condition with imposed temperature for an outgoing flow from the source.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Interfaces and Components</b></p>
<p>The model includes:</p>
<ul>
<li>One multiple fluid port interface <span style=\"font-family: Courier New;\">port[]</span></li>
<li>Four RealInput interfaces to define mass flow rate, temperature, mass fraction XXX, and traces when the <span style=\"font-family: Courier New;\">use_..._in</span> booleans are used</li>
<li>A media type must also be selected</li>
</ul>
<p></span><b><span style=\"font-size: 10.8pt;\">Performance Enhancement Functions</b></p>
<p></span><b><span style=\"font-size: 10.8pt;\">Modeling</b></p>
<p>The model is very similar to the one in the Modelica Standard Library (MSL). Since the boundary condition is based on mass flow rate, the connection of other components to the port is important. The flow rate specified by the user is imposed on each port of the source. If the <span style=\"font-family: Courier New;\">use_..._in</span> option is used for a given variable (mass flow rate, temperature, mass fraction, trace), the user must impose the variable via the RealInput port. Otherwise, the variable is considered constant at its parameterized value. Note that temperature, mass fraction, and traces only impact the case of an outgoing flow from the source.</p>
</html>"));
end Source_m_flow_T;
