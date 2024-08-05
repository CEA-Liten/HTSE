within HTSE.Electrolysers.SOEC.BaseClasses.Physics_1D.Mass_Flow;
model coFlow "simple co flow configuration"
  extends partialFlow;
  import Modelica.Units.SI;
import SubPos=HTSE.Utilities.UtilitiesFunction.SubstancePosition;
import Cst = Modelica.Constants;
import math = Modelica.Math;

  outer parameter Integer N;
  outer SI.Pressure p_an[N];
  outer SI.Pressure p_cat[N];
  outer Integer n_stacks;
  outer Integer n_cells;

  // position of gas elements in medias
  outer constant Integer Pos_O2;
  outer constant Integer Pos_H2;
  outer constant Integer Pos_H2O;
  outer constant Integer Pos_N2;

  //electrical variables
  outer SI.CurrentDensity I_dens[N];
  outer Real T_nodes[N];

  //starting values
  parameter SI.MassFlowRate m_flow_start=0
  "Simulation start value mass flow at fluid interfaces"
  annotation (Dialog(group="Initial values"));
   parameter SI.Pressure cat_p_start=1*1e5
  "Cathode Simulation start value pressure "
  annotation (Dialog(group="Initial values"));
   parameter SI.Pressure an_p_start=1*1e5
  "Anode Simulation start value pressure "
  annotation (Dialog(group="Initial values"));
   parameter SI.Temperature T_op_start=273.15 + 750
  "Initial electrolyzer temperature"
  annotation (Dialog(group="Initial values"));

 parameter SI.MassFraction[Medium_Fuel.nX] X_start_cat=Medium_Fuel.X_default
  "Initial cathode Mass Fractions"
  annotation (Dialog(group="Initial values"));
   parameter SI.MassFraction[Medium_Air.nX] X_start_an=Medium_Air.X_default
  "Initial anode Mass Fractions" annotation (Dialog(group="Initial values"));

  //molar flow rates of the different components in anode and cathode gas channels
   SI.MolarFlowRate[N] n_flow_an_total "total molar flow rate in the anode gas channels";
   SI.MolarFlowRate[N] n_flow_cat_total "total molar flow rate in the cathode gas channels";
SI.MassFlowRate m_flow_an_total[N];
outer SI.MassFlowRate m_flow_cat_total[N];

outer SI.MoleFraction[N,Medium_Air.nX] n_fractions_an "molar fractions of components in the anode gas channel";
outer SI.MoleFraction[N,Medium_Fuel.nX] n_fractions_cat "molar fractions of the components in the cathode gas channel";

outer SI.MolarFlowRate[N,Medium_Air.nX] n_flow_an_channel "molar flow rate of the components in the anode gas channel";
outer SI.MolarFlowRate[N,Medium_Fuel.nX] n_flow_cat_channel "molar flow rate of the components in the cathode gas channel";

// interface molar concentrations using Dusty Gas Model (DGM)
outer SI.MoleFraction x_H2_TPBc[N] "molar fraction of hydrogen at the cathode triple phase boundary (TPBc)";
outer SI.MoleFraction x_O2_TPBa[N] "molar fraction of oxygen at the anode triple phase boundary (TPBa)";
outer SI.MoleFraction x_H2O_TPBc[N] "molar fraction of water at the cathode triple phase boundary (TPBc)";

//Real k1[N] "integrated coefficient from DGM";
Real k2[N] "integrated coefficient from DGM";
Real DeffH2k[N]; //diffusion coefficients
Real DeffH2H2O[N];
Real DeffH2Ok[N];
Real DeffO2[N];
Real DeffO2k[N];
Real k4[N] "integrated coefficient from DGM";

    replaceable package Medium_Air =
    HTSE.Media.Predefined.PureSubstance.Gas.Air.IdealGasAir
    constrainedby Modelica.Media.Interfaces.PartialMedium "Air model"  annotation (Dialog(group="Fluids"));

  replaceable package Medium_Fuel =
    HTSE.Media.Predefined.Mixture.Gas.IdealGasMixture_H2O_H2_N2
  constrainedby Modelica.Media.Interfaces.PartialMedium
  annotation (choicesAllMatching = true,Dialog(group="Fluids"));

// states
Medium_Air.BaseProperties[N] state_an(
  each preferredMediumStates=false,      each T( start= T_op_start),
                                         each p(start = an_p_start),
                                         each  X(start=X_start_an[1:Medium_Air.nX]));

 Medium_Fuel.BaseProperties[N] state_cat(
  each preferredMediumStates=false,      each T(start = T_op_start),
                                         each p(start = cat_p_start),
                                         each  X(start={0.9,0.1,0}));

  parameter HTSE.Electrolysers.SOEC.BaseClasses.Data.cell_parameter data;

   Modelica.Fluid.Interfaces.FluidPort_b an_out_port_submodel(redeclare package Medium = Medium_Air) annotation (Placement(transformation(extent={{90,50},{110,70}})));
   Modelica.Fluid.Interfaces.FluidPort_a cat_in_port_submodel(redeclare package Medium = Medium_Fuel) annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
   Modelica.Fluid.Interfaces.FluidPort_b cat_out_port_submodel(redeclare package Medium = Medium_Fuel) annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
   Modelica.Fluid.Interfaces.FluidPort_a an_in_port_submodel(redeclare package Medium = Medium_Air) annotation (Placement(transformation(extent={{-110,50},{-90,70}})));

