#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <math.h>
#include <iostream>
#include <fstream>

#include "evo.cpp"

#define NF			6

#define N_SLICES	8				// number of slices to make of the image
#define N_STEPS		855				// number of images
#define SIZE		16				// scaled image size

#define N_LEARN		50				// number of images per learing episode
#define N_EPISODES	50				// number of learning episodes
#define N_TRIALS	10				// number of times to repeat the learning

#define N_NETS		20
#define N_HIDDEN	16

#define PIX(img,x,y) ((uchar*)((img)->imageData + (img)->widthStep*(y)))[(x)]


/* This is just an inline that allocates images.  I did this to reduce clutter in the
 * actual computer vision algorithmic code.  Basically it allocates the requested image
 * unless that image is already non-NULL.  It always leaves a non-NULL image as-is even
 * if that image's size, depth, and/or channels are different than the request.
 */
inline static void allocateOnDemand( IplImage **img, CvSize size, int depth, int channels ) {
	if ( *img != NULL )	return;

	*img = cvCreateImage( size, depth, channels );
	if ( *img == NULL ) {
		fprintf(stderr, "Error: Couldn't allocate image.  Out of memory?\n");
		exit(-1);
	}
}




int main( int argc, char** argv ) {
	
	int		cmd;
	float	desired[8][8]	= { {1,0,0,0,0,0,0,0},	// 0
								{0,1,0,0,0,0,0,0},	// 1
								{0,0,1,0,0,0,0,0},	// 2
								{0,0,0,1,1,0,0,0},	// 3 forward
								{0,0,0,1,1,0,0,0},	// 4 forward
								{0,0,0,0,0,1,0,0},	// 5
								{0,0,0,0,0,0,1,0},	// 6
								{0,0,0,0,0,0,0,1}};	// 7
						 
	CvPoint		p,q;
	CvScalar	line_color		= CV_RGB(0,0,255);
	CvScalar	out_color;

	const char* name_orig		= "Original: press q to save images";
	const char* name_ave		= "input";
	const char* name_weights	= "weights";
	
	const char*	inputCmdFile_name	= "/home/koepld/Desktop/me537/coffeemachine/project/simulation/training_data/dataset1/commandlist.dat";
	const char*	outputFile_name		= "/home/koepld/Desktop/me537/coffeemachine/project/simulation/output_";
	FILE*		outputFile;
	FILE*		inputCmdFile;
	char		inputName[128];
	char		outputName[128];

	
	CvCapture* capture = cvCreateCameraCapture(0) ;
		
	CvSize frame_size;
	CvScalar ave = cvScalar(1);
	
	
	CvRect  slice_rect;
	CvSize	slice_size;

	static	IplImage*	frame				= NULL;
	static	IplImage*	frame_g				= NULL;
	static	IplImage*	frame_small			= NULL;
	static	IplImage*	frame_weights		= NULL;
	static	IplImage*	frame_w_big			= NULL;
	static	IplImage*	frame_w_final		= NULL;
	static	IplImage*	frame_final			= NULL;	
	
	static	IplImage*	ave_image			= NULL;
//	static	IplImage *scale					= NULL;
	
	static	IplImage*	frame_slices[N_SLICES];



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

	int		flag = 0;

	char	c;
	int		i,j,k,s;
	float	tmp;

////////////////////////////////////////////////////////////////////////////////
// init stuff
	
	inputCmdFile	= fopen(inputCmdFile_name,"r");
	if (inputCmdFile == NULL) {printf("Unable to open: %s\n",inputCmdFile_name); return 0; }
	
	// create windows for looking at stuff
//	cvNamedWindow( name_slice,	CV_WINDOW_AUTOSIZE );
	cvNamedWindow( name_weights,	CV_WINDOW_AUTOSIZE );
	cvNamedWindow( name_ave,		CV_WINDOW_AUTOSIZE );
	cvNamedWindow( name_orig,		CV_WINDOW_AUTOSIZE );
	

//	frame_size	= cvSize(frame->width,frame->height);
	frame_size	= cvSize(SIZE,SIZE);

	// capture a frame so we can get an idea of the size of the source
//	frame = cvQueryFrame( capture );
//	if( !frame ) return 0;
	
	sprintf(inputName,"/home/koepld/Desktop/me537/coffeemachine/project/simulation/training_data/dataset1/image0000000000.jpg");
	frame = cvLoadImage(inputName, 0 );
	if( !frame ){ printf("ERROR OPENING: %s!!!\n",inputName); return 0;}

	allocateOnDemand( &frame_g,			cvSize(frame->width,frame->height), IPL_DEPTH_8U, 1 );
	allocateOnDemand( &frame_w_big,		cvSize(frame->width,frame->height), IPL_DEPTH_8U, 1 );	
	allocateOnDemand( &frame_w_final,	cvSize(frame->width,frame->height), IPL_DEPTH_8U, 3 );	
	allocateOnDemand( &frame_final,		cvSize(frame->width,frame->height+20), IPL_DEPTH_8U, 3 );	
	
	
	allocateOnDemand( &ave_image,		frame_size, IPL_DEPTH_8U, 1 );
	allocateOnDemand( &frame_small,		frame_size, IPL_DEPTH_8U, 1 );
	allocateOnDemand( &frame_weights,	frame_size, IPL_DEPTH_8U, 1 );


	slice_size = cvSize(ave_image->width/N_SLICES, ave_image->height);


	for (i=0;i<N_SLICES;i++) {
		allocateOnDemand( &frame_slices[i], slice_size, IPL_DEPTH_8U, 1);
	}

	for(trial=0;trial<N_TRIALS;trial++) {


		sprintf(outputName,"%s%d.txt", outputFile_name, trial);
		outputFile		= fopen(outputName,"w");


		// init each leariner
		evoSlice = (Evo*)malloc(sizeof(Evo)*N_SLICES);
		for(i=0;i<N_SLICES;i++) {
			evoSlice[i] = Evo(N_NETS, (SIZE/N_SLICES)*SIZE, N_HIDDEN, 1);
			evoSlice[i].choose();
			choices[i] = evoSlice[i].choose();
		}

		ep		= 0;
		stepCnt = 0;
		flag	= 0;

		while(1) {

	////////////////////////////////////////////////////////////////////////////////
	// Pre processing		

	#if 0
			// make blank image...
			cvSet(ave_image, cvScalar(0));

	
			for (i=0;i<NF;i++) {
	
				// get image
				frame = cvQueryFrame( capture );
				if( !frame ) break;
			
				// convert it to grey
				cvConvertImage(frame, frame_g );//, CV_CVTIMG_FLIP);
	//			cvConvertScale(frameX_1C[i], frameX_1C[i], (1.00/NF));


				// resize
				cvResize(frame_g, frame_small);
					
				// take difference
				cvSub(frame_small, ave_image, ave_image);

			}
	#endif
	#if 0		
			frame = cvQueryFrame( capture );
			if( !frame ) break;
			cvConvertImage(frame, frame_g );
			cvResize(frame_g, frame_small);
			cvConvertImage(frame_small, ave_image );
	#endif
		
		
			sprintf(inputName,"/home/koepld/Desktop/me537/coffeemachine/project/simulation/training_data/dataset1/image%010d.jpg",stepCnt);
			frame = cvLoadImage(inputName, 0 );
			if( !frame ){ printf("ERROR OPENING: %s!!!\n",inputName); break;}
			cvConvertImage(frame, frame_g );
			cvResize(frame_g, frame_small);
			cvConvertImage(frame_small, ave_image );
		
		
		
	//		cvDilate(ave_image, ave_image,NULL,4);


	////////////////////////////////////////////////////////////////////////////////
	// Generate NN inputs


			// slice it up
			for (i=0;i<N_SLICES;i++) {
	
				slice_rect = cvRect(i*ave_image->width/N_SLICES, 0, ave_image->width/N_SLICES, ave_image->height);

				cvSetImageROI(ave_image, slice_rect);
				
				cvCopy(ave_image, frame_slices[i], NULL);

			}

			cvResetImageROI(ave_image);  // remove this when we don't care about looking at the ave

	////////////////////////////////////////////////////////////////////////////////
	// Evaluate NN
			if (stepCnt == N_LEARN)
				flag = 1;
	
			if( (flag == 1) && (stepCnt%N_LEARN == 0)) {	// every N_LEARN images switch
		
				ep++;
				fprintf(outputFile,"%d",ep);

				for(i=0;i<N_SLICES;i++) {
					evoSlice[i].replace();
					choices[i] = evoSlice[i].choose();
				
					fprintf(outputFile,"\t%1.3f",evoSlice[i].netPool[evoSlice[i].best()].grade);
				
				}
			
				fprintf(outputFile,"\n");
			
				if(ep >= N_EPISODES) break;
			
				// draw weights image
				for(s=0;s<N_SLICES;s++) {
		
					for(j=0;j<SIZE;j++) {
						for(k=0;k<(SIZE/N_SLICES);k++) {
				
							tmp = 0;
							for(i=0;i<N_HIDDEN;i++) {
								tmp += evoSlice[s].mutant->nodeHidden->w[(j*(SIZE/N_SLICES))+k+1];
							}
					
							PIX(frame_weights,k+(s*SIZE/N_SLICES),j) = (char)((tmp/N_HIDDEN)*255 + 127);
		//					printf("%d\t",(char)((tmp/N_HIDDEN)*255));
						}
					}
				}

				cvResize(frame_weights, frame_w_big, CV_INTER_LINEAR);
				cvConvertImage(frame_w_big, frame_w_final);
			
			}


			fscanf(inputCmdFile,"%d",&cmd);

			printf("\nTrial: %d   Episode: %d   Devin's cmd: %d\n",trial,ep,cmd);
			for(i=0;i<N_SLICES;i++)
				printf("%1.3f\t",desired[cmd][i]);
			printf("\n");
		

			for(i=0;i<N_SLICES;i++) {
	//			cvShowImage( name_slice, frame_slices[i] );

				// strip pixel data into a single array
				for(j=0;j<SIZE;j++) {
					for(k=0;k<(SIZE/N_SLICES);k++) {
						inputs[(j*(SIZE/N_SLICES))+k]	= (float)PIX(frame_slices[i],k,j)/255.0;
					}
				}


	//			printf("\n%d: Eval slice %d\n",stepCnt,i);
				outputs[i] = evoSlice[i].eval(inputs, &desired[cmd][i]);
	//			outputs[i] = desired[i];
				printf("%1.3f\t",outputs[i]);

			}
			printf("\n");

			for(i=0;i<N_SLICES;i++) {
				printf("%d\t",choices[i]);
			}
			printf("\n");

			for(i=0;i<N_SLICES;i++) {
				printf("%1.3f\t",evoSlice[i].mutant->grade);
			}
			printf("\n");

	////////////////////////////////////////////////////////////////////////////////
	// GUI stuff

		
		
		
			// copy input image into larger final image
			cvSetImageROI(frame_final, cvRect(0, 0, frame_w_big->width, frame_w_big->height));
			cvConvertImage(frame, frame_final);
			cvResetImageROI(frame_final);

			// draw slice markers
			for(i=1;i<N_SLICES;i++) {
				// on the final frame...
				p.x = (int)(i*frame_final->width/N_SLICES);
				p.y = 0;
				q.x = p.x;
				q.y = (int)frame_final->height;
				cvLine( frame_final, p, q, line_color, 2, CV_AA, 0 );

				// on the weights
				p.x = (int)(i*frame_w_final->width/N_SLICES);
				p.y = 0;
				q.x = p.x;
				q.y = (int)frame_w_final->height;
				cvLine( frame_w_final, p, q, line_color, 2, CV_AA, 0 );
			}

			// draw output indicators
			for(i=0;i<N_SLICES;i++) {
				out_color = CV_RGB(outputs[i]*255,0,0);
				p.x = (int)(i*frame_final->width/N_SLICES);
				p.y = (int)(frame_final->height-20);
				q.x = (int)(p.x+frame_final->width/N_SLICES);
				q.y = (int)(p.y+20);
				cvRectangle( frame_final, p, q, out_color, CV_FILLED, CV_AA, 0 );
			}
		
		
			cvShowImage( name_ave,		ave_image );
			cvShowImage( name_orig,		frame_final );
			cvShowImage( name_weights,	frame_w_final );
		
			c = cvWaitKey(2);
		
			if( c == 27 ) break;
			else if( c == 'q') {
				cvSaveImage("weights.jpg",frame_w_final);
				cvSaveImage("output.jpg",frame_final);
			}

			stepCnt++;
			if (stepCnt==(N_STEPS-(N_STEPS%N_LEARN))) {
				stepCnt=0;
				rewind(inputCmdFile);
			}


		} // end while

		free(evoSlice);
		fclose(outputFile);
	} // end trial for

////////////////////////////////////////////////////////////////////////////////
// clean up
//	delete &evo;

	fclose(inputCmdFile);
	
	cvReleaseCapture(	&capture );
	cvDestroyWindow(	name_ave );
	cvDestroyWindow(	name_orig );
	cvDestroyWindow(	name_weights );
}
