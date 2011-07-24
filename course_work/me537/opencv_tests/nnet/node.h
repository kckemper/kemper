#include <stdlib.h>
#include <time.h>
#include <math.h>

#define MUTE_RATE	0.01

class Node {

	float	activate(float);
	
	public:

		int	nInputs;

		float*	w;

		~Node ();
		Node (int);
		
		void	clone (Node);
		float	eval (float *);
		void	setWeights (float *);
		void	mutate ();
		
};



// nInputs is number of inputs conneced to this node excluding the bias.  The
//  bias is handled automatically.
Node::Node (int nI) {
	srand(rand()*time(NULL));
	int i;
	float r;

	nInputs = nI;									// plus one for the bias


	w = (float*)malloc(sizeof(float)*(nInputs+1));
	if (w == NULL)
		printf("Node:Node> w is null, want size of %d\n",sizeof(float)*(nInputs+1));
	

	
	
	for (i=0;i<nInputs+1;i++) {							// set the other weights...
		r = (((float)rand()/(float)(RAND_MAX)))*2-1;				// random number between -1 and 1
		w[i] = r*0.1 * (1/sqrt(nInputs+1));
	}

}

Node::~Node () {
//	free(w);
}


// clone
void Node::clone (Node cpy) {
	srand(rand()*time(NULL));
	int i;
	float r;

	nInputs = cpy.nInputs;

	if (w == NULL) {
		w = (float*)malloc(sizeof(float)*(nInputs+1));
		printf("Node:clone> w is null\n");
	}

	for (i=0;i<nInputs+1;i++)							// copy the weights...
		w[i] = cpy.w[i];

}



float Node::eval (float* inputs) {
	int i;
	float sum = w[0];

//	printf("Node:eval> start\n");

	for (i=0;i<nInputs;i++)
		sum += w[i+1]*inputs[i]; 

//	printf("Node:eval> sum %1.3f\n",sum);
	return activate(sum);
}


void Node::mutate () {
	srand(rand()*time(NULL));
	int i,rI;
	float r;

#if 1	
	for (i=0;i<(int)((nInputs+1)/10);i++) {

		rI = rand() % (nInputs+1);
		r = (((float)rand()/(float)(RAND_MAX)))*2-1;

		w[rI] += r * MUTE_RATE*50;
	}
#endif
	
#if 0
	for (i=0;i<nInputs+1;i++) {
		r = (((float)rand()/(float)(RAND_MAX)))*2-1;
		w[i] += r * MUTE_RATE;
	}
#endif
	
}

	
void Node::setWeights (float* newW) {
	int i;
	
	for (i=0;i<nInputs+1;i++)
		w[i] = newW[i];
}


float Node::activate(float sum) {
	return 1/(1+exp(-sum));
}





