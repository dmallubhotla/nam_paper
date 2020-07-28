# Analysis of Nam's SC work

This includes a Mathematica implementation of Nam's conductivity equation, for the purposes of eventually calculating relaxiation time more accurately for SCs.

This implementation should avoid low wavevector divergences, which is necessary for integrating accurately to find the reflection coefficient.

To install, run `make dist/wl_installed` to install the Mathematica package to the location. The exposed package has a package name of `` "namConductivity`" ``, with a usage function defined with information on usage. See some of the report scripts for more examples on calling the function.