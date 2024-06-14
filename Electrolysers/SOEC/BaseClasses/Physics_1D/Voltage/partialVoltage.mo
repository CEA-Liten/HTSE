within CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Voltage;
partial model partialVoltage "base class for all voltage submodels"
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
        Polygon(
          points={{-16,72},{26,72},{8,14},{20,14},{-4,-40},{6,-40},{-12,-90},{-8,-48},{-20,-48},{-8,4},{-24,4},{-16,72}},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-92,6},{-50,-6}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{50,6},{92,-6}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{66,-22},{78,22}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}), Documentation(info="<html>
<p>partial model used to verify the compatibility with the SOEC_replaceable model. Voltage submodels have to be an extends of this partialVoltage.</p>
</html>"));
end partialVoltage;
