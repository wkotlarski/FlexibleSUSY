
#ifndef TWO_SCALE_MATCHING_H
#define TWO_SCALE_MATCHING_H

class DoubleVector;
class Two_scale;

template<>
class Matching<Two_scale> {
public:
   virtual DoubleVector calcHighFromLowScaleParameters(const DoubleVector&) const = 0;
   virtual DoubleVector calcLowFromHighScaleParameters(const DoubleVector&) const = 0;
};

typedef Matching<Two_scale> Two_scale_matching;

#endif
