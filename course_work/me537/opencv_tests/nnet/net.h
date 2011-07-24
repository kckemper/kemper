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


Net::Net (int nI, int nH, int nO) {

	int i;
		
	grade		= 100;
	
	nInputs		= nI;
	nHidden		= nH;
	nOutputs	= nO;
	
	inputs		= (float*)malloc(sizeof(float)*nInputs);
	hiddens		= (float*)malloc(sizeof(float)*nHidden);
	outputs		= (float*)malloc(sizeof(float)*nOutputs);

	nodeHidden	= (Node*)malloc(sizeof(Node)*nHidden);									// create hidden layer array
	nodeOutput	= (Node*)malloc(sizeof(Node)*nOutputs);								// create output layer array
	
		
	for (i=0;i<nHidden;i++) {		// construct each hidden node
		nodeHidden[i] = Node(nInputs);
	}
		
	for (i=0;i<nOutputs;i++) {		// construct each output node
		nodeOutput[i] = Node(nHidden);
	}

}

//TODO
Net::~Net () {
//	free(inputs);
//	free(hiddens);
//	free(outputs);
//	free(nodeHidden);
//	free(nodeOutput);
}



// copy Net
void Net::clone (Net* cpy) {

	int i;
		
	grade		= cpy->grade;
	
	nInputs		= cpy->nInputs;
	nHidden		= cpy->nHidden;
	nOutputs	= cpy->nOutputs;

	
//	printf("Net:clone> copy hidden\n");
	for (i=0;i<nHidden;i++) {		// construct each hidden node
		nodeHidden[i].clone(cpy->nodeHidden[i]);
	}

//	printf("Net:clone> copy output\n");		
	for (i=0;i<nOutputs;i++) {		// construct each output node
		nodeOutput[i].clone(cpy->nodeOutput[i]);
	}

}






void Net::mutate() {
	int i;

	for (i=0;i<nHidden;i++)														// mutate the hidden layer...
		nodeHidden[i].mutate();	
	
	for (i=0;i<nOutputs;i++)													// mutate the output layer...
		nodeOutput[i].mutate();
}

	
void Net::eval (float* in) {
	int i;
	

	if (in == NULL)
		printf("Net:eval> input is NULL\n");


//	printf("Net:eval> hidden\n");
	for (i=0;i<nHidden;i++) {				// evaluate the hidden layer...
		hiddens[i] = nodeHidden[i].eval(in);
	}

//	printf("Net:eval> nOutputs %d\n",nOutputs);
	for (i=0;i<nOutputs;i++) {				// evaluate the output layer...
		outputs[i] = nodeOutput[i].eval(hiddens);
	}

}





