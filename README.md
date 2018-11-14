# programs_in_Eiffel
Some code in _Eiffel_ using _Design by Contract_ mechanisms

_Eiffel is an object-oriented programming language, that has 'Design by contract' tightly integrated with other language constructs. Eiffel allows explicitly defining the program to 'require' certain states as preconditions, 'ensure' postcondition states, and 'invariants' for every procedure, thereby imposing tight bounds in the states the program can reach._

About Eiffel: https://en.wikipedia.org/wiki/Eiffel_(programming_language)

## 1. Matrix Inversion in O(n^3)

The first line of input contains a positive integer ‘n’ which is the order of the input square matrix, Next ‘n’ lines contain ‘n’ integers each which are the elements of the matrix. Prints the inverse of the matrix if it is invertible, 'INVALID' otherwise. Also handles NaN exceptions.

Complexity Analysis: http://mathforum.org/library/drmath/view/51908.html

## 2. Solving the "Stable Marriage Problem"

SMP is the problem of finding a stable matching between two equally sized sets of elements given an ordering of preferences for each element. A matching is not stable if:

(i) There is an element A of the first matched set which prefers some given element B of the second matched set over the element to which A is already matched, and

(ii) B also prefers A over the element to which B is already matched.

A matching is stable when there does not exist any match (A, B) by which both A and B would be individually better off than they are with the element to which they are currently matched.  

Wiki: https://en.wikipedia.org/wiki/Stable_marriage_problem

The first line of the input contains a positive integer n (the number of marriages to be found). Next n lines contains are the women’s preferences i.e. ith contains i and a permutation of {1, 2, …, n} which denotes the preference of the ith woman. Similarly, the next n lines contain the men’s preferences in the same format.
