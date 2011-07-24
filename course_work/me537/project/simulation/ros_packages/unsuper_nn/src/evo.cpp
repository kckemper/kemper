#include "evo.h"

Evo::Evo (int nN, int nI, int nH, int nO) {

	int i;
	
	eps	= 0.1;
	eta = 0.1;
	
	nNets		= nN;
	nInputs		= nI;
	nHidden		= nH;
	nOutputs	= nO;
	
	netPool	= (Net*)malloc(sizeof(Net)*nNets);									// allocate space for the pool of nets

	for (i=0;i<nNets;i++) {														// construct each net
		netPool[i] = Net(nInputs, nHidden, nOutputs);
	}

	mutant = (Net*)malloc(sizeof(Net));
	*mutant = Net(nInputs, nHidden, nOutputs);

}

//TODO:
Evo::~Evo () {
//	free(netPool);
//	free(mutant);
}


// find net with highest grade
int Evo::worst() {
		int i;
		int worst = 0;

		for(i=0;i<nNets;i++) {			
			if (netPool[i].grade > netPool[worst].grade) {
				worst = i;
			}
		}
		
		return worst;
	}
	
// find net with lowest grade
int Evo::best() {
		int i;
		int best = 0;

		for(i=0;i<nNets;i++) {			
			if (netPool[i].grade < netPool[best].grade) {
				best = i;
			}
		}
		
		return best;
	}

int Evo::choose() {
	srand(rand()*time(NULL));
	float	r = (float)rand()/(float)RAND_MAX;									// random number between 0 and 1
	int		i;

	// choose individual from pool
	if ((1-eps) > r) {															// choose best
		i	= best();
	}
	else {																		// choose random
		i	= rand() % nNets;
	}

	// clone
	mutant->clone(&netPool[i]);
	
	// mutate
	mutant->mutate();
	
	// reset grade (start with a small grade that will grow if she is a twirler).
	mutant->grade = 0.1;
	
	return i;
}


float Evo::eval(float* inputs) {
	float*	output;
//	float	tmp;
//	float	sum;
//	int		i;

	// evaluate
	mutant->eval( inputs );
	output = mutant->outputs;

//	// assign grade
//	sum = 0;
//	for(i=0;i<nOutputs;i++) {
//		tmp = des[i]-output[i];
//		if(tmp < 0) tmp *= -1;
//		sum += tmp;
//	}
//	mutant->grade += sum;

	return output[0];
}

void Evo::penalize(float penalty) {
	mutant->grade += penalty;
}

void Evo::decayPenalty(float decay) {
	mutant->grade *= decay;
}


void Evo::replace() {

	if ( mutant->grade < netPool[worst()].grade ) {								// if it's better...
		netPool[worst()].clone(mutant);											// copy net->worst()
	}

}


// step without training
float Evo::step(float * inputs) {

//TODO: allow chice of net?

	netPool[best()].eval( inputs );

	return 0;	
}

// set with training
float Evo::step(float * inputs, float * des) {
	srand(rand()*time(NULL));
	float r = (float)rand()/(float)RAND_MAX;									// random number between 0 and 1
	
	float*		output;
	float		sum;
	float		tmp;
	int			i;
	
	
	// choose individual from pool
	if ((1-eps) > r) {															// choose best
		i	= best();
	}
	else {																		// choose random
		i	= rand() % nNets;
	}
	
//	net = Net(nInputs, nHidden, nOutputs);
		
	// clone
//	printf("Clone %d\n", i);
	mutant->clone(&netPool[i]);
	
	// mutate
//	printf("Mutate\n");
	mutant->mutate();

	// evaluate
//	printf("Evaluate\n");
	mutant->eval( inputs );
	output = mutant->outputs;


	// assign grade
//	printf("Grade\n");
	sum = 0;
	for(i=0;i<nOutputs;i++) {
		tmp = des[i]-output[i];
		if(tmp < 0) tmp *= -1;
		sum += tmp;
//		printf("des: %1.3f     output: %1.3f     abs(des[i]-output[i]): %1.3f\n", des[i],output[i], tmp);	
	}
	mutant->grade = sum;
	
	// replace worst or discard
	if ( mutant->grade < netPool[worst()].grade ) {											// if it's better...
		netPool[worst()].clone(mutant);											// copy net->worst()
	}
	
	// print grades for debugging
//	printf("Grades:");
//	for(i=0;i<nNets;i++)
//		printf("\t%1.3f",netPool[i].grade);
//	printf("\n");
	

	return output[0];
}


