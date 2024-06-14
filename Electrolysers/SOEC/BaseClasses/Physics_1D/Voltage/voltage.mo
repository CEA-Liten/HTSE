within CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Physics_1D.Voltage;
model voltage "equations from the publication of Jérôme Laurencin"
  extends partialVoltage;
 import Modelica.Units.SI;
  import SubPos = CEA_Energy_Process_library.Utilities.UtilitiesFunction.SubstancePosition;
  import Cst = Modelica.Constants;
  import math = Modelica.Math;

 //resistance
 outer parameter Integer N;
 outer parameter Integer n_stacks;
 outer parameter Integer n_cells;
  outer parameter CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.Data.cell_parameter data;
 parameter SI.Resistance Rc = data.epc / data.rhoNI8YSZ "cathode electrical resistance";
 parameter SI.Resistance Ra = data.epa / data.rhoLSM "anode electrical resistance";

 // position of gas elements in medias
 outer constant Integer Pos_O2;
 outer constant Integer Pos_H2;
 outer constant Integer Pos_H2O;
 outer constant Integer Pos_N2;

 //chemical components
  outer SI.MoleFraction[N,Medium_Air.nX] n_fractions_an "molar fractions of components in the anode gas channel";
  outer SI.MoleFraction[N,Medium_Fuel.nX] n_fractions_cat "molar fractions of the components in the cathode gas channel";

  outer SI.MoleFraction x_H2_TPBc[N] "molar fraction of hydrogen at the cathode triple phase boundary (TPBc)";
  outer SI.MoleFraction x_O2_TPBa[N] "molar fraction of oxygen at the anode triple phase boundary (TPBa)";
  outer SI.MoleFraction x_H2O_TPBc[N] "molar fraction of water at the cathode triple phase boundary (TPBc)";

  //electro chemical model
  outer SI.Current I_global "current provided to the whole stack";
  outer SI.CurrentDensity I_dens[N] "surface current";
  outer SI.CurrentDensity I_avg "average current density over the cell";
  outer SI.Voltage V_global "potential of the whole stack";
  outer SI.Voltage V_cell "potential of 1 cell";
  outer Real T_nodes[N] "local temperature along the gas channels";
  outer SI.Pressure Pt;

  //media

  replaceable package Medium_Air =
   CEA_Energy_Process_library.Media.Predefined.PureSubstance.Gas.Air.IdealGasAir
   constrainedby Modelica.Media.Interfaces.PartialMedium "Air model"  annotation (Dialog(group="Fluids"));

 replaceable package Medium_Fuel =
   CEA_Energy_Process_library.Media.Predefined.Mixture.Gas.IdealGasMixture_H2O_H2_N2
 constrainedby Modelica.Media.Interfaces.PartialMedium "fuel media";

    Modelica.Electrical.Analog.Interfaces.PositivePin p_submodel annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n_submodel annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  SI.Resistance Re[N] "electrolyte resistance";
  SI.Resistance Rcont[N] "contact resistance between cells (SRU)";
  SI.Current i0_anode[N] "anode exchange current density";
  SI.Current i0_cathode[N] "cathode exchange current density";

  SI.Energy G0[N];
  //Gibb's free energy
  SI.Voltage V_nernst[N];
  //Nernst's potential (open circuit voltage + concentration overpotential)
  SI.Voltage V_act[N] "local activation overpotential";
  SI.Voltage V_ohm[N] "local ohmic overpotential";
  SI.Voltage V_conc[N] "local concentration overpotential";

