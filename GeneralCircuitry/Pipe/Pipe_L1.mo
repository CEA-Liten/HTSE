within CEA_Energy_Process_library.GeneralCircuitry.Pipe;
model Pipe_L1 "Pressure losses from linear or quadratic law dp=KV^n - K coefficient calculated using nominal values of pressure losses and mass/volumic flow  "

//________________________________________________________________________________//

// ________________________________________________________________________________________________
//          Imports and Class Hierarchy

extends BaseClasses.PartialPipe;
import Modelica.Units.SI;
import Modelica.Fluid.Utilities.regStep;
import Modelica.Fluid.Utilities.regRoot2;

public
  parameter SI.PressureDifference dp_Nom=1000 "Nominal Pressure Drop " annotation(Dialog(group= "Nominal pressure drop"));
  parameter SI.VolumeFlowRate V_flow_Nom=100/3600 "Nominal  volumic flow(@1 Bar, 273.15K, X_default)" annotation(Dialog(enable=Choice_mV_flow,group= "Nominal pressure drop"));
  parameter SI.MassFlowRate m_flow_Nom=V_flow_Nom * Medium.density(Medium.setState_phX(1e5, Medium.specificEnthalpy_pTX(1e5, 273.15, X_start),  X_start))  "Nominal Flow Rate" annotation(Dialog(enable=not
                                                                                                                                                                                                  (Choice_mV_flow),group= "Nominal pressure drop"));

  parameter Integer n(min=1,max=2)=2 "Pressure losses exponent (linear=1, quadratic=2)" annotation(Dialog(group= "Specifications"));
  parameter Boolean Choice_mV_flow=true "= true, if Dp=KV^2, = false si dP=Km^2" annotation(Dialog(group="Specifications"),choices(checkBox=true));
  parameter Boolean Check_Valve=false "= true, if stop reverse flow" annotation(Dialog(group="Specifications"),choices(checkBox=true));

Real K "used to determine pressure loss dp = K * V^n or dp = K * m^2";

//=============================================================================================================

equation

    if dp_Nom>0 then

      if Choice_mV_flow==true then
          K=dp_Nom/(V_flow_Nom^n);

          if Check_Valve==true then
            V_flow = if n==1 then
                              regStep(dp-dp_small, dp/K, 0, dp_small)
                             else
                              homotopy(actual=regRoot2(x=dp, x_small=dp_small, k1=1/K, k2=0/K),
                                       simplified=regStep(dp-dp_small, dp/dp_Nom*V_flow_Nom, 0, dp_small));
          else
            V_flow = if n==1 then
                               dp/K
                             else
                              homotopy(actual=regRoot2(x=dp, x_small=dp_small, k1=1/K, k2=1/K),
                                       simplified=dp/dp_Nom*V_flow_Nom);
          end if;

      else
          K=dp_Nom/(m_flow_Nom^n);

          if Check_Valve==true then
           In.m_flow = if n==1 then
                                  regStep(dp-dp_small, dp/K, 0, dp_small)
                                else
                                  homotopy(actual=regRoot2(x=dp, x_small=dp_small, k1=1/K, k2=0/K),
                                           simplified=regStep(dp-dp_small, dp/dp_Nom*m_flow_Nom, 0, dp_small));
          else
           In.m_flow = if n==1 then
                                 dp/K
                               else
                                 homotopy(actual=regRoot2(x=dp, x_small=dp_small, k1=1/K, k2=1/K, yd0=0),
                                          simplified=dp/dp_Nom*m_flow_Nom);
          end if;

      end if;
    else
       dp = 0;
       K = 0;
    end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={                                                      Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-66,28},{64,-22}},
          textColor={28,108,200},
          textString="n = %n")}),                                Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p></span><b><span style=\"font-size: 10.8pt;\">Role of the Model</b></p>
<p>This piping model defines pressure losses based on a nominal point and a linear or quadratic law as a function of mass or volumetric flow rate. As a model representing pressure losses, it is crucial for system development and is used in numerous component models.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Interfaces and Components</b></p>
<p>The model extends the PartialPipe model and includes two fluid interfaces, In and Out. A media type must also be selected.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Performance Enhancement Functions</b></p>
<p>The <span style=\"font-family: Courier New;\">regStep</span> function from the MSL is used to regularize flow rates when the CheckValve option, which blocks reverse flow from Out to In, is enabled. The <span style=\"font-family: Courier New;\">regRoot2</span> function regularizes the square root function <span style=\"font-family: Courier New;\">sqrt()</span> for calculating flow rates based on pressure losses. The <span style=\"font-family: Courier New;\">homotopy</span> function facilitates simulation startup.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Modeling</b></p>
<p>The pressure loss law is defined based on the boolean option <span style=\"font-family: Courier New;\">Choice_mV_flow</span>:</p>
<ul>
<li>If <span style=\"font-family: Courier New;\">Choice_mV_flow=true</span>, the pressure loss law is defined according to volumetric flow rate (theoretically more accurate): <span style=\"font-family: Courier New;\">dp=K.ṁin^n</span></li>
<li>If <span style=\"font-family: Courier New;\">Choice_mV_flow=false</span>, the pressure loss law is defined according to mass flow rate (theoretically incorrect but simplifies simulation convergence, especially for compressible fluids): <span style=\"font-family: Courier New;\">dp=K.Vin^n</span></li>
</ul>
<p>Here, <span style=\"font-family: Courier New;\">n=1</span> or <span style=\"font-family: Courier New;\">n=2</span>, defining a linear (n=1) or quadratic (n=2) pressure loss law. K is the pressure loss coefficient derived from nominal operating data, with units depending on the values of n and <span style=\"font-family: Courier New;\">Choice_mV_flow</span>. The model icon indicates the type of pressure loss chosen by the user (<span style=\"font-family: Courier New;\">n=1</span> or <span style=\"font-family: Courier New;\">n=2</span>).</p>
<p>When the CheckValve option is activated, flows from Out to In are nullified (set to zero) regardless of the pressure loss.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Limitations</b></p>
<p>This simple model avoids the complex calculation of pipe friction coefficients.</p>
<p></span><b><span style=\"font-size: 10.8pt;\">Tips</b></p>
<ul>
<li>The regularization of reverse flows (with the CheckValve option) is performed using the <span style=\"font-family: Courier New;\">dp_small</span> parameter. Proper parameterization is important.</li>
<li>This model is widely used in the library. For complex components (e.g., condensers), it is often advantageous to switch to linear pressure losses based on mass flow rate or to annul them (<span style=\"font-family: Courier New;\">dp_Nom=0</span>).</li>
</ul>
</html>"));
end Pipe_L1;
