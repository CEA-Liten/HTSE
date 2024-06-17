within HTSE.Utilities;
package UtilitiesFunction
    extends HTSE.Icons.BasePackage;

  function SubstancePosition
    "return position of substance in X or C array, -1 if not present"

  input String Name;
  input Integer nS;
  input String[nS] NameMatrix;
  output Integer pos;
  protected
    Boolean found;
    Integer i;
    Boolean Test;
  algorithm
    Test:=false;
    pos:=0;
    found:=false;
    i:=1;
    while (found==false and i<=nS) loop
      found:=Modelica.Utilities.Strings.isEqual(Name,NameMatrix[i]);
      if (found) then
        pos:=i;
        Test:=true;
      else
        i:=i+1;
      end if;
    end while;
    if Test==false then
        pos:=0;
    end if;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<p>return the index for the given name inside the media.</p>
</html>"));
  end SubstancePosition;
end UtilitiesFunction;
