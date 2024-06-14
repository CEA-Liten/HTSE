within CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Temperature;
partial model partialTemperature "partial model for temperature"

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
<p>partial model used to verify the compatibility with the SOEC_replaceable model. Temperature submodels have to be an extends of this partialTemperature.</p>
</html>"));
end partialTemperature;
