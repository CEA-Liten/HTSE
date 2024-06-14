within CEA_Energy_Process_library.Icons;
partial package InterfacesPackage
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Polygon(fillColor={238,46,47},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-100,20},{-60,20},{-30,70},{-10,70},{-10,-70},{-30,-70},{-60,
              -20},{-100,-20}}),
        Polygon(origin={20,0},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          points={{-10.0,70.0},{10.0,70.0},{40.0,20.0},{80.0,20.0},{80.0,-20.0},{40.0,-20.0},{10.0,-70.0},{-10.0,-70.0}},
          lineThickness=0.5)}));
end InterfacesPackage;
