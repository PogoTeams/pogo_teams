/*
A simple pair class for binding two types together.The current use case
for this is to implicitly sort the Pokemon types by calculated effectiveness
values.
*/
class Pair<TypeA, TypeB> {
  Pair({required this.a, required this.b});

  TypeA a;
  TypeB b;
}
