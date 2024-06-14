within CEA_Energy_Process_library.Electrolysers.SOEC.models;
model Control
  "submodel for the electroliser_module"
  Modelica.Blocks.Sources.RealExpression stack_current(y=water_fraction/0.9*max({Fuel_In_m_flow/1*21700,0}))             annotation (Placement(transformation(extent={{100,78},{80,98}})));
  Modelica.Blocks.Sources.Ramp Current_ramp(
    height=1,
    duration=300,
    offset=0,
    startTime=300) annotation (Placement(transformation(extent={{124,24},{108,40}})));
  Modelica.Blocks.Math.MultiProduct multiProduct2(nu=3) annotation (Placement(transformation(extent={{82,54},{70,66}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime=60) annotation (Placement(transformation(extent={{30,50},{10,70}})));
  Modelica.Blocks.Sources.RealExpression m_flow_N2_secure(y=max({0,0.1 - Fuel_In_m_flow})) annotation (Placement(transformation(extent={{-64,-58},{-44,-38}})));
  Modelica.Blocks.Math.Gain gain(k=2) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={78,-4})));
  Modelica.Blocks.Sources.RealExpression m_flow_fuel(y=max({Fuel_In_m_flow,1e-8})) annotation (Placement(transformation(extent={{116,-14},{96,6}})));
  CEA_Energy_Process_library.Electrolysers.SOEC.Bus.FeedbackBus feedbackBus annotation (Placement(transformation(extent={{-120,-22},{-80,18}}), iconTransformation(extent={{-120,-22},{-80,18}})));

  CEA_Energy_Process_library.Electrolysers.SOEC.Bus.ControlBus controlBus annotation (Placement(transformation(extent={{-20,80},{20,120}}), iconTransformation(extent={{-20,80},{20,120}})));

  Modelica.Blocks.Sources.RealExpression temperature(y=SOEC_Temperature) annotation (Placement(transformation(extent={{-46,-38},{-26,-18}})));
  Modelica.Blocks.Sources.RealExpression stack_current1(y=smooth(1, if Fuel_In_m_flow < 0.1 then 0.0 else 1.0))          annotation (Placement(transformation(extent={{222,46},{202,66}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k=1, T=60,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y_start=0)                                                annotation (Placement(transformation(extent={{174,46},{154,66}})));
protected
    Modelica.Blocks.Interfaces.RealOutput SOEC_Temperature annotation (Placement(transformation(extent={{-42,-12},{-22,8}}), iconTransformation(extent={{-42,-12},{-22,8}})));
  Modelica.Blocks.Interfaces.RealOutput Fuel_In_m_flow annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,36}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,-20})));
  Modelica.Blocks.Interfaces.RealOutput water_fraction annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,-40}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-20})));
equation
  connect(Current_ramp.y,multiProduct2. u[1]) annotation (Line(points={{107.2,32},{88,32},{88,58.6},{82,58.6}},   color={0,0,127}));
  connect(stack_current.y,multiProduct2. u[2]) annotation (Line(points={{79,88},{76,88},{76,70},{86,70},{86,60},{82,60}},       color={0,0,127}));
  connect(multiProduct2.y,fixedDelay. u) annotation (Line(points={{68.98,60},{32,60}},       color={0,0,127}));
  connect(m_flow_fuel.y,gain. u) annotation (Line(points={{95,-4},{85.2,-4}},     color={0,0,127}));
  connect(fixedDelay.y, controlBus.Stack_current) annotation (Line(points={{9,60},{0.1,60},{0.1,100.1}},       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gain.y, controlBus.m_flow_anode) annotation (Line(points={{71.4,-4},{0.1,-4},{0.1,100.1}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(feedbackBus.Fuel_in_m_flow, Fuel_In_m_flow) annotation (Line(
      points={{-99.9,-1.9},{-100,-1.9},{-100,36}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(feedbackBus.SOEC_Temperature_T, SOEC_Temperature) annotation (Line(
      points={{-99.9,-1.9},{-64,-1.9},{-64,-2},{-32,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(feedbackBus.water_fraction, water_fraction) annotation (Line(
      points={{-99.9,-1.9},{-100,-1.9},{-100,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(temperature.y, controlBus.T_in_cat) annotation (Line(points={{-25,-28},{0.1,-28},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(temperature.y, controlBus.T_in_an) annotation (Line(points={{-25,-28},{0.1,-28},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stack_current1.y, firstOrder.u) annotation (Line(points={{201,56},{176,56}}, color={0,0,127}));
  connect(firstOrder.y, multiProduct2.u[3]) annotation (Line(points={{153,56},{88,56},{88,58},{82,58},{82,61.4}}, color={0,0,127}));
  connect(m_flow_N2_secure.y, controlBus.m_flow_security_gas) annotation (Line(points={{-43,-48},{0.1,-48},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (                                                                          Diagram(graphics={
                                                                                          Text(
          extent={{20,-68},{98,-98}},
          textColor={28,108,200},
          textString="CONTROL")}), Documentation(info="<html>
<p>Control submodel </p>
<p>In/out : </p>
<p>control bus, feedback bus</p>
<p><br>parameters :</p>
<p><br>description:</p>
<p><br>Regroupment of the different inputs given to the physical submodel. The temperature of fluid in the anode, security gas source for the cathode, mass flow rate of the security gas, and most importatly the stack current are piloted given feedback from the physical component.</p>
<p>The current signal is given a ramp early on in the simulation so that the components from the BoP and the stack are given time to initialise. Then a delay of 60 second is imposed in order to desynchronise the variation from the BoP and the variation of current.</p>
</html>"));
end Control;
