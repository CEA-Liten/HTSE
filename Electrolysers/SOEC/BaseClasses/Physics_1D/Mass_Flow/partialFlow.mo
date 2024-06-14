within CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Mass_Flow;
partial model partialFlow "partial model for flow inside the electrolyzer"

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
          extent={{-20,96},{20,-96}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-98,-32},{-32,30}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,-30},{98,32}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,24},{0,24},{0,48},{56,2},{0,-46},{0,-36},{0,-26},{-48,-26},{-48,24}},
          lineColor={28,108,200},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>partial model used to verify the compatibility with the SOEC_replaceable model. Flow submodels have to be an extends of this partialFlow.</p>
</html>"));
end partialFlow;
