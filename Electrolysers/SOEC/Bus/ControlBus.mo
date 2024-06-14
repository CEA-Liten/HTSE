within CEA_Energy_Process_library.Electrolysers.SOEC.Bus;
expandable connector ControlBus "Control bus that is adapted to the signals connected to it"
 import    Modelica.Units.SI;

 SI.MassFlowRate m_flow_security_gas;
 SI.MassFlowRate m_flow_anode;
 SI.Temperature T_in_cat;
 SI.Temperature T_in_an;

 SI.Current Stack_current;

  annotation (Icon(graphics={
          Rectangle(
            lineColor={255,204,51},
            lineThickness=0.5,
            extent={{-20,-8},{20,-4}}),
          Polygon(
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            points={{-80,44},{80,44},{100,24},{80,-46},{60,-56},{-60,-56},{-80,-46},{-100,24}},
            smooth=Smooth.Bezier),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-65,9},{-55,19}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5,9},{5,19}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{55,9},{65,19}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-35,-31},{-25,-21}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{25,-31},{35,-21}})}), Documentation(info="<html>
<p>bus for the different control signals coming out of the control submodel.</p>
</html>"));
end ControlBus;
