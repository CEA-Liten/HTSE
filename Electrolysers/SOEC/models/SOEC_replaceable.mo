within CEA_Energy_Process_library.Electrolysers.SOEC.models;
model SOEC_replaceable "SOEC stack model with replaceable submodels"

    import Modelica.Units.SI;
import SubPos=CEA_Energy_Process_library.Utilities.UtilitiesFunction.SubstancePosition;
import Cst = Modelica.Constants;
import math = Modelica.Math;

//fluid and electric ports

   Modelica.Fluid.Interfaces.FluidPort_a an_in_port(redeclare package Medium = Medium_Air)
  annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
   Modelica.Fluid.Interfaces.FluidPort_b an_out_port(redeclare package Medium = Medium_Air)
  annotation (Placement(transformation(extent={{90,50},{110,70}})));
     Modelica.Fluid.Interfaces.FluidPort_a cat_in_port(
        h_outflow(start = 3e6),
   Xi_outflow( start = {0.98,0.02,0}),
     redeclare package Medium =
        Medium_Fuel)
  annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
   Modelica.Fluid.Interfaces.FluidPort_b cat_out_port(redeclare package Medium =
        Medium_Fuel)
  annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
   Modelica.Electrical.Analog.Interfaces.PositivePin p
  annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
   Modelica.Electrical.Analog.Interfaces.NegativePin n
  annotation (Placement(transformation(extent={{30,-110},{50,-90}})));

  // PARAMETERS
// global parameters
inner parameter Integer N = 20 "number of discretized elements" annotation (Dialog(group="simulation parameters"));
 inner parameter Integer n_cells = data.n_cells "number of cells in the stack" annotation (Dialog(group="simulation parameters"));
 inner parameter Integer n_stacks = 1 annotation (Dialog(group="simulation parameters"));

//parameter
constant SI.Temperature T_ref=273.15;
constant SI.Pressure p_ref=101325;
constant SI.MolarVolume Vm_ref=Modelica.Constants.R*T_ref/p_ref;//m3/mol

parameter Real SteamConversion = 0.7 annotation (Dialog(group="simulation parameters"));

//initialisation of state variables

  //position of element inside the media
  inner constant Integer Pos_O2=SubPos(
        Name="O2",
        nS=Medium_Air.nX,
        NameMatrix=Medium_Air.substanceNames)
  "position of oxygen in the air media components";

  inner constant Integer Pos_N2=SubPos(
        Name="N2",
        nS=Medium_Air.nX,
        NameMatrix=Medium_Air.substanceNames)
  "position of nitrogen in the air media components";

  inner constant Integer Pos_H2=SubPos(
        Name="H2",
        nS=Medium_Fuel.nX,
        NameMatrix=Medium_Fuel.substanceNames)
  "position of hydrogen in the fuel media components";

  inner constant Integer Pos_H2O=SubPos(
        Name="H2O",
        nS=Medium_Fuel.nX,
        NameMatrix=Medium_Fuel.substanceNames)
  "position of water in the fuel media components";

//media
   replaceable package Medium_Air =
    CEA_Energy_Process_library.Media.Predefined.PureSubstance.Gas.Air.IdealGasAir
    constrainedby Modelica.Media.Interfaces.PartialMedium "Air model"  annotation (Dialog(group="Fluids"));

 replaceable package Medium_Fuel =
    CEA_Energy_Process_library.Media.Predefined.Mixture.Gas.IdealGasMixture_H2O_H2_N2
  constrainedby Modelica.Media.Interfaces.PartialMedium
  annotation (choicesAllMatching = true,Dialog(group="Fluids"));

inner SI.Current I_global "current provided to the whole stack";
inner SI.CurrentDensity I_avg "average current density over the cell";
inner SI.Voltage V_global "potential of the whole stack";
inner SI.Voltage V_cell "potential of 1 cell";
inner SI.CurrentDensity I_dens[N](each start = 0);

//thermodynamic
  inner SI.Pressure p_an[N];
  inner SI.Pressure p_cat[N];
inner Real T_nodes[N];

  //chemical components
inner SI.MoleFraction[N,Medium_Air.nX] n_fractions_an "molar fractions of components in the anode gas channel";
inner SI.MoleFraction[N,Medium_Fuel.nX] n_fractions_cat "molar fractions of the components in the cathode gas channel";

