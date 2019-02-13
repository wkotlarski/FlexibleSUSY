(* :Copyright:

   ====================================================================
   This file is part of FlexibleSUSY.

   FlexibleSUSY is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published
   by the Free Software Foundation, either version 3 of the License,
   or (at your option) any later version.

   FlexibleSUSY is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with FlexibleSUSY.  If not, see
   <http://www.gnu.org/licenses/>.
   ====================================================================

*)

BeginPackage["WilsonCoeffs`",{"Utils`"}];

MatchingConditions::usage="Extracts the coefficients for a given basis and amplitude from NPointFunctions.";
FindFermionChains::usage="Searches the FermionChains in the abbreviations rules";
RemoveFermionChains::usage="Removes FermionChains from the abbreviations rules.";

Begin["`Private`"];

ExtractCoeffs[genericSum_, operator_List] :=
   ReplacePart[
     genericSum, {1} -> (Coefficient[genericSum[[1]], #]& /@ operator)
   ]

FindFermionChains[npointExpression_List, chiralBasis_List] :=
  Module[{basisPos, rulePos},
    Utils`AssertWithMessage[
      And @@ (MemberQ[npointExpression, #, 2]& /@ chiralBasis[[All, 2]]),
        "Error: provided basis does not match output of FormCalc"];
    Utils`AssertWithMessage[And @@ (SameQ[Head[#], Times]& /@ chiralBasis[[All, 2]]),
      "FindFermionChains only works with 4 external fermions for now."];

    basisPos = Flatten[Position[npointExpression, #]& /@ chiralBasis[[All, 2]], 1];
    basisPos[[All, 2]] = basisPos[[All, 2]] - 1;
    (*TODO: Is FormCalc`Mat always used in Dirac chains?*)
    rulePos = FormCalc`Mat[Extract[npointExpression, #]]& /@ basisPos;

    Transpose[{chiralBasis[[All, 1]], rulePos}]
  ]

RemoveFermionChains[npointExpression_List] :=
  Module[{pos},
    pos = Take[#, 3]& /@ Position[npointExpression, FormCalc`DiracChain];
    Delete[npointExpression, pos]
  ]

MatchingConditions[npointExpression_List, chiralBasis_List] :=
  Module[{Coeffs, mappedNPoint=npointExpression},
    Coeffs = ExtractCoeffs[#, chiralBasis]& /@ npointExpression[[2, 1, 1]];
    mappedNPoint[[2, 1, 1]] = Coeffs;

    mappedNPoint
  ]

End[];
EndPackage[];
