// ====================================================================
// This file is part of FlexibleSUSY.
//
// FlexibleSUSY is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License,
// or (at your option) any later version.
//
// FlexibleSUSY is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with FlexibleSUSY.  If not, see
// <http://www.gnu.org/licenses/>.
// ====================================================================

#include "ckm.hpp"
#include "ew_input.hpp"
#include "wrappers.hpp"

namespace flexiblesusy {

CKM_parameters::CKM_parameters()
{
   reset();
}

void CKM_parameters::reset()
{
   theta_12 = Electroweak_constants::CKM_THETA12;
   theta_13 = Electroweak_constants::CKM_THETA13;
   theta_23 = Electroweak_constants::CKM_THETA23;
   delta    = Electroweak_constants::CKM_DELTA;
}

/**
 * Calculates V_CKM angles from Wolfenstein parameters (see
 * hep-ph/0406184)
 */
void CKM_parameters::set_from_wolfenstein(double lambdaW, double aCkm,
                                          double rhobar, double etabar)
{
   theta_12 = ArcSin(lambdaW);
   theta_23 = ArcSin(aCkm * Sqr(lambdaW));

   const double lambdaW3 = Power(lambdaW, 3);
   const double lambdaW4 = Power(lambdaW, 4);

   const std::complex<double> rpe(rhobar, etabar);
   const std::complex<double> V13conj = aCkm * lambdaW3 * rpe
      * Sqrt(1.0 - Sqr(aCkm) * lambdaW4) /
      Sqrt(1.0 - Sqr(lambdaW)) / (1.0 - Sqr(aCkm) * lambdaW4 * rpe);

   if (std::isfinite(Re(V13conj)) && std::isfinite(Im(V13conj))) {
      theta_13 = ArcSin(Abs(V13conj));
      delta = Arg(V13conj);
   }
}

/**
 * Calculates Wolfenstein parameters from V_CKM angles (see
 * hep-ph/0406184)
 */
void CKM_parameters::get_wolfenstein(double& lambdaW, double& aCkm,
                                     double& rhobar, double& etabar)
{
   const double sin_12 = Sin(theta_12);
   const double sin_13 = Sin(theta_13);
   const double sin_23 = Sin(theta_23);

   // Eq. (11.4) from PDG
   lambdaW  = sin_12;
   aCkm     = sin_23 / Sqr(lambdaW);

   if (!std::isfinite(aCkm))
      aCkm = 0.;

   const double c = Sqrt((1.0 - Sqr(sin_23)) / (1.0 - Sqr(lambdaW)));
   const std::complex<double> eid(std::polar(1.0, delta));
   const std::complex<double> r(sin_13 * eid /
      (c * aCkm * Power(lambdaW,3) + sin_13 * eid * Sqr(sin_23)));


   rhobar = std::isfinite(Re(r)) ? Re(r) : 0.;
   etabar = std::isfinite(Im(r)) ? Im(r) : 0.;
}

Eigen::Matrix<double,3,3> CKM_parameters::get_real_ckm() const
{
   const std::complex<double> eID(std::polar(1.0, delta));
   const double s12 = Sin(theta_12);
   const double s13 = Sin(theta_13);
   const double s23 = Sin(theta_23);
   const double c12 = Cos(theta_12);
   const double c13 = Cos(theta_13);
   const double c23 = Cos(theta_23);

   // set phase factor e^(i delta) to +1 or -1 depending on the sign
   // of s13
   const int pf = Sign(s13);

   Eigen::Matrix<double,3,3> ckm_matrix;
   ckm_matrix(0, 0) = c12 * c13;
   ckm_matrix(0, 1) = s12 * c13;
   ckm_matrix(0, 2) = pf * s13;
   ckm_matrix(1, 0) = -s12 * c23 - pf * c12 * s23 * s13;
   ckm_matrix(1, 1) = c12 * c23 - pf * s12 * s23 * s13;
   ckm_matrix(1, 2) = s23 * c13;
   ckm_matrix(2, 0) = s12 * s23 - pf * c12 * c23 * s13;
   ckm_matrix(2, 1) = -c12 * s23 - pf * s12 * c23 * s13;
   ckm_matrix(2, 2) = c23 * c13;

   return ckm_matrix;
}

Eigen::Matrix<std::complex<double>,3,3> CKM_parameters::get_complex_ckm() const
{
   const std::complex<double> eID(std::polar(1.0, delta));
   const double s12 = Sin(theta_12);
   const double s13 = Sin(theta_13);
   const double s23 = Sin(theta_23);
   const double c12 = Cos(theta_12);
   const double c13 = Cos(theta_13);
   const double c23 = Cos(theta_23);

   Eigen::Matrix<std::complex<double>,3,3> ckm_matrix;
   ckm_matrix(0, 0) = c12 * c13;
   ckm_matrix(0, 1) = s12 * c13;
   ckm_matrix(0, 2) = s13 / eID;
   ckm_matrix(1, 0) = -s12 * c23 - c12 * s23 * s13 * eID;
   ckm_matrix(1, 1) = c12 * c23 - s12 * s23 * s13 * eID;
   ckm_matrix(1, 2) = s23 * c13;
   ckm_matrix(2, 0) = s12 * s23 - c12 * c23 * s13 * eID;
   ckm_matrix(2, 1) = -c12 * s23 - s12 * c23 * s13 * eID;
   ckm_matrix(2, 2) = c23 * c13;

   return ckm_matrix;
}

} // namespace flexiblesusy
