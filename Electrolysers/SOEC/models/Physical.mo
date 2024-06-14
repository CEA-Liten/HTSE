within CEA_Energy_Process_library.Electrolysers.SOEC.models;
model Physical
  "submodel for the electrolyser_module"

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

  Modelica.Electrical.Analog.Basic.Ground ground annotation (Placement(
  transformation(
  extent={{-12,-12},{12,12}},
  rotation=180,
  origin={38,-32})));
  CEA_Energy_Process_library.GeneralCircuitry.Source.Source_m_flow_T
                                          air_inlet_anode(
    redeclare package Medium = Medium_Air,
    p_start=p_start_an,
    use_m_flow_in=true,
    use_T_in=true,
    use_C_in=false,
    use_X_in=false) annotation (Placement(transformation(extent={{-160,16},{-140,36}})));
  CEA_Energy_Process_library.GeneralCircuitry.Source.Source_pT
                                    air_outlet_anode(
    redeclare package Medium = Medium_Air,
    m_flow_start=m_flow_start,
    p=p_start_an,
    T=T_start,
    use_p_in=false,
    use_T_in=false,
    use_C_in=false,
    use_X_in=false) annotation (Placement(transformation(extent={{190,18},{174,34}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent
    annotation (Placement(transformation(extent={{14,-44},{-14,-72}})));
  inner Modelica.Fluid.System system(m_flow_small=1e-8)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  CEA_Energy_Process_library.Electrolysers.SOEC.models.SOEC_replaceable SOEC(
    n_stacks=400,
    SteamConversion=0.7,
    redeclare package Medium_Air = Medium_Air,
    redeclare package Medium_Fuel = Medium_MoistH2,
    N=20,
    n_cells=250,
    redeclare CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Voltage.voltage Voltage,
    redeclare CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Temperature.thermoneutralTemperature Temperature,
    redeclare CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Mass_Flow.coFlow coFlow) annotation (Placement(transformation(
        extent={{22,21.5},{-22,-21.5}},
        rotation=180,
        origin={0,12.5})));
  CEA_Energy_Process_library.GeneralCircuitry.Source.Source_m_flow_T
                                          security_gas_inlet(
    redeclare package Medium = Medium_MoistH2,
    p_start=p_start_cat,
    X=Medium_MoistH2.moleToMassFractions({0.1,0.9,0}, Medium_MoistH2.MMX),
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=1e-6,
    T=293.15,
    use_C_in=false,
    use_X_in=false) annotation (Placement(transformation(extent={{-160,-62},{-140,-42}})));
  CEA_Energy_Process_library.GeneralCircuitry.Source.Source_m_flow_T
                                          security_gas_outlet(
    redeclare package Medium = Medium_MoistH2,
    p_start=p_start_cat,
    X=Medium_MoistH2.moleToMassFractions({1,0,0}, Medium_MoistH2.MMX),
    use_m_flow_in=true,
    use_T_in=false,
    m_flow=1e-6,
    T=293.15,
    use_C_in=false,
    use_X_in=false) annotation (Placement(transformation(extent={{80,-110},{100,-88}})));
  Modelica.Blocks.Math.Gain m_flow_inversion(k=-1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={60,-100})));
  Modelica.Blocks.Sources.RealExpression electrical_power(y=SOEC.P_el) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,66})));
  Modelica.Fluid.Interfaces.FluidPort_a Fuel_In(redeclare package Medium = Medium_MoistH2) annotation (Placement(transformation(extent={{-124,-24},{-76,24}}), iconTransformation(extent={{-124,-24},{-76,24}})));
  Modelica.Fluid.Interfaces.FluidPort_b Fuel_Out(redeclare package Medium = Medium_MoistH2) annotation (Placement(transformation(extent={{76,-24},{124,24}}), iconTransformation(extent={{76,-24},{124,24}})));
  Modelica.Blocks.Interfaces.RealOutput ElectricalPowerConsumed annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={0,112}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={0,112})));

  CEA_Energy_Process_library.Electrolysers.SOEC.Bus.ControlBus controlBus annotation (Placement(transformation(extent={{-20,-120},{20,-80}})));
  CEA_Energy_Process_library.Electrolysers.SOEC.Bus.FeedbackBus feedbackBus annotation (Placement(transformation(extent={{-120,-94},{-80,-54}})));
  Modelica.Blocks.Sources.RealExpression water_fraction(y=SOEC.n_fractions_cat[1, 1])                                    annotation (Placement(transformation(extent={{-40,-64},{-60,-44}})));
  Modelica.Blocks.Sources.RealExpression stackTemperature(y=SOEC.Temperature.T_work) annotation (Placement(transformation(extent={{-40,-84},{-60,-64}})));
  Modelica.Blocks.Sources.RealExpression Fuel_in_m_flow(y=Fuel_In.m_flow)                                                annotation (Placement(transformation(extent={{-40,-102},{-60,-82}})));
