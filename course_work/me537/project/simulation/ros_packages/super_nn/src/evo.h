#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <time.h>

#include "net.h"

class Evo {
	
	private:

		int 	nNets;
		int 	nInputs;
		int 	nHidden;
		int 	nOutputs;
	
	public:

		Net*	netPool;			// population or pool of networks
		Net*	mutant;				// active net
	
		float eps;
		float eta;

		~Evo();
		Evo(int, int, int, int);
		
		int		worst();
		int		best();

		int		choose();
		float	eval(float*, float*);
		void	replace();

		float	step(float*);
		float	step(float*, float*);
		
};


