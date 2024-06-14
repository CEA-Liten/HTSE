within CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.ContactResistance;
function contactResistance

  extends partialContactResistance;
 import Modelica.Units.SI;
 output SI.Resistance ContactRes;
 input SI.Temperature T;
 input SI.Resistance resistance = 0.1/(1e4);

algorithm
 ContactRes := resistance;

  annotation (Documentation(info="<html>
<p>constant contact resistance between SRUs.</p>
</html>"));
end contactResistance;
