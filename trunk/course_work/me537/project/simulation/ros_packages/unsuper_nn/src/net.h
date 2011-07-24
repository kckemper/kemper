#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

#include "node.h"

class Net {
	
	public:
	
		int nInputs;
		int nHidden;
		int nOutputs;
	
		Node*	nodeHidden;
		Node*	nodeOutput;
		
		float	grade;

		float*	inputs;
		float*	hiddens;
		float*	outputs;


		~Net ();
		Net ();
		Net (int, int, int);
				
				
		void clone (Net*);
		void eval (float*);
		
		void mutate ();
		
};





