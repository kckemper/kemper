#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <math.h>
#include <iostream>
#include <fstream>

#include "evo.h"

#define NF			6

#define N_SLICES	8				// number of slices to make of the image
#define N_STEPS		855				// number of images
#define SIZE		16				// scaled image size

#define N_LEARN		200				// number of images per learing episode
#define N_EPISODES	50				// number of learning episodes
#define N_TRIALS	10				// number of times to repeat the learning

#define N_NETS		20
#define N_HIDDEN	16

#define PIX(img,x,y) ((uchar*)((img)->imageData + (img)->widthStep*(y)))[(x)]

static void allocateOnDemand( IplImage **, CvSize, int, int);

class EvoUnsupervisedLearner {
	private:
							 
		CvPoint		p,q;
		CvScalar	line_color;
		CvScalar	out_color;

		const char* name_orig;
		const char* name_ave;
		const char* name_weights;
	
		const char*	inputCmdFile_name;
		const char*	outputFile_name;
		FILE*		outputFile;
		FILE*		inputCmdFile;
		char		inputName[128];
		char		outputName[128];

		// Picture filenames.		
		char sliced_filename[128];		
		char weight_filename[128];	

		CvCapture* capture;
		
		CvSize frame_size;
		CvScalar ave;
	
	
		CvRect  slice_rect;
		CvSize	slice_size;

		IplImage*	frame;
		IplImage*	frame_g;
		IplImage*	frame_small;
		IplImage*	frame_weights;
		IplImage*	frame_w_big;
		IplImage*	frame_w_final;
		IplImage*	frame_final;	
	
		IplImage*	ave_image;
	//	static	IplImage *scale;
	
		IplImage*	frame_slices[N_SLICES];



		float	inputs[(SIZE/N_SLICES)*SIZE];
		float	outputs[N_SLICES];
		int		choices[N_SLICES];
	//	float	desired[N_SLICES];
	//	float	desired[] = {0,0,0,1,1,0,0,0};										//XXX dummy test...	

		//Evo (int nNets, int nInputs, int nHidden, int nOuts)
		Evo*	evoSlice;

		int		ep;
		int		trial;
		int		stepCnt;

		int		flag;

		char	c;
		int		i,j,k,s;
		float	tmp;

	public:
		
		EvoUnsupervisedLearner();
		EvoUnsupervisedLearner(IplImage*);

		void initialize(int);
		char takeImage(IplImage*, int);
		void penalize(float);
		void decayPenalties(float);

};
