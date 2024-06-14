within CEA_Energy_Process_library.Units;
package SI "Library of SI unit definitions"
  extends Modelica.Icons.Package;

  type Ratio = Real (
      final quantity="Ratio",
      final unit="1",
      displayUnit="1",
      min=0,
      max=1,
      start=0.5,
      nominal=0.5);
  annotation (Icon(graphics={Text(
          extent={{-80,80},{80,-78}},
          textColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.None,
          fontName="serif",
          textString="SI",
          textStyle={TextStyle.Italic})}), Documentation(info="<html>
<p>This package provides predefined types based on the international standard
on units.
</p>
<p>
For an introduction to the conventions used in this package, have a look at:
<a href=\"modelica://Modelica.Units.UsersGuide.Conventions\">Conventions</a>.
</p>
</html>"));
end SI;