equation
  /// IN - OUT
     //anode
    state_an[1].h =inStream(an_in_port_submodel.h_outflow);
                                                    //transmission of information from the connector to the first anode state
    state_an[1].h =an_in_port_submodel.h_outflow;
    state_an[1].X[:] =inStream(an_in_port_submodel.Xi_outflow);
    state_an[1].X =an_in_port_submodel.Xi_outflow;
    state_an[1].p =an_in_port_submodel.p;

    state_an[N].p =an_out_port_submodel.p;
                                   //same with the last state
    state_an[N].X[:] =actualStream(an_out_port_submodel.Xi_outflow);
    state_an[N].h =actualStream(an_out_port_submodel.h_outflow);

  //an_in_port_submodel.m_flow = - an_out_port_submodel.m_flow;
  -an_out_port_submodel.m_flow = m_flow_an_total[N]*n_stacks;
                                             //mass conservation, no dynamics there
  inStream(an_in_port_submodel.C_outflow) = an_out_port_submodel.C_outflow;

    //catode
    state_cat[1].h =inStream(cat_in_port_submodel.h_outflow);
                                                      //same as above with the cathode
    state_cat[1].h =cat_in_port_submodel.h_outflow;
    state_cat[1].X[:] =inStream(cat_in_port_submodel.Xi_outflow);
    state_cat[1].X =cat_in_port_submodel.Xi_outflow;
    state_cat[1].p =cat_in_port_submodel.p;

    state_cat[N].p =cat_out_port_submodel.p;
    state_cat[N].X[:] =actualStream(cat_out_port_submodel.Xi_outflow);
    state_cat[N].h =actualStream(cat_out_port_submodel.h_outflow);

  //cat_in_port_submodel.m_flow = -cat_out_port_submodel.m_flow;
  -cat_out_port_submodel.m_flow = m_flow_cat_total[N]*n_stacks;
  inStream(cat_in_port_submodel.C_outflow) = cat_out_port_submodel.C_outflow;

  /// DEFINITIONS OF MOLAR FRACTIONS/FLOW VECTORS IN GAS CHANNEL

   //filling of molar flow rate vectors in the cathode and anode
   for i in 1:N loop
     m_flow_an_total[i] = n_flow_an_total[i]*state_an[i].MM;
     m_flow_cat_total[i] = n_flow_cat_total[i]*state_cat[i].MM;
   end for;
   //anode
     for i in 1:Medium_Air.nX loop
       n_flow_an_channel[1,i] = an_in_port_submodel.m_flow/n_stacks*an_in_port_submodel.Xi_outflow[i]/Medium_Air.MMX[i];
       // pb on retrouve pas le même débit molaire qu'en entrée
    end for;

     n_fractions_an[1,:] =
     Medium_Air.massToMoleFractions(
     state_an[1].X, Medium_Air.MMX);
     n_flow_an_total[1] = sum(n_flow_an_channel[1,:]);

   //cathode
     for i in 1:Medium_Fuel.nX loop
       n_flow_cat_channel[1,i] =cat_in_port_submodel.m_flow/n_stacks*cat_in_port_submodel.Xi_outflow[i]/Medium_Fuel.MMX[i];
    end for;

     n_fractions_cat[1,:] =
    Medium_Fuel.massToMoleFractions(
     state_cat[1].X, Medium_Fuel.MMX);
     n_flow_cat_total[1] = sum(n_flow_cat_channel[1,:]);

    /// PROPAGATION
      // anode propagation

    for j in 2:N loop
      for k in 1:Medium_Air.nX loop
        if k == Pos_O2 then
          n_flow_an_channel[j,k] = n_flow_an_channel[j-1,k] + n_cells*I_dens[j-1]*data.SOEC_area/N/(4*Cst.F); //effect of current, production of oxygen
        else
          n_flow_an_channel[j,k] = n_flow_an_channel[j-1,k]; //the rest of components are not affected
        end if;
      end for;

      n_flow_an_total[j] = sum(n_flow_an_channel[j,:]); //actualisation of the total molar flow

      for k in 1:Medium_Air.nX loop
        n_fractions_an[j,k] = n_flow_an_channel[j,k]/n_flow_an_total[j]; // actualisation of molar fractions
      end for;
      state_an[j].X =Medium_Air.moleToMassFractions(n_fractions_an[j,:],Medium_Air.MMX); // mass fractions computed from molar fractions
    end for;

      //cathode propagation
      for j in 2:N loop
        for k in 1:Medium_Fuel.nX loop
          if k == Pos_H2O then
            n_flow_cat_channel[j,k] = n_flow_cat_channel[j-1,k] - n_cells*I_dens[j-1]*data.SOEC_area/N/(2*Cst.F); //effect of current, consumption of water
          elseif k == Pos_H2 then
            n_flow_cat_channel[j,k] = n_flow_cat_channel[j-1,k] + n_cells*I_dens[j-1]*data.SOEC_area/N/(2*Cst.F); // production of hydrogen
          else
            n_flow_cat_channel[j,k] = n_flow_cat_channel[j-1,k];
          end if;
        end for;

        n_flow_cat_total[j] = sum(n_flow_cat_channel[j,:]); // same calculation process with the cathode

        for k in 1:Medium_Fuel.nX loop
          n_fractions_cat[j,k] = n_flow_cat_channel[j,k]/n_flow_cat_total[j];
        end for;

        state_cat[j].X =Medium_Fuel.moleToMassFractions(n_fractions_cat[j,:],Medium_Fuel.MMX);
      end for;

   /// MOLAR FRACTIONS AT THE TRIPLE PHASE BOUNDARIES

   for j in 1:N loop
     DeffH2k[j] = data.deffH2k * T_nodes[j]^0.5;
     DeffH2H2O[j] = data.deffH2H2O * T_nodes[j]^1.75 / (p_cat[j]/1e5);
     DeffH2Ok[j] = data.deffH2Ok*T_nodes[j]^0.5;
     DeffO2k[j] = data.deffO2k * T_nodes[j]^0.5;
     DeffO2[j] = 1/(1/(data.deffO2N2*(T_nodes[j]^1.75/(p_an[j]/1e5))) + 1/DeffO2k[j]);
   end for;

   for j in 1:N loop
     k2[j]=Cst.R*T_nodes[j]/(p_cat[j])*(1/DeffH2k[j]  + 1/DeffH2H2O[j])*I_dens[j]/(2*Cst.F);
     k4[j]=Cst.R*T_nodes[j]/(p_an[j])*(1/DeffH2Ok[j]  + 1/DeffH2H2O[j])*(-I_dens[j])/(2*Cst.F);

     //using DGM we can extrapolate the concentration values of the triple phase boundaries fron the gas channel concentrations
      x_H2_TPBc[j] = n_fractions_cat[j,Pos_H2] +  k2[j]*data.epc;
      x_H2O_TPBc[j] = n_fractions_cat[j,Pos_H2O] + k4[j]*data.epc;
      x_O2_TPBa[j] = 1 + (n_fractions_an[j,Pos_O2] - 1) * exp(-(Cst.R*T_nodes[j]*I_dens[j]*data.epa/(4*Cst.F*DeffO2[j]*p_an[j])));

   end for;