inner SI.MolarFlowRate[N,Medium_Air.nX] n_flow_an_channel "molar flow rate of the components in the anode gas channel";
inner SI.MolarFlowRate[N,Medium_Fuel.nX] n_flow_cat_channel "molar flow rate of the components in the cathode gas channel";

inner SI.MoleFraction x_H2_TPBc[N] "molar fraction of hydrogen at the cathode triple phase boundary (TPBc)";
inner SI.MoleFraction x_O2_TPBa[N] "molar fraction of oxygen at the anode triple phase boundary (TPBa)";
inner SI.MoleFraction x_H2O_TPBc[N](each start = 0.9) "molar fraction of water at the cathode triple phase boundary (TPBc)";

inner SI.MassFlowRate m_flow_cat_total[N];

Real SC;
SI.Power P_el;
SI.MassFlowRate m_flow_H2_producted;
Real PCI;

  replaceable CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Voltage.voltage Voltage constrainedby CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Voltage.partialVoltage annotation (
    Dialog(group="Sub Models"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-10,-90},{10,-70}})));

  replaceable CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Temperature.thermoneutralTemperature Temperature constrainedby CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Temperature.partialTemperature annotation (
    Dialog(group="Sub Models"),
    choicesAllMatching=true,
    Placement(transformation(extent={{40,20},{60,40}})));

  replaceable CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Mass_Flow.coFlow coFlow(redeclare package Medium_Air = Medium_Air, redeclare package Medium_Fuel = Medium_Fuel) constrainedby CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Mass_Flow.partialFlow annotation (
    Dialog(group="Sub Models"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-10,-10},{10,10}})));

  inner replaceable CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Data.cell_parameter data constrainedby CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Data.partialParameter annotation (
    Dialog(group="SOEC data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-60,20},{-40,40}})));

  GeneralCircuitry.Pipe.Pipe_L1 pipe_L1_1(
    redeclare package Medium = Medium_Fuel,
    dp_Nom=0.5*data.dp_nom_SOEC,
    m_flow_Nom=n_cells*n_stacks*data.m_flow_nom,
    n=1,
    Choice_mV_flow=false) annotation (Placement(transformation(extent={{40,-16},{60,4}})));
  GeneralCircuitry.Pipe.Pipe_L1 pipe_L1_2(
    redeclare package Medium = Medium_Fuel,
    dp_Nom=0.5*data.dp_nom_SOEC,
    m_flow_Nom=n_cells*n_stacks*data.m_flow_nom,
    n=1,
    Choice_mV_flow=false) annotation (Placement(transformation(extent={{-60,-16},{-40,4}})));
  GeneralCircuitry.Pipe.Pipe_L1 pipe_L1_3(
    redeclare package Medium = Medium_Air,
    dp_Nom=0.5*data.dp_nom_SOEC,
    m_flow_Nom=2*n_cells*n_stacks*data.m_flow_nom,
    n=1,
    Choice_mV_flow=false) annotation (Placement(transformation(extent={{-60,-4},{-40,16}})));
  GeneralCircuitry.Pipe.Pipe_L1 pipe_L1_4(
    redeclare package Medium = Medium_Air,
    dp_Nom=0.5*data.dp_nom_SOEC,
    m_flow_Nom=2*n_cells*n_stacks*data.m_flow_nom,
    n=1,
    Choice_mV_flow=false) annotation (Placement(transformation(extent={{40,-4},{60,16}})));
protected
   parameter Real x_H2O_in = 0.9;
 parameter Real x_H2_in = 1 - x_H2O_in;
equation

P_el = p.i*(p.v-n.v);
  SC = 1 - n_flow_cat_channel[N,Pos_H2O]/max({1e-9,n_flow_cat_channel[1,Pos_H2O]});

  m_flow_H2_producted = max({1e-8,n_stacks*m_flow_cat_total[N]*cat_out_port.Xi_outflow[Pos_H2] - cat_in_port.Xi_outflow[Pos_H2]*cat_in_port.m_flow});
  PCI = P_el/m_flow_H2_producted;

  connect(p, Voltage.p_submodel) annotation (Line(points={{-40,-100},{-40,-80},{-10,-80}}, color={0,0,255}));
  connect(Voltage.n_submodel, n) annotation (Line(points={{10,-80},{40,-80},{40,-100}}, color={0,0,255}));
  connect(pipe_L1_1.In, coFlow.cat_out_port_submodel) annotation (Line(points={{40,-6},{10,-6}}, color={0,127,255}));
  connect(pipe_L1_1.Out, cat_out_port) annotation (Line(points={{60,-6},{100,-6},{100,-60}}, color={0,127,255}));
  connect(cat_in_port, pipe_L1_2.In) annotation (Line(points={{-100,-60},{-100,-6},{-60,-6}}, color={0,127,255}));
  connect(pipe_L1_2.Out, coFlow.cat_in_port_submodel) annotation (Line(points={{-40,-6},{-10,-6}}, color={0,127,255}));
  connect(coFlow.an_out_port_submodel, pipe_L1_4.In) annotation (Line(points={{10,6},{40,6}}, color={0,127,255}));
  connect(pipe_L1_3.Out, coFlow.an_in_port_submodel) annotation (Line(points={{-40,6},{-10,6}}, color={0,127,255}));
  connect(pipe_L1_3.In, an_in_port) annotation (Line(points={{-60,6},{-100,6},{-100,60}}, color={0,127,255}));
  connect(pipe_L1_4.Out, an_out_port) annotation (Line(points={{60,6},{100,6},{100,60}}, color={0,127,255}));
  annotation (
    Icon(graphics={
      Rectangle(
        extent={{-100,4},{100,-12}},
        lineColor={28,108,200},
        fillColor={127,127,0},
        fillPattern=FillPattern.Solid), Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
        Ellipse(
          extent={{-42,74},{-16,48}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{16,74},{42,48}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-16,60},{16,60}}, color={28,108,200}),
        Ellipse(
          extent={{16,-52},{32,-68}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-16,-60},{16,-60}}, color={28,108,200}),
        Ellipse(
          extent={{-32,-52},{-16,-68}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                                                                  Documentation(info="<html>
<p>HTSE stack model</p>
<p>in/out : </p>
<p>cat_in_port, cat_out_port, an_in_port, an_out_port, p, n</p>
<p><br>parameters :</p>
<p>n_cells : number of cells per stack</p>
<p>n_stack : total number of stacks</p>
<p><br><br><br>description :</p><p><br><br><br>This model allows for simulating the electrochemical, thermal, and fluidic behavior of a Solid Oxide Electrolysis Cell (SOEC), composed of a stack of elementary cells connected in series, subjected to a current source and supplied by two circuits: the air side at the anode, and a mixture of H2O/H2 called the fuel side at the cathode.</p>
<p>The model is interfaced with 4 fluid ports (in anode, out anode, in cathode, out cathode) and 2 electrical pins (p and n) to provide electrical power to the electrolyzer. Both current or voltage source can be used but a current source has to be prefered.</p>
<p>The model is discretized along the gas channel to better represent the current density repartition inside the cell. The model aggregates various sub-models and components that communicate with each other through outer variables :</p>
<p><br>- The fluidic model : transport equations and link to the fluid ports. the sub model is mostly composed of equations that describes either a co-flow/counter-flow/cross-flow type of fluid movement and the interactions between molar fractions of gas components and current density. The electrolyte crossing of gas components is handled here.</p>
<p>- The electro chemical model : equation between current density, molar fractions and voltages. The main outputs are the cell voltage and the current density reparition along the 1D/2D cell.</p>
<p>- The thermic model : computes the temperature along the electrolyzer cell. </p>
<p>- The pressure model : computes the pressure drop along the cell for various fluid movements. </p>
<p>- A data record that provides material information and other data. Separate the cell type from the rest of the Model.</p>
<p><br>The sub model are described in their own description sections. The choices made for the TANDEM library are : </p>
<p>- to keep the electro chemical model physical with real equations from the litterature. </p>
<p>- to have a co-flow fluid movement. it means that gas in the anode and cathode channel are parallel and flows in the same direction. It is the most simple way to transport gas in the cell. Also ignore second order complications.</p>
<p>- the temperature is computed to maintain the cell voltage to follow thermoneutral voltage using a basic PID. </p>
<p>- Pressure losses are linear and averaged in the cell.</p>
</html>"));
end SOEC_replaceable;
