#include "evo_unsupervised_learner.h"

const char* sliced_filename_format = "/media/shared_space/diff_drive_pictures/sliced%10u.jpg";
const char* weight_filename_format = "/media/shared_space/diff_drive_pictures/weights%10u.jpg";

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

EvoUnsupervisedLearner::EvoUnsupervisedLearner() {
	////////////////////////////////////////////////////////////////////////////////
	// init stuff
						 
	line_color		= CV_RGB(0,0,255);

	name_orig		= "Original: press q to save images";
	name_ave		= "input";
	name_weights	= "weights";
	
	outputFile_name		= "/home/koepld/Desktop/me537/coffeemachine/project/simulation/output_";
	
	capture = cvCreateCameraCapture(0) ;
		
	ave = cvScalar(1);
	
	frame				= NULL;
	frame_g				= NULL;
	frame_small			= NULL;
	frame_weights		= NULL;
	frame_w_big			= NULL;
	frame_w_final		= NULL;
	frame_final			= NULL;	
	
	ave_image			= NULL;
//scale					= NULL;
	
	frame_slices[N_SLICES];

//	desired[] = {0,0,0,1,1,0,0,0};										//XXX dummy test...	

	flag = 0;
}

EvoUnsupervisedLearner::EvoUnsupervisedLearner(IplImage* img) {

	////////////////////////////////////////////////////////////////////////////////
	// init stuff
						 
	line_color		= CV_RGB(0,0,255);

	name_orig		= "Original: press q to save images";
	name_ave		= "input";
	name_weights	= "weights";
	
	outputFile_name		= "/home/koepld/Desktop/me537/coffeemachine/project/simulation/output_";
	
	capture = cvCreateCameraCapture(0) ;
		
	ave = cvScalar(1);
	
	frame				= NULL;
	frame_g				= NULL;
	frame_small			= NULL;
	frame_weights		= NULL;
	frame_w_big			= NULL;
	frame_w_final		= NULL;
	frame_final			= NULL;	
	
	ave_image			= NULL;
//scale					= NULL;
	
	frame_slices[N_SLICES];

//	desired[] = {0,0,0,1,1,0,0,0};										//XXX dummy test...	

	flag = 0;
	
	// create windows for looking at stuff
//	cvNamedWindow( name_slice,	CV_WINDOW_AUTOSIZE );
	cvNamedWindow( name_weights,	CV_WINDOW_AUTOSIZE );
	cvNamedWindow( name_ave,		CV_WINDOW_AUTOSIZE );
	cvNamedWindow( name_orig,		CV_WINDOW_AUTOSIZE );
	

//	frame_size	= cvSize(frame->width,frame->height);
	frame_size	= cvSize(SIZE,SIZE);

	// Use provided image to get an idea about the image size.	
	frame = img;
	if( !frame ){ printf("ERROR RECEIVING!!!\n"); return;}

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

	evoSlice = (Evo*)malloc(sizeof(Evo)*N_SLICES);

}

void EvoUnsupervisedLearner::initialize(int trial) {
//		sprintf(outputName,"%s%d.txt", outputFile_name, trial);
//		outputFile		= fopen(outputName,"w");

		// init each learner
		for(i=0;i<N_SLICES;i++) {
			evoSlice[i] = Evo(N_NETS, (SIZE/N_SLICES)*SIZE, N_HIDDEN, 1);
			evoSlice[i].choose();
			choices[i] = evoSlice[i].choose();
		}

		ep		= 0;
		stepCnt = 0;
}

char EvoUnsupervisedLearner::takeImage(IplImage* frame, int picture_counter) {
////////////////////////////////////////////////////////////////////////////////
// Pre processing
	int i;		
	int cmd = 0;
	char maxi = 0;

	cvConvertImage(frame, frame_g );
	cvResize(frame_g, frame_small);
	cvConvertImage(frame_small, ave_image );

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
//		fprintf(outputFile,"%d",ep);

		for(i=0;i<N_SLICES;i++) {
			evoSlice[i].replace();
			choices[i] = evoSlice[i].choose();
		
//			fprintf(outputFile,"\t%1.3f",evoSlice[i].netPool[evoSlice[i].best()].grade);		
		}
	
//		fprintf(outputFile,"\n");
	
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

//	printf("\nTrial: %d   Episode: %d   Devin's cmd: %d\n",trial,ep,cmd);
//	for(i=0;i<N_SLICES;i++)
//		printf("%1.3f\t",desired[cmd][i]);
//	printf("\n");

	for(i=0;i<N_SLICES;i++) {
//			cvShowImage( name_slice, frame_slices[i] );

		// strip pixel data into a single array
		for(j=0;j<SIZE;j++) {
			for(k=0;k<(SIZE/N_SLICES);k++) {
				inputs[(j*(SIZE/N_SLICES))+k]	= (float)PIX(frame_slices[i],k,j)/255.0;
			}
		}

//			printf("\n%d: Eval slice %d\n",stepCnt,i);
		outputs[i] = evoSlice[i].eval(inputs);
//			outputs[i] = desired[i];
//		printf("%1.3f\t",outputs[i]);

	}
//	printf("\n");

//	for(i=0;i<N_SLICES;i++) {
//		printf("%d\t",choices[i]);
//	}
//	printf("\n");

//	for(i=0;i<N_SLICES;i++) {
//		printf("%1.3f\t",evoSlice[i].mutant->grade);
//	}
//	printf("\n");

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

	// Save pictures.
	sprintf(sliced_filename, sliced_filename_format, picture_counter);
	sprintf(weight_filename, weight_filename_format, picture_counter);
	cvSaveImage(sliced_filename, frame_final);
	cvSaveImage(weight_filename, frame_w_final);
	picture_counter++;

//			c = cvWaitKey(2);
//		
//			if( c == 27 ) break;
//			else if( c == 'q') {
//				cvSaveImage("weights.jpg",frame_w_final);
//				cvSaveImage("output.jpg",frame_final);
//			}

	stepCnt++;

//		free(evoSlice);
//		fclose(outputFile);

////////////////////////////////////////////////////////////////////////////////
// clean up
//	delete &evo;
	
//	cvReleaseCapture(	&capture );
//	cvDestroyWindow(	name_ave );
//	cvDestroyWindow(	name_orig );
//	cvDestroyWindow(	name_weights );

	for (i = 0; i < N_SLICES; i++) {
		if (outputs[i] > outputs[maxi]) {
			maxi = i;
		}
	}

	return maxi;
}

void EvoUnsupervisedLearner::penalize(float penalty) {
	int i;

	// Just punish all of the evos for now.	
	for (i = 0; i < N_SLICES; i++) {
		evoSlice[i].penalize(penalty);
	}
}

void EvoUnsupervisedLearner::decayPenalties(float decay) {
	int i;

	// Decay all of the evos penalties.
	for (i = 0; i < N_SLICES; i++) {
		evoSlice[i].decayPenalty(decay);
	}
}
