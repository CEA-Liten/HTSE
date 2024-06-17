within HTSE.Media.Predefined.PureSubstance;
package Gas
  extends Icons.VariantPackage;

  annotation (Documentation(info="<html>
<p>D&eacute;veloppeur : Fran&ccedil;ois NEPVEU, Quentin BURBAN, Sylvain MATHONNIERE, Ga&euml;l ENEE</p>
<p>V&eacute;rificateur : </p>
<p>Date : 2022</p>
<h4>La complexit&eacute; de d&eacute;velepper un mod&egrave;le de media peut engendrer des erreurs et coquilles dans le code! En fonction de doutes sur les r&eacute;sultats, il est n&eacute;cerssaire de bien les v&eacute;rifier!</h4>
<p><b><span style=\"font-size: 10pt; color: #008c48;\">R&ocirc;le de l&apos;objet : </span></b></p>
<p>Ce package comprend diff&eacute;rents mod&egrave;les &quot;de base&quot; permettant de mod&eacute;liser un gaz opu une mixture de gaz</p>
<p align=\"center\"><img src=\"modelica://HTSE/Images/Comparaison_modele_gas_2.png\"/></p>
<p><b><span style=\"font-size: 10pt; color: #008c48;\">Interfaces + Composants : </span></b></p>
<p><br><b><span style=\"font-size: 10pt; color: #008c48;\">Fonctions d&apos;am&eacute;lioration des performances :</span></b></p>
<p><b>Le choix du &quot;bon&quot; mod&egrave;le de media est certainement le point le plus important dans la mod&eacute;lisation d&apos;un syt&egrave;me &quot;gaz&quot;. </b>La stabilit&eacute;/ temps de calcul peuvent &ecirc;tre fortement affect&eacute;s d&apos;un mod&egrave;le &agrave; l&apos;autre.</p>
<p><br><b><span style=\"font-size: 10pt; color: #008c48;\">Mod&eacute;lisation : </span></b></p>
<p>Les diff&eacute;rents sont actuellement principalement exploit&eacute;s pour mod&eacute;liser le comportement thermodynamique de l&apos;hydrog&egrave;ne. En effet, &agrave; haute pression, temp&eacute;rature ambiante, le comportement de l&apos;hydrog&egrave;ne s&apos;&eacute;loigne fortement de celui d&apos;un gaz parfait et il est n&eacute;cessaire du&apos;tiliser d&apos;autres mod&egrave;les plus pr&eacute;cis.</p>
<p align=\"center\"><img src=\"modelica://HTSE/Images/Comparaison_modele_gas_3.png\"/></p>
<p align=\"center\"><br><br><br><br><img src=\"modelica://HTSE/Images/Comparaison_modele_gas.png\"/></p>
<p><br><br><b><span style=\"font-size: 10pt; color: #008c48;\">Limitations : </span></b></p>
<p>Les mod&egrave;les n&apos;est fonctionnel que pour un gaz. </p>
<p><b><span style=\"font-size: 10pt; color: #008c48;\">Tips : </span></b></p>
<p>NOM - Date : Blablabla...</p>
<p><b><span style=\"font-size: 10pt; color: #008c48;\">R&eacute;f&eacute;rence : </span></b></p>
</html>"));
end Gas;