for j in 1:N-1 loop
  state_an[j].p = state_an[j+1].p;
  state_cat[j].p = state_cat[j+1].p;
end for;

for j in 1:N loop
  p_an[j] = state_an[j].p;
  p_cat[j] = state_cat[j].p;
end for;
//thermic model

for j in 2:N loop
state_an[j].T = T_nodes[j];
state_cat[j].T = T_nodes[j];
end for;

  annotation (Documentation(info="<html>
<p>Fluid management submodel </p>
<p>In/Out : </p>
<p>cat_in_port_submodel, ca_out_port_submodel, an_in_port_submodel, an_out_port_submodel</p>
<p>nominal : Nominal values depends strongly on the cell characteristics described in the Data record. </p>
<p><br>parameters : </p>
<p>data record</p>
<p><br><br>description : </p><p><br><br>This sub model describe the transport of fluid along the gas channel as well as the variation in molar fractions coming from the current density. It represent a co-flow type of transport, which means gas in the anode and cathode channels (air and H2-H2O mix) travels in parallel and in the same direction. The model is One dimensional.</p>
<p>The model receive fluid informations from two ports (an_in_port_submodel and cat_in_port_submodel). it then translate the informations (mass flow rates, massic fractions...) into molar values (molar flow rates, molar fractions).</p>
<p>Then using informations from the other submodels we are able to compute nodes by nodes the value of molar fractions of the different components. We use media basic properties to regroup all relevant informations inside the same type.</p>
<p>the molar values are then converted back into massic values and provided to the out ports. all the submodel ports are linked to the min model parts so that these informations are provided to the outside. </p>
<p>The assumption is that the fluidic characteristic time (typical time of change for mass flow rate, mass fractions etc) is in the range of the minute, so that the fluid provision is near stationary. </p>
<p><br><br>No second order influence from the concentration of N2 is modelled. </p>
<p>We use position of elements inside the media so that media model can be modified without too much damage on the equations.</p>
</html>"));
end coFlow;