equation

   //general
 I_global =p_submodel.i/n_stacks;
 n_submodel.i = -p_submodel.i;

  //electrochemical model
  V_global = p_submodel.v - n_submodel.v;
                     //overall potential of the stack
  V_global = V_cell*n_cells;
  // every cell is considered equivalent to the others
  for
   j in 1:N loop
 //open circuit voltage
 G0[j] = (-248.3 + 0.0557*T_nodes[j])*1e3;
 V_nernst[j] = -G0[j]/(2*Cst.F) + (Cst.R * T_nodes[j])/(2*Cst.F)*log(n_fractions_cat[j,Pos_H2]*sqrt(n_fractions_an[j,Pos_O2])/(n_fractions_cat[j,Pos_H2O])); //i = 0

 //activation overpotential
 i0_anode[j] = data.I00_an*(n_fractions_an[j,Pos_O2])^data.alpha_O2*exp((-data.Eact_an)/(Cst.R*T_nodes[j])); // i = 0
  i0_cathode[j] = data.I00_cath*(n_fractions_cat[j,Pos_H2])^data.alpha_H2*(n_fractions_cat[j,Pos_H2O])^data.beta_H2O*exp((-data.Eact_cath)/(Cst.R*T_nodes[j])); // i = 0

 V_act[j] = Cst.R*T_nodes[j]/Cst.F * (math.asinh(I_dens[j]/(2*i0_anode[j])) + math.asinh(I_dens[j]/(2*i0_cathode[j])));

 //concentration overpotential
 V_conc[j] =  (Cst.R * T_nodes[j])/(4*Cst.F) *(2*log((n_fractions_cat[j,Pos_H2O] * x_H2_TPBc[j])/(x_H2O_TPBc[j]*n_fractions_cat[j,Pos_H2])) + log(x_O2_TPBa[j]/n_fractions_an[j,Pos_O2]));

 //Ohmic overpotential
 Re[j] = data.epe / (466*1e2*exp(-9934/T_nodes[j]));
    Rcont[j] = CEA_Energy_Process_library.Electrolysers.SOEC.BaseClasses.ContactResistance.contactResistance(T_nodes[j]);
 V_ohm[j] = (Rc + Ra + Re[j] + Rcont[j]) * I_dens[j];

 //concentration overpotential

 //sum
 V_cell = V_nernst[j] + V_ohm[j] + V_act[j] + V_conc[j];

  end for;

  sum(I_dens[:])*data.SOEC_area/N = I_global;
  //local currents adds up to the the overall current
  I_avg = sum(I_dens[:])/N;

 annotation (choicesAllMatching = true,Dialog(group="Fluids"),
    Documentation(info="<html>
<p>Electro-chemical submodel </p>
<p>In/Out : </p>
<p>electrical pin p_submodel, electrical pin n_submodel</p>
<p>Nominal : The nominal values depends strongly on the cell characteristics described in the Data record. The cell voltage is nominal at 1.28V/cell and is maintained like this through the Temperature submodel.</p>
<p>parameters : data record</p>
<p><br>description : </p><p><br>submodel of the high temperature steam electrolyzer. This submodel focuses on describing the value of the cell voltage interacting with the flow submodel.</p>
<p>The equations are described in the scientific publication : <span style=\"font-family: Arial; color: #262626;\">J. Laurencin et al. Modelling of solid oxide steam electrolyser: Impact of the operating conditions on hydrogen production, Journal of Power Sources, Volume 196, Issue 4, 2011.</span></p>
<p>The model is conected through two electrical pins, these pins handle the informations from the whole stack, and then the submodel reduce them to manipulate one cell. The informations from one cell is then multiplied by the number of cells per stack and the number of stacks to model the whole system.</p>
<p><br>This model use fully the acausal capability of MODELICA. The total current from the electrolyzer is brought to the model. We consider than the cell is under the same voltage on all of it&apos;s surface. </p>
<p>For each discretization nodes we compute the value of each overpotential (ohmic, activation, concentration and the Nernst voltage) using values of current density, molar fractions and temperature which are calculated in parallel.</p>
<p>then the current density has to respect the equation : global current = current density * cell surface.</p>
<p>each overpotential depends strongly on temperature, current density, molar fractions and data coming from the other submodels.</p>
</html>"));
end voltage;
