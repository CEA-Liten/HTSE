within CEA_Energy_Process_library.Media.Predefined.PureSubstance.Gas;
package Air
    extends CEA_Energy_Process_library.Icons.Package;

  package IdealGasAir "Air as mixture of O2,N2"
  extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
    mediumName="SOEC_IdealGasAir",
    data={Modelica.Media.IdealGases.Common.SingleGasesData.O2,
          Modelica.Media.IdealGases.Common.SingleGasesData.N2},
    fluidConstants={Modelica.Media.IdealGases.Common.FluidData.O2,
                    Modelica.Media.IdealGases.Common.FluidData.N2},
    substanceNames = {"O2","N2"},
    referenceChoice=Modelica.Media.Interfaces.Choices.ReferenceEnthalpy.ZeroAt25C,
     excludeEnthalpyOfFormation=true,
    h_offset=0,
    reference_X=Modelica.Media.IdealGases.Common.MixtureGasNasa.moleToMassFractions({0.21,0.79},{Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM,
          Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM}));

      extends CEA_Energy_Process_library.Icons.VariantPackage;

     redeclare function dynamicViscosity
       "Return dynamic viscosity of dry air (simple polynomial, moisture influence small, valid from 123.15 K to 1273.15 K, outside of this range linear extrapolation is used)"
       extends Modelica.Icons.Function;
       input ThermodynamicState state "Thermodynamic state record";
       output DynamicViscosity eta "Dynamic viscosity";
       import Modelica.Math.Polynomials;
        import Cv = Modelica.Units.Conversions;
     algorithm
       eta := 1e-6*Polynomials.evaluateWithRange(
           {9.7391102886305869E-15,-3.1353724870333906E-11,4.3004876595642225E-08,
           -3.8228016291758240E-05,5.0427874367180762E-02,1.7239260139242528E+01},
           Cv.to_degC(123.15),
           Cv.to_degC(1273.15),
           Cv.to_degC(state.T));
       annotation (smoothOrder=2, Documentation(info="<html>
 <p>Dynamic viscosity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure is neglected.</p>
 <p>Source: VDI Waermeatlas, 8th edition.</p>
 </html>"));
     end dynamicViscosity;

     redeclare function thermalConductivity
       "Return thermal conductivity of dry air (simple polynomial, moisture influence small, valid from 123.15 K to 1273.15 K, outside of this range linear extrapolation is used)"
       extends Modelica.Icons.Function;
       input ThermodynamicState state "Thermodynamic state record";
       input Integer method=1 "Dummy for compatibility reasons";
       output ThermalConductivity lambda "Thermal conductivity";
       import Modelica.Math.Polynomials;
        import Cv = Modelica.Units.Conversions;
     algorithm
       lambda := 1e-3*Polynomials.evaluateWithRange(
           {6.5691470817717812E-15,-3.4025961923050509E-11,5.3279284846303157E-08,
           -4.5340839289219472E-05,7.6129675309037664E-02,2.4169481088097051E+01},
           Cv.to_degC(123.15),
           Cv.to_degC(1273.15),
          Cv.to_degC(state.T));

       annotation (smoothOrder=2, Documentation(info="<html>
 <p>Thermal conductivity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure is neglected.</p>
 <p>Source: VDI Waermeatlas, 8th edition.</p>
 </html>"));
     end thermalConductivity;
  annotation (Documentation(info="<html>

</html>"));
  end IdealGasAir;
  annotation (Icon(graphics={Bitmap(extent={{-76,-80},{78,80}},
            fileName="modelica://CEA_Energy_Process_library/Images/MoistGas.png")}),
    Documentation(info="<html>
<p>Air media model from the MSL.</p>
</html>"));
end Air;
