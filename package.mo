package CEA_Energy_Process_library "CEA library focused on energy process"
   extends CEA_Energy_Process_library.Icons.Package;

  annotation (Icon(graphics={Bitmap(extent={{-80,-94},{86,92}}, fileName="modelica://CEA_Energy_Process_library/Images/CEA.png")}),
      uses(Modelica(version="4.0.0"),
    ModelicaServices(version="4.0.0"),
    IBPSA(version="3.0.0"),
      ExternalMedia(version="3.3.3"),
      Testing(version="1.6.1"),
      DymolaModels(version="1.6.0")),
    version="2",
    conversion(noneFromVersion="1"));
end CEA_Energy_Process_library;
