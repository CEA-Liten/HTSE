within CEA_Energy_Process_library.Media.Predefined.Mixture.Gas;
package IdealGasMixture_H2O_H2_N2
 extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
  mediumName="SOEC_H2_H2O_N2",
  data={Modelica.Media.IdealGases.Common.SingleGasesData.H2O,Modelica.Media.IdealGases.Common.SingleGasesData.H2,Modelica.Media.IdealGases.Common.SingleGasesData.N2},
  fluidConstants={Modelica.Media.IdealGases.Common.FluidData.H2O,Modelica.Media.IdealGases.Common.FluidData.H2,Modelica.Media.IdealGases.Common.FluidData.N2},
  substanceNames = {"H2O","H2","N2"},reference_X={0.0,1.0,0.0});

 constant Integer water=1  "Index of water (in substanceNames, massFractions X, etc.)";
 constant Integer H2=2   "Index of H2 (in substanceNames, massFractions X, etc.)";
  constant Integer N2=3   "Index of H2 (in substanceNames, massFractions X, etc.)";

  extends CEA_Energy_Process_library.Icons.VariantPackage;

  annotation (Documentation(info="<html>
<p>Ideal gas model applied to the mixture of hydrogen, steam and nitrogen typically used in high temperature steam electrolysers.</p>
</html>"));
end IdealGasMixture_H2O_H2_N2;