equation

  connect(ground.p,signalCurrent. p)
    annotation (Line(points={{38,-44},{38,-58},{14,-58}},
                                                 color={0,0,255}));
  connect(signalCurrent.n,SOEC. p) annotation (Line(points={{-14,-58},{-20,-58},{-20,-20},{-8.8,-20},{-8.8,-9}},
               color={0,0,255}));
  connect(signalCurrent.p,SOEC. n) annotation (Line(points={{14,-58},{20,-58},{20,-20},{8.8,-20},{8.8,-9}},
                                                               color={0,0,255}));
  connect(air_inlet_anode.port[1],SOEC. an_in_port) annotation (Line(points={{-139.8,26},{-22,26},{-22,25.4}},           color={0,127,255}));
  connect(SOEC.an_out_port,air_outlet_anode. port[1]) annotation (Line(points={{22,25.4},{22,26},{173.84,26}},          color={0,127,255}));
  connect(SOEC.cat_out_port,Fuel_Out)  annotation (Line(points={{22,-0.4},{24,0},{100,0}},                   color={0,127,255}));
  connect(Fuel_Out,Fuel_Out)  annotation (Line(points={{100,0},{100,0}}, color={0,127,255}));
  connect(Fuel_In,Fuel_In)  annotation (Line(points={{-100,0},{-100,0}}, color={0,127,255}));
  connect(security_gas_outlet.port[1],Fuel_Out)  annotation (Line(points={{100.2,-99},{100.2,-94},{100,-94},{100,0}}, color={0,127,255}));
  connect(m_flow_inversion.y,security_gas_outlet. m_flow_in) annotation (Line(points={{66.6,-100},{72,-100},{72,-92.4},{80,-92.4}}, color={0,0,127}));
  connect(security_gas_inlet.port[1],Fuel_In)  annotation (Line(points={{-139.8,-52},{-100,-52},{-100,0}}, color={0,127,255}));
  connect(SOEC.cat_in_port,Fuel_In)  annotation (Line(points={{-22,-0.4},{-24,0},{-100,0}},                          color={0,127,255}));
  connect(electrical_power.y,ElectricalPowerConsumed)  annotation (Line(points={{0,77},{0,112}}, color={0,0,127}));
  connect(controlBus.Stack_current,signalCurrent. i) annotation (Line(
      points={{0.1,-99.9},{0.1,-88},{0,-88},{0,-74.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.T_in_cat,security_gas_inlet. T_in) annotation (Line(
      points={{0.1,-99.9},{-166,-99.9},{-166,-50},{-160,-50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(controlBus.m_flow_anode,air_inlet_anode. m_flow_in) annotation (Line(
      points={{0.1,-99.9},{-166,-99.9},{-166,32},{-160,32}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(controlBus.T_in_an,air_inlet_anode. T_in) annotation (Line(
      points={{0.1,-99.9},{-102,-99.9},{-102,-100},{-166,-100},{-166,28},{-160,28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(Fuel_in_m_flow.y, feedbackBus.Fuel_in_m_flow) annotation (Line(points={{-61,-92},{-84,-92},{-84,-73.9},{-99.9,-73.9}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(stackTemperature.y, feedbackBus.SOEC_Temperature_T) annotation (Line(points={{-61,-74},{-74,-74},{-74,-73.9},{-99.9,-73.9}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(water_fraction.y, feedbackBus.water_fraction) annotation (Line(points={{-61,-54},{-84,-54},{-84,-74},{-99.9,-74},{-99.9,-73.9}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.m_flow_security_gas, m_flow_inversion.u) annotation (Line(
      points={{0.1,-99.9},{26,-99.9},{26,-100},{52.8,-100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.m_flow_security_gas, security_gas_inlet.m_flow_in) annotation (Line(
      points={{0.1,-99.9},{-166,-99.9},{-166,-46},{-160,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>Physical submodel</p>
<p>In/out : </p>
<p>Fuel_in, Fuel_out, Control bus, Feedback bus</p>
<p><br>parameters : </p>
<p><br>description : </p><p><br>regroupment of all the physical components round the electrolyzer. The goal is to be as autonomous as possible from the BOP, therefore we fin in this component : </p>
<p>- The stack.</p>
<p>- The fluid management for the anode (air provided according to the amount of fuel coming in the stack).</p>
<p>- Current management.</p>
<p>- Buses used for communication with the control submodel.</p>
</html>"));
end Physical;
