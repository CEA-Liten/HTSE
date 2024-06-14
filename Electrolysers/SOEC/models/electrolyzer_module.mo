within CEA_Energy_Process_library.Electrolysers.SOEC.models;
model electrolyzer_module "semi autonomus module for the TANDEM project, HTSE part"

import Modelica.Units.SI;
import SubPos=CEA_Energy_Process_library.Utilities.UtilitiesFunction.SubstancePosition;

replaceable package Medium_MoistH2 =
      CEA_Energy_Process_library.Media.Predefined.Mixture.Gas.IdealGasMixture_H2O_H2_N2;

// replaceable package Medium_MoistH2 =
//      Media.Gas.Predefined.MoistGas.IdealGasMoistH2  constrainedby  Modelica.Media.Interfaces.PartialMedium   "Moist Hydrogen Model"   annotation (Dialog(group="Fluids"));

replaceable package Medium_Air =
      CEA_Energy_Process_library.Media.Predefined.PureSubstance.Gas.Air.IdealGasAir;

parameter SI.MassFlowRate m_flow_start=0 "Simulation start value mass flow at fluid interfaces" annotation (Dialog(group="Initial values"));
parameter SI.Pressure p_start_an=101325 "Cathode Simulation start value pressure " annotation (Dialog(group="Initial values"));
parameter SI.Pressure p_start_cat=101325 "Cathode Simulation start value pressure " annotation (Dialog(group="Initial values"));
parameter Real  EfficiencyFactor = 0.9;

parameter SI.Temperature T_start=750+273.15 "initla temperature" annotation (Dialog(group="Initial values"));

parameter SI.MassFlowRate m_flow_small=1e-8 "small flow regularization" annotation (Dialog(group="Simulations"));
parameter SI.Pressure dp_small=10 "small flow regularization" annotation (Dialog(group="Simulations"));

//parameter
constant SI.Temperature T_ref=273.15;
constant SI.Pressure p_ref=101325;
constant SI.MolarVolume Vm_ref=Modelica.Constants.R*T_ref/p_ref;//m3/mol

constant Integer Pos_H2=SubPos(Name="H2",nS=Medium_MoistH2.nX,NameMatrix=Medium_MoistH2.substanceNames);
constant Integer Pos_H2O=SubPos(Name="H2O",nS=Medium_MoistH2.nX,NameMatrix=Medium_MoistH2.substanceNames);

  models.Control control annotation (Placement(transformation(extent={{-50,-198},{50,-98}})));
  models.Physical physical annotation (Placement(transformation(extent={{-64,-64},{64,64}})));

  Modelica.Fluid.Interfaces.FluidPort_a Fuel_In(redeclare package Medium = Medium_MoistH2) annotation (Placement(transformation(extent={{-124,-24},{-76,24}}), iconTransformation(extent={{-124,-24},{-76,24}})));
  Modelica.Fluid.Interfaces.FluidPort_b Fuel_Out(redeclare package Medium = Medium_MoistH2) annotation (Placement(transformation(extent={{76,-24},{124,24}}), iconTransformation(extent={{76,-24},{124,24}})));
  Modelica.Blocks.Interfaces.RealOutput StackElectricalPower annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-42,108})));
  Modelica.Blocks.Interfaces.RealOutput StackTemperature annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,110})));

protected
  CEA_Energy_Process_library.Electrolysers.SOEC.Bus.ControlBus temperature_transmission annotation (Placement(transformation(extent={{108,-100},{148,-60}})));
