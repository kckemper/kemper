#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

#define MUTE_RATE	0.01

class Node {

	private:

		float	activate(float);
	
	public:

		int	nInputs;

		float*	w;

		Node (int);
		~Node ();
		
		void	clone (Node);
		float	eval (float *);
		void	setWeights (float *);
		void	mutate ();
		
};
