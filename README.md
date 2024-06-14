# CEA HTSE model for the tandem library


This is the development site for the HTSE CEA open source model and its user guide.

## Code description

This MODELICA High Temperature Steam Electrolysis model (HTSE) is a free open-source code used inside the TANDEM library. This library contains models for a small modular nuclear reactor and the industrial environment around it (heat network, h2 production, electrical grid etc.)

1.	HIGH TEMPERATURE STEAM ELECTROLYSIS (HTSE)
1.1	Component description 
High temperature steam electrolysis is an archetype of electrolysis, using an auxiliary heat source to decrease the electrical power required to convert water into hydrogen. It is the most electrically efficient type of electrolyser, but it requires a constant and high heat flow rate. This makes it a good candidate to pair with an SMR since nuclear reactors are producers of electricity and heat. The HTSE component produces H2 in a Solid Oxide Electrolyser Cell, operating at high temperature (about 750 °C). To do so, the steam is produced and pre-heated by using thermal power coming from the external source, i.e. a SMR plant. 
 
1.2	Hypotheses 
1.2.1	Stack  
The stack model assumptions can be divided in two parts, the conversion assumptions which are linked to how much hydrogen is produced given an electrical and thermodynamic state, and the encapsulation assumptions, which dictates how the model behaves given steam mass flow rate: 
1.2.2	The conversion assumptions : the model for the conversion of hydrogen is described in the scientific publication : J. Laurencin et al. Modelling of solid oxide steam electrolyser: Impact of the operating conditions on hydrogen production, Journal of Power Sources, Volume 196, Issue 4, 2011. The overall assumptions are:  

•	Every cells in every stack are strictly identical. 
•	The description of the cell is one dimensional. We consider that all the channels providing gas to the cells are identical. We make no difference between the edge and the centre of the cell (where in reality some differences would appear especially thermally). 
•	The temperature of the cell is maintained uniformly throughout the cell and is regulated by a PID controller to follow to the thermoneutral voltage (ensuring the most efficient hydrogen conversion since no heat is produced or consumed by the electrochemical reaction). We could summarize by saying the stack is perfectly controlled in temperature. 
•	The flow of gas is co-linear, the gases flow from the cathode and anode are parallel and in the same direction. Only this model is provided but other type of flow can be implemented in the structure. 
•	The cells data comes from the paper from J. Laurencin cited above. They can be easily replaced by the user’s specific cells characteristics using the same format.
•	The current is always computed to convert 70% of the steam provided in the steam entry connector. This steam conversion is quite standard for a standard working High Temperature Steam Electrolyser. A delay of 60s is introduced for the current to synchronise with the mass flow rate. (A valid hypothesis compared to reality, also allows for Dymola to simulate since both the current and the steam are not "provided" at the same time). 

1.2.3	The encapsulation assumptions:   How the components close to the stack are controlled and what hypotheses did we consider around them. 

•	A mass flow of pure hydrogen transiting through the stack is provided in case no fuel is coming from the BOP. No current is used to convert steam into hydrogen while the mass flow rate remains less then 10% of the nominal one. 
•	The anode gas is air, the mass flow rate is roughly two times the Fuel mass flow rate, as is often seen in the literature. 
•	Electrical power is computed as the product of the current and voltage provided to the overall stack. A conversion efficiency of 0.9 is considered from the grid current. 
•	The pressure losses are linear and depend on the mass flow rate of gas. We consider half of the overall pressure loss is imposed at the entrance and half is imposed at the exit of the cell. 
•	The media used is a perfect mixture of hydrogen, steam and nitrogen.

 
 
 
1.2.4	The stack model 
The following is the description of the stack model as detailed in the MODELICA code documentation.

Stack’s Ins and Outs
cat_in_port, cat_out_port, an_in_port, an_out_port, p, n 
Parameters : 
n_cells : number of cells per stack 
n_stack : total number of stacks 

Description : 
This model allows for simulating the electrochemical, thermal, and fluidic behaviour of a Solid Oxide Electrolysis Cell (SOEC), composed of a stack of elementary cells connected in series current wise and in parallel fluid wise, subjected to a current source and supplied by two circuits: the air side at the anode, and a mixture of H2O/H2 called the fuel side at the cathode. 

The model is interfaced with 4 fluid ports (in anode, out anode, in cathode, out cathode) and 2 electrical pins (p and n) to provide electrical power to the electrolyser. Both current or voltage source can be used.
The model is discretized along the gas channel to better represent the current density repartition inside the cell. The model aggregates various sub-models and components that communicate with each other through outer variables : 

•	The fluidic model: transport equations and link to the fluid ports. The sub model is mostly composed of equations that describes either a co-flow/counter-flow/crossflow type of fluid movement and the interactions between molar fractions of gas components and current density. The electrolyte crossing of gas components is handled here. 
•	The electro chemical model: equations between current density, molar fractions and voltages. The main outputs are the cell voltage and the current density repartition along the 1D/2D cell. 
•	The thermic model: computes the temperatures along the electrolyser cell.  
•	The pressure mode: computes the pressure drop along the cell for various fluid movements.  
•	A data record: Provides material/cell information and other parameters separating the cell characteristics from the rest of the Model. 
 The sub models are described in their own description sections in the MODELICA codes. The choices made for the TANDEM library are :  
 
•	To keep the electro chemical model physical with equations from the literature.  
•	To have a co-flow fluid movement which means that gases in the anode and cathode channel flows in parallel and in the same direction. It is the simplest way to transport gases in the cell. 
•	The temperature of the cell is computed to maintain the cell voltage to follow thermoneutral voltage using a basic PID.  
•	Pressure losses are linear and averaged in the cell. 



The main project site is https://gitlab.pam-retd.fr/tandem/tandem

## Current release

First version, used for the tandem library with small later improvements.

## License

The license chosen for this model is a modified BSD 3-clause adapted to the type of code structure found in Modelica. 

## Development and contribution

At the moment, contribution cannot be handled by our teams. However, feel free to reach out if you feel like we can cooperate on improving the model. 
