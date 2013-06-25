
BeginPackage["EWSB`", {"SARAH`", "TextFormatting`", "CConversion`", "Parameters`"}];

CheckEWSBEquations::usage="";

CreateEWSBEqPrototype::usage="creates C function prototype for a
given EWSB equation";

CreateEWSBEqFunction::usage="creates C function definition for a
given EWSB equation";

FillArrayWithEWSBEqs::usage="fills array of doubles with the values
of the EWSB equations";

FillInitialGuessArray::usage="fills a C array with initial values for the
EWSB eqs. solver";

Begin["Private`"];

freePhases = {};

AppearsInEquationOnlyAs[parameter_, equation_, function_] :=
    FreeQ[equation /. function[parameter] :> Unique[ToValidCSymbolString[parameter]], parameter];

AppearsOnlySquaredInEquation[parameter_, equation_] :=
    AppearsInEquationOnlyAs[parameter, equation, Power[#,2]&];

AppearsOnlyAbsSquaredInEquation[parameter_, equation_] :=
    AppearsInEquationOnlyAs[parameter, equation, (Susyno`LieGroups`conj[#] #)&] ||
    AppearsInEquationOnlyAs[parameter, equation, (# Susyno`LieGroups`conj[#])&];

AppearsNotInEquation[parameter_, equation_] :=
    FreeQ[equation, parameter];

CheckInEquations[parameter_, statement_, equations_List] :=
    And @@ (statement[parameter,#]& /@ equations);

CheckEWSBEquations[ewsbEqs_List, outputParameters_List] :=
    Module[{i, par, uniquePar, uniqueEqs, rules, newPhases = {}},
           For[i = 1, i <= Length[outputParameters], i++,
               par = outputParameters[[i]];
               uniquePar = Unique[CConversion`ToValidCSymbol[par]];
               rules = Join[{ par -> uniquePar},
                            Rule[#,Unique[CConversion`ToValidCSymbol[#]]]& /@ Select[outputParameters, (# =!= par)&]
                           ];
               uniqueEqs = ewsbEqs /. rules;
               If[CheckInEquations[uniquePar, AppearsNotInEquation, uniqueEqs],
                  Print["Error: ", par, " does not appear in EWSB equations!"];
                  Continue[];
                 ];
               If[Parameters`IsRealParameter[par],
                  If[CheckInEquations[uniquePar, AppearsOnlySquaredInEquation, uniqueEqs],
                     Print["   Note: ", par, " appears only squared in EWSB equations."];
                     AppendTo[newPhases, FlexibleSUSY`Sign[par]];
                    ];
                  ,
                  If[CheckInEquations[uniquePar, AppearsOnlyAbsSquaredInEquation, uniqueEqs],
                     Print["   Note: ", par, " appears only absolute squared in EWSB equations."];
                     AppendTo[newPhases, FlexibleSUSY`Phase[par]];
                     ,
                     Print["   Note: ", par, " is complex and appears in EWSB equations."];
                     AppendTo[newPhases, FlexibleSUSY`Phase[par]];
                    ];
                 ];
              ];
           Print["   Introducing new free parameters: ", newPhases];
           freePhases = newPhases;
           Return[newPhases];
          ];

CreateEWSBEqPrototype[vev_Symbol] :=
    Module[{result = ""},
           result = "double get_ewsb_eq_" <> ToValidCSymbolString[vev] <>
                    "() const;\n";
           Return[result];
          ];

CreateEWSBEqFunction[vev_Symbol, equation_] :=
    Module[{result = "", body = "", variableName = ""},
           variableName = "ewsb_eq_" <> ToValidCSymbolString[vev];
           result = "double CLASSNAME::get_" <> variableName <>
                    "() const\n{\n";
           body = "double " <> variableName <> " = " <>
                  RValueToCFormString[equation] <> ";\n";
           body = body <> "\nreturn " <> variableName <> ";\n";
           body = IndentText[WrapLines[body]];
           Return[result <> body <> "}\n\n"];
          ];

FillArrayWithEWSBEqs[tadpoleEquations_List, parametersFixedByEWSB_List,
                      gslIntputVector_String:"x", gslOutputVector_String:"tadpole"] :=
    Module[{i, result = "", vev},
           If[Length[tadpoleEquations] =!= Length[parametersFixedByEWSB],
              Print["Error: number of EWSB equations (",Length[tadpoleEquations],
                    ") is not equal to the number of fixed parameters (",
                    Length[parametersFixedByEWSB],")"];
              Return[""];
             ];
           For[i = 1, i <= Length[parametersFixedByEWSB], i++,
               result = result <> "model->set_" <>
                        ToValidCSymbolString[parametersFixedByEWSB[[i]]] <>
                        "(gsl_vector_get(" <> gslIntputVector <> ", " <>
                        ToString[i-1] <> "));\n";
              ];
           result = result <> "\n";
           For[i = 1, i <= Length[tadpoleEquations], i++,
               vev = tadpoleEquations[[i,1]];
               result = result <> gslOutputVector <> "[" <> ToString[i-1] <>
                        "] = " <> "model->get_ewsb_eq_" <>
                        ToValidCSymbolString[vev] <> "();\n";
              ];
           Return[result];
          ];

FillInitialGuessArray[parametersFixedByEWSB_List, arrayName_String:"x_init"] :=
    Module[{i, result = ""},
           For[i = 1, i <= Length[parametersFixedByEWSB], i++,
               result = result <> arrayName <> "[" <> ToString[i-1] <> "] = " <>
                        ToValidCSymbolString[parametersFixedByEWSB[[i]]] <>
                        ";\n";
              ];
           Return[result];
          ];

End[];

EndPackage[];
