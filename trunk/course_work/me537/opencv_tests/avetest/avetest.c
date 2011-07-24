#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <math.h>

#define NF	6

// Globals

static const double pi = 3.14159265358979323846;

int high_switch_value	= 0;
int highInt				= 0;
int low_switch_value	= 0;
int lowInt				= 2;

int blur				= 6*2+1;


// Functions

inline static double square(int a) {
	return a * a;
}

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


void switch_callback_h( int position ){
	highInt = position*10;
}
void switch_callback_l( int position ){
	lowInt = position*10;
}
void switch_callback_g( int position ){
	blur = position*2+1;
}

int main( int argc, char** argv ) {
	
	const char* name1 = "ESC to stop";
	const char* options = "Options";


	char c;
	int toggle_flow	= 0;
	int toggle_can	= 0;
	
	int N = 7;
	int i = 0;

	int aperature_size = N;
	double lowThresh = 20;
	double highThresh = 40;

	CvCapture* capture = cvCreateCameraCapture(0) ;
		
	CvSize frame_size;
	CvScalar ave = cvScalar(1);
	
//	Preparation: BEFORE the function call this variable is the array size
//	(or the maximum number of features to find).  AFTER the function call
//	this variable is the number of features actually found.
	int number_of_features;
	
//	Preparation: This array will contain the features found in frame 1.
	CvPoint2D32f frame1_features[NF];
	
//	This array will contain the locations of the points from frame 1 in frame 2. */
	CvPoint2D32f frame2_features[NF];

//	The i-th element of this array will be non-zero if and only if the i-th feature of
//	frame 1 was found in frame 2.
	char optical_flow_found_feature[NF];

//	The i-th element of this array is the error in the optical flow for the i-th feature
//	of frame1 as found in frame 2.  If the i-th feature was not found (see the array above)
//	I think the i-th entry in this array is undefined.
	float optical_flow_feature_error[NF];
	
//	This is the window size to use to avoid the aperture problem (see slide "Optical Flow: Overview").
	CvSize optical_flow_window = cvSize(3,3);
	
//	This termination criteria tells the algorithm to stop when it has either done 20 iterations or when
//	epsilon is better than .3.  You can play with these parameters for speed vs. accuracy but these values
//	work pretty well in many situations.
	CvTermCriteria optical_flow_termination_criteria = cvTermCriteria( CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 20, .3 );

	
	static IplImage *frame		= NULL;
	static IplImage	*frame1		= NULL;
	static IplImage	*frame1_1C	= NULL;
	static IplImage	*frame2_1C	= NULL;
	static IplImage	*frame3_1C	= NULL;
	static IplImage	*frame4_1C	= NULL;
	static IplImage *frameX_1C[NF];

	static IplImage	*ave_image	= NULL;
	static IplImage *scale		= NULL;
	
	cvNamedWindow( name1, CV_WINDOW_AUTOSIZE );
	cvNamedWindow( options, CV_WINDOW_AUTOSIZE );

	frame = cvQueryFrame( capture );
	if( !frame ) return 0;

	frame_size	= cvSize(frame->width,frame->height);
	
//	cvCvtColor(frame,frame_g,CV_BGR2GRAY);


	

	// Create trackbars
	cvCreateTrackbar( "High", options, &high_switch_value, 100, switch_callback_h );
	cvCreateTrackbar( "Low", options, &low_switch_value, 100, switch_callback_l );
	cvCreateTrackbar( "Gaussian", options, &blur, 20, switch_callback_g );

	allocateOnDemand( &ave_image, frame_size, IPL_DEPTH_8U, 1 );

	allocateOnDemand( &scale, frame_size, IPL_DEPTH_8U, 1 );
	cvSet(scale, ave);




	while(1) {

		highThresh	= highInt;	
		lowThresh	= lowInt;
		
		// make blank image...

		cvSet(ave_image, cvScalar(0));
		
	
		for (i=0;i<NF;i++) {
	
			frame = cvQueryFrame( capture );
			if( !frame ) break;
		
			allocateOnDemand( &frameX_1C[i], frame_size, IPL_DEPTH_8U, 1 );

			cvConvertImage(frame, frameX_1C[i] );//, CV_CVTIMG_FLIP);
//			cvConvertScale(frameX_1C[i], frameX_1C[i], (1.00/NF));
			cvSub(frameX_1C[i], ave_image, ave_image);

		}
		


		cvDilate(ave_image, ave_image,NULL,4);


		cvShowImage( name1, ave_image );
		
		c = cvWaitKey(5);
		
		if( c == 27 ) break;
		else if( c == '.') toggle_flow = 1;
		else if( c == ',') toggle_flow = 0;		
		else if( c == '[') toggle_can = 1;
		else if( c == ']') toggle_can= 0;		
		else if( c == 'q') {
			cvSaveImage("output.jpg",frame1);
			cvSaveImage("input.jpg",frame);
		}

	}

	cvReleaseCapture( &capture );
	cvDestroyWindow( name1 );
	cvDestroyWindow( options );
}
