Needs["namConductivity`"];
Needs["namAsymptoticLowKConductivity`"];

(* Defines lindhard functions *)
epsL[qP_?NumericQ, omegaP_?NumericQ, vfP_?NumericQ, omegapP_?NumericQ,
    tauP_?NumericQ] :=
  With[{u = (vfP*qP)/omegaP, s = 1/(tauP*omegaP),
    prefactor = 3*(omegapP^2)/(omegaP^2)},
   1 + ((prefactor)/(u^2))*(1 + ((1 + I*s)/(2*u))*
         Log[(1 - u + I*s)/(1 + u + I*s)])/(1 + ((I*s)/(2*u))*
         Log[(1 - u + I*s)/(1 + u + I*s)])];
epsSeries[qP_?NumericQ, omegaP_?NumericQ, vfP_?NumericQ,
   omegapP_?NumericQ, tauP_?NumericQ] :=
  With[{u = (vfP*qP)/omegaP, s = 1/(tauP*omegaP),
    prefactor = 3*(omegapP^2)/(omegaP^2)},
   1 + ((prefactor)) ((I/(3*(s - I))) +
       u^2*(-9*I + 5*s)/(45*(-I + s)^3))];
epsEf[q_?NumericQ, omega_?NumericQ, vf_?NumericQ, omegap_?NumericQ,
   tau_?NumericQ] :=
  epsEf[q, omega, vf, omegap, tau] =
   Piecewise[{{epsSeries[q, omega, vf, omegap, tau],
      q < .01 * omega / vf}, {epsL[q, omega, vf, omegap, tau],
      q >= .01 * omega / vf}}];

(* Nam stuff *)
makeDimensionlessParams[\[Omega]_, \[Sigma]n_, \[Tau]_, vf_, T_, Tc_] :=
  With[{\[CapitalDelta] =
     3.06*Sqrt[
       Tc*(Tc - T)]}, <|\[Xi] -> \[Omega]/\[CapitalDelta], \[Nu] ->
     1/(\[CapitalDelta]*\[Tau]), A -> \[Omega]*vf/(1*\[CapitalDelta]),
     t -> T/\[CapitalDelta], B -> \[Sigma]n/\[Omega],
    C -> vf/\[CapitalDelta]|>];


omega = 1;
tau := .5;
omegaPlasma := 10;
sigmaN := omegaPlasma^2 * tau / (4 * Pi);
vf := 1
tempCritical := 3
temp := .9999 * tempCritical
params := makeDimensionlessParams[omega, sigmaN, tau, vf, temp, tempCritical]
Print[params];

epsNam2[q_, ps_] := With[
	{k = ps[C] * q},
	1 + 4 * Pi * I *
		ps[B] * \[CapitalSigma][ps[\[Xi]], k, ps[\[Nu]], ps[t]]
	];

(* Populates the figures directory as ../figures *)
figuresDirectory = FileNameJoin[{
	ParentDirectory[
		DirectoryName[
			FileNameJoin[{
				Directory[],
				$ScriptCommandLine[[1]]
			}]
		]
	], "figures"
}];

figure[filename_] := FileNameJoin[{figuresDirectory, filename}];

plot1 = LogLinearPlot[ {Re@epsEf[q, omega, vf, omegaPlasma, tau], Re@epsNam2[q, params]} , {q, 0, 10^2}, ImageSize -> Large, AxesLabel -> {"q", StringForm["Re[\[Epsilon](q, \[Omega] = 1)]"]}, PlotRange -> All, PlotLegends -> {Lindhard, Nam}, ImagePadding -> {{50, Automatic}, {Automatic, Automatic}}];

Export[figure["Cond1Re.jpg"], plot1, ImageResolution -> 1200];
