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

#ifndef WEINBERG_ANGLE_POINTER_H
#define WEINBERG_ANGLE_POINTER_H

#include "models/CMSSM/CMSSM_two_scale_model.hpp"

namespace flexiblesusy {

namespace weinberg_angle {

/**
 * @class Weinberg_angle_pointer
 * @brief Class to calculate the DR-bar weak mixing angle from pointer to a model
 */
class Weinberg_angle_pointer {
public:
   /**
    * @class Sm_parameters
    * @brief SM parameters necessary for calculating the weak mixing angle
    * -> are extracted from a QedQcd object
    */
   struct Sm_parameters {
      Sm_parameters();
      double fermi_constant; ///< Fermi constant
      double mw_pole;        ///< W pole mass
      double mz_pole;        ///< Z pole mass
      double mt_pole;        ///< top quark pole mass
   };

   Weinberg_angle_pointer(const CMSSM<Two_scale>*, const Sm_parameters&);
   ~Weinberg_angle_pointer();

   void set_number_of_iterations(unsigned);         ///< maximum number of iterations
   void set_number_of_loops(unsigned);              ///< set number of loops
   void set_precision_goal(double);                 ///< set precision goal
   void set_model_pointer(const CMSSM<Two_scale>*); ///< set pointer to investigated model
   void set_sm_parameters(const Sm_parameters&);    ///< set sm_parameters member variable

   /// calculates and returns the sinus of the Weinberg angle
   double calculate(double rho_start = 1.0, double sin_start = 0.48);

private:
   unsigned number_of_iterations; ///< maximum number of iterations
   unsigned number_of_loops;      ///< number of loops
   double precision_goal;         ///< precision goal
   const CMSSM<Two_scale>* model; ///< pointer to investigated model
   Sm_parameters sm_parameters;   ///< SM parameters

   double calculate_delta_rho(double, double);
   double calculate_delta_r(double, double);
   double calculate_delta_vb(double, double);
   double calculate_delta_vb_sm(double, double);
   double calculate_delta_vb_susy(double);
   static double rho_2(double);

   double calculate_self_energy_z_top(double, double);
   double calculate_self_energy_w_top(double, double);
};

} // namespace weinberg_angle

} // namespace flexiblesusy

#endif
