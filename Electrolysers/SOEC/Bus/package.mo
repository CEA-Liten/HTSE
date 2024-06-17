within HTSE.Electrolysers.SOEC;
package Bus

  annotation (Icon(graphics={
          Rectangle(
            lineColor={255,204,51},
            lineThickness=0.5,
            extent={{-20,-6},{20,-2}}),
          Polygon(
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            points={{-80,46},{80,46},{100,26},{80,-44},{60,-54},{-60,-54},{-80,-44},{-100,26}},
            smooth=Smooth.Bezier),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-65,11},{-55,21}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5,11},{5,21}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{55,11},{65,21}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-35,-29},{-25,-19}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{25,-29},{35,-19}})}));
end Bus;