equation

  connect(physical.controlBus, control.controlBus) annotation (Line(
      points={{0,-64},{0,-98}},
      color={255,204,51},
      thickness=0.5));
  connect(physical.feedbackBus, control.feedbackBus) annotation (Line(
      points={{-64,-47.36},{-100,-47.36},{-100,-149},{-50,-149}},
      color={255,204,51},
      thickness=0.5));
  connect(physical.Fuel_In, Fuel_In) annotation (Line(points={{-64,0},{-100,0}}, color={0,127,255}));
  connect(physical.Fuel_Out, Fuel_Out) annotation (Line(points={{64,0},{100,0}}, color={0,127,255}));
  connect(physical.ElectricalPowerConsumed, StackElectricalPower) annotation (Line(points={{0,71.68},{0,94},{-42,94},{-42,108}}, color={0,0,127}));
  connect(control.controlBus, temperature_transmission) annotation (Line(
      points={{0,-98},{0,-80},{128,-80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(temperature_transmission.T_in_cat, StackTemperature) annotation (Line(
      points={{128.1,-79.9},{178,-79.9},{178,-32},{202,-32},{202,92},{40,92},{40,110}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (experiment(StopTime=3600, __Dymola_Algorithm="Dassl"), __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=true,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Icon(graphics={                   Rectangle(
           extent={{-100,50},{100,-50}},
           fillPattern=FillPattern.Solid,
           fillColor={85,170,255},
           origin={-50,0},
           rotation=90,
           lineColor={0,0,0}),        Rectangle(
           extent={{-100,42},{100,-42}},
           fillPattern=FillPattern.Solid,
           fillColor={255,255,255},
           origin={58,0},
           rotation=90,
           lineColor={0,0,0}), Rectangle(
           extent={{-20,100},{18,-100}},
           fillPattern=FillPattern.Solid,
           fillColor={255,255,170},
           lineColor={0,0,0}), Rectangle(
           extent={{-24,100},{-16,-100}},
           fillPattern=FillPattern.VerticalCylinder,
           fillColor={135,135,135},
           lineColor={0,0,0}), Rectangle(
           extent={{16,100},{24,-100}},
           fillPattern=FillPattern.VerticalCylinder,
           fillColor={135,135,135},
           lineColor={0,0,0}),
         Ellipse(
           extent={{-80,54},{-64,38}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-64,84},{-46,66}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-60,32},{-44,16}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-50,2},{-38,-10}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-42,48},{-30,36}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-42,-26},{-32,-36}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-34,16},{-24,6}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-34,-50},{-26,-58}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-28,-14},{-22,-20}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-28,-40},{-22,-46}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-28,-68},{-22,-74}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-28,30},{-22,24}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-34,0},{-28,-6}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{-32,58},{-26,52}},
           lineColor={0,0,0},
           fillColor={170,213,255},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{38,56},{54,40}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{46,84},{64,66}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{70,66},{86,50}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{50,28},{62,16}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{24,34},{30,28}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{26,68},{32,62}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{40,14},{50,4}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{38,-8},{50,-20}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{28,8},{34,2}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{22,-10},{28,-16}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{36,-34},{46,-44}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{22,-36},{28,-42}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{32,-54},{40,-62}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Ellipse(
           extent={{22,-64},{28,-70}},
           lineColor={0,0,0},
           fillColor={128,255,0},
           fillPattern=FillPattern.Solid,
           pattern=LinePattern.None),
         Text(
           extent={{-64,100},{-32,50}},
           lineColor={0,0,0},
           fillPattern=FillPattern.HorizontalCylinder,
           fillColor={85,170,255},
           textString="O2"),
         Text(
           extent={{32,100},{64,50}},
           lineColor={0,0,0},
           fillPattern=FillPattern.HorizontalCylinder,
           fillColor={85,170,255},
           textString="H2")}),
    Documentation(info="<html>
<p>Electrolyzer Module</p>
<p>In/out : </p>
<p><br>Fuel_in, Fuel out</p>
<p><br>description :</p>
<p>This model is linked to the BoP module through MSL fluid connectors. It computes the conversion into hydrogen of the steam water provided as a function of the mass flow rate in the Fuel_in port, and then provide this information through the Fuel_out port for the BoP to handle the remaining gases. The differents models used inside are described in their own documentation sections.</p>
</html>"));
end electrolyzer_module;
