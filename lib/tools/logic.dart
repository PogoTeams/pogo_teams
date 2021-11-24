/*
-------------------------------------------------------------------------------
Logic based functions that compare values.
-------------------------------------------------------------------------------
*/

// Get the max value among the 3 provided values
double max(double v1, double v2, double v3) {
  if (v1 > v2) {
    if (v1 > v3) return v1;
    return v3;
  }

  if (v2 > v3) return v2;
  return v3;
}

// Normalize val given a min and max
double normalize(double val, double min, double max) {
  if (val < min) return min;
  if (val > max) return max;
  return (val - min) / (max - min);
}
