/*
-------------------------------------------------------------------- @PogoTeams
Logic based functions that compare values.
-------------------------------------------------------------------------------
*/

// Normalize val given a min and max
double normalize(double val, double min, double max) {
  if (val < min) return min;
  if (val > max) return max;
  return (val - min) / (max - min);
}
