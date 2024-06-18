within HTSE.Electrolysers;
model test_uni
  HTSE.Electrolysers.SOEC.models.electrolyzer_module electrolyzer_module annotation (Placement(transformation(extent={{-30,-28},{26,28}})));
  HTSE.GeneralCircuitry.Source.Source_m_flow_T source_m_flow_T(
    redeclare package Medium = HTSE.Media.Predefined.Mixture.Gas.IdealGasMixture_H2O_H2_N2,
    m_flow=1,
    X={0.98,0.02,0},
    use_m_flow_in=true,
    use_T_in=false,
    use_C_in=false,
    use_X_in=false) annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
  HTSE.GeneralCircuitry.Source.Source_pT source_pT(
    redeclare package Medium = HTSE.Media.Predefined.Mixture.Gas.IdealGasMixture_H2O_H2_N2,
    use_p_in=false,
    use_T_in=false,
    use_C_in=false,
    use_X_in=false) annotation (Placement(transformation(extent={{72,-10},{52,10}})));
  Modelica.Blocks.Sources.Step step(
    height=1,
    offset=0,
    startTime=1000) annotation (Placement(transformation(extent={{-180,8},{-160,28}})));
equation
  connect(source_m_flow_T.port[1], electrolyzer_module.Fuel_In) annotation (Line(points={{-75.8,0},{-30,0}}, color={0,127,255}));
  connect(source_pT.port[1], electrolyzer_module.Fuel_Out) annotation (Line(points={{51.8,0},{26,0}}, color={0,127,255}));
  connect(step.y, source_m_flow_T.m_flow_in) annotation (Line(points={{-159,18},{-102,18},{-102,6},{-96,6}}, color={0,0,127}));
end test_uni;
