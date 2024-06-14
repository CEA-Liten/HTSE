within CEA_Energy_Process_library.Electrolysers.SOEC.Bus;
expandable connector FeedbackBus "Control bus that is adapted to the signals connected to it"
 import    Modelica.Units.SI;

 SI.MassFlowRate Fuel_in_m_flow;
 SI.Temperature SOEC_Temperature_T;
 Real water_fraction;

  annotation (Icon(graphics={
          Rectangle(
            lineColor={255,204,51},
            lineThickness=0.5,
            extent={{-20,-2},{20,2}}),
          Polygon(
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,-40},{-100,30}},
            smooth=Smooth.Bezier),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-65,15},{-55,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5,15},{5,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{55,15},{65,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-35,-25},{-25,-15}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{25,-25},{35,-15}})}), Documentation(info="<html>
<p>Bus for the different signals coming into the control submodel for feedback from the physical sub component.</p>
</html>"));
end FeedbackBus;
