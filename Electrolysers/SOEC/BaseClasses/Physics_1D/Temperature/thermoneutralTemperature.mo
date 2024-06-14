within CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Temperature;
model thermoneutralTemperature "adaptative temperature to maintain thermoneutral voltage"
  extends partialTemperature;
  import Modelica.Units.SI;
  import ModelicaReference.Operators;

  outer parameter Integer N;
  SI.Temperature T_work(start = 750+273.15);
  outer Real T_nodes[N];
  parameter SI.Voltage V_tn = 1.29;
  outer SI.Voltage V_cell;
  outer SI.Current I_global;
  SI.Voltage expr;

  Modelica.Blocks.Continuous.LimPID
                                 PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=1,
    Td=1,
    yMax=100,
    yMin=-100,
    Nd=20,
    xi_start=0,
    xd_start=0)                      annotation (Placement(transformation(extent={{-16,-16},{48,48}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=expr)
                                                        annotation (Placement(transformation(extent={{-170,6},{-150,26}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=0)
                                                        annotation (Placement(transformation(extent={{-22,-68},{-2,-48}})));
equation
  if time < 10 or abs(I_global) < 1e-10 then

    expr = 0;
  else
    expr = V_cell - V_tn;
  end if;

  T_work = 750 + 273.15 + PID.y; //750 + 273.15 + PID.y;

  for i in 1:N loop
    T_nodes[i] = T_work;
  end for;

  connect(realExpression1.y, PID.u_m) annotation (Line(points={{-1,-58},{16,-58},{16,-22.4}}, color={0,0,127}));
  connect(realExpression.y, PID.u_s) annotation (Line(points={{-149,16},{-22.4,16}}, color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
          Rectangle(
            extent={{4,-24},{-20,-22}},
            lineColor={0,0,0},
            pattern=LinePattern.None,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-34,-100},{38,-32}},
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Polygon(
            points={{-20,-64},{-20,82},{-16,90},{-10,94},{0,96},{10,94},{18,90},{22,82},{24,-66},{-20,-64}},
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Rectangle(
            extent={{4,0},{-20,2}},
            lineColor={0,0,0},
            pattern=LinePattern.None,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{4,22},{-20,24}},
            lineColor={0,0,0},
            pattern=LinePattern.None,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{4,42},{-20,44}},
            lineColor={0,0,0},
            pattern=LinePattern.None,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{4,62},{-20,64}},
            lineColor={0,0,0},
            pattern=LinePattern.None,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>Temperature submodel</p>
<p>In/Out : none</p>
<p>nominal characteristics : 750&deg;C</p>
<p><br>parameters :  </p>
<p>data record</p>
<p><br>description : </p><p><br>This model aims to pilot the temperature to maintain a cell voltage as close as possible to the thermoneutral voltage. There is no physic here, we assume that the electrolyzer is perfectly controlled thermically.</p>
<p><br>when piloting an electrolyzer, a lot of parameter are to take into account but one of the main goal is to maintain the thermoneutral voltage. It allows the stack to produce as much heat as it consumes and therefore be autonomous in term of thermal energy.</p>
<p>The temperature is the only parameter that has an influence on the cell voltage and isn&apos;t already under control. Therefore we use the temperature to keep the cell voltage under contol and apporach the thermoneutral value of 1.28V/cell.</p>
</html>"));
end thermoneutralTemperature;
