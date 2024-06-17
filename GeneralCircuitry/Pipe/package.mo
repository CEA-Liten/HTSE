within HTSE.GeneralCircuitry;
package Pipe
   extends HTSE.Icons.Package;

  annotation (Icon(graphics={
        Ellipse(
          extent={{-36,30},{-60,-30}},
          lineColor={238,46,47},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,215,215}),             Rectangle(
          extent={{-48,30},{52,-30}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={238,46,47}),
        Ellipse(
          extent={{64,30},{40,-30}},
          lineColor={238,46,47},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255})}));
end Pipe;
