module Virial exposing (str)

str n =
    head ++ "\n\n" ++ String.repeat n (body ++ "\n\n")


head =
    """
| title number-to-level:3
Virial Theorem

[tags jxxcarlson:physics-notebook-virial-theorem]

| banner
[ilink Physics Notebook id-133c6b4e-8306-4c9c-9a73-413b50af4053]


| mathmacros
# bp: {\\mathop{\\mathbf{p}}}
bp: {\\mathop{\\mathbf{p}}}
bq: {\\mathop{\\mathbf{q}}}
br: {\\mathop{\\mathbf{r}}}
bu: {\\mathop{\\mathbf{u}}}
bF: {\\mathop{\\mathbf{F}}}
ta: \\left< #1 \\right>
"""

body =
    """
# Introduction

We are going to discuss the  virial theorem, a result
which  relates the average kinetic energy $ta(K)$ to the average
potential energy $ta(U)$ of a system of particles bound
together by the force of gravity.  By  "bounded", we mean that the system is neither expanding nor contracting. It is in a dynamic equilibrium where the constituent particles are moving
while the system as a whole maintains a kind of structural stability, e.g., it neither collapses nor expands and dissipates.
By "time average," we mean the integral over time on a certain
interval:

| equation
ta(Q) = int_a^b Q(t) dt

The virial theorem has a wide variety of applications.  We give just
two examples: computing the core temperature of the sun and computing the
mass of the Coma cluster of galaxies.  In the first case the particles
are fully ionized atoms of hydrogen and helium.  In the second case
they are galaxies.

# Derivation

To explain the theorem, consider first the [term moment of inertia] of the syste

| equation label:moment-of-inertia
I = sum_i m_i br_i^2

Up to a constant, its derivative is

| equation label:moment-of-inertia-deriv
frac(1,2) dot I =  sum_i m_i br_i cdot dot br_i =
 sum_i br_i cdot bp_i

where $br_i cdot bp_i$ is $|br_i|$ times the radial
component of the momentum.  The quantity $\\dot I$ is
therefore a kind of radially weighted average of the
radial components of the momenta of the particles.
This quantity is also a function of the time $t$.
Thus, if $dot I (t) > 0$, the system is expanding,
whereas if $dot I(t) < 0$, it is contracting. If $I(t) = 0$, the system is [u stable] at time $t$.

Now consider the second derivative of the moment of inertia:

| aligned
frac(1,2) ddot I &=  sum_i m_i dot br_i cdot dot br_i +  sum_i m_i br_i cdot ddot br_i  \\
  &= 2sum_i K_i +  sum_i br_i cdot bF_i
  &= 2K -  sum_i br_i cdot GMm_i frac(br_i, |br_i|^3) \\
  &= 2K -  sum_i  frac(GMm_i, |br_i|) \\
  &= 2K + U


where we have applied Newton's law of graviation and where $U$ is the gravaitational potential energy. Taking time averages, we have

| equation
ta(K) + 2ta(U) = dot I(b) - dot I(a)

Thus, for a stable system,

| equation
2ta(K) + ta(U) = 0

# Applications

## Mass of Galactic Clusters

Let $\\sigma$ be the velocity dispersion in a cluster of galaxies,
and let $M$ be its mass.  Then the average kinetic energy is

|| equation
\\left< K \\right> = frac(M\\sigma^2, 2)

We claim that the average potential energy is

|| equation
\\left< U \\right> approx - frac(GM^2,R)

where $R$ is the radius of the cluster.
Using the virial theorem, we find that the mass of the cluster is

|| equation
M approx frac(R\\sigma^2, G)


Typical values of $\\sigma$ are $500-1500 " km/sec"$.  This
implies

|| equation
M_{\\text{cluster}} \\sim 10^{14}-10^{15} M_\\odot.

A cluster typically contains 100 to 1000 galaxies, so the luminosity of the cluster is

|| equation
L_\\text{cluster} \\sim 10^{12} L_\\odot

Thus the mass-to-luminosity ratio of a cluster is about 200 to 500 times same ratio for the sun.  [u Conclusion:] lots of dark matter!

## The Potential Energy Term

The exact potential energy for a system of particle is

| equation
U = - sum frac(Gm_im_j,r_{ij})

In the double summation we replace $r_{ij}$ by $R$


For a large cluster of mass $M$, one approximates this by
the typical separation scale $R$ and $m_im_j$ by $m^2$ where
$m$ is the average galactic mass.  Let $n$ be the
number of galaxies.  Then sum is approximately
equal to $(nm)^2 =  M^2$. Up to a scale factor $alpha$, we have

| equation
U approx -alpha frac(GM^2,R)

For a uniform mass distribution, $alpha = 3/5$.  For a more
centrally concentrated mass distribution, $alpha$ is closer to 1.

## Temperature at the Core of the Sun

The internal energy of the sun viewed as a monoatomic gas is

| equation
ta(K) = frac(3,2) NkT

where $N$ is the number of atoms and $k$ is Boltzmann's constant.
The Gravitational binding energy is

| equation
ta(U) = -alpha frac(GM^2,R)

Apply the virial theorem $ta(K) = -ta(U)/2$ to obtain

| equation
frac(3,2) NkT = frac(1,2) frac(GM^2,R)

Solve for the temperature:

| equation
T = frac(alpha GM^2, 3NkR)

To find the number $N$, let  $mu = 0.6$ be the mean molecular weight (hydrogen-helium mix).
Let $m_P$ be the mass of a proton.  Then the number of atoms in the sun
is

| equation
N = frac(M, mu m_P)

and so finally

| equation
T = frac(alpha GM mu m_p, 3kR)

Now plug in the needed constants

| aligned
G &= 6.67 times 10^{-11} " SI units" \\
M_odot &= 1.99 times 10^{30} " kg" \\
R_odot &= 6.96 times 10^n " m" \\
m_P &= 1.67 times 10^{-27} " kg" \\
k &= 1.38 times 10^{-23} " J/K" \\
alpha &approx 3/5 " (uniform sphere)"

to get

| equation
T approx 2.8 times 10^6 " K"

Very hot!  Enough to have sustained a nuclear fusion reaction
for the last four billion years.

# Appendix

## Potential Energy




# References

[link Wkipedia reference https://en.wikipedia.org/wiki/Virial_mass]

[link Caltech Slides https://sites.astro.caltech.edu/~george/ay127/Ay127_GalClusters.pdf] << [red good!]

[link UMD slides https://www.astro.umd.edu/~richard/ASTR480/Clusters_lecture2.pdf]

[link Physics Libre Reference https://phys.libretexts.org/Bookshelves/Astronomy__Cosmology/Supplemental_Modules_(Astronomy_and_Cosmology)/Cosmology/Astrophysics_(Richmond)/18%3A_Using_the_Virial_Theorem_-_Mass_of_a_Cluster_of_Galaxies#:~:text=The%20right%2Dhand%20side%20depends,of%20bodies%20in%20the%20system.]"""
