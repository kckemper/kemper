#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <math.h>

#define NF	600
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

	int aperature_size = N;
	double lowThresh = 20;
	double highThresh = 40;

	CvCapture* capture = cvCreateCameraCapture(0) ;
		
	CvSize frame_size;
	
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
	static IplImage	*eig_image	= NULL;
	static IplImage	*temp_image	= NULL;
	static IplImage	*pyramid1	= NULL;
	static IplImage	*pyramid2	= NULL;
	static IplImage *can		= NULL;
	
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


	while(1) {

		highThresh	= highInt;	
		lowThresh	= lowInt;
		
	
	
		frame = cvQueryFrame( capture );
		if( !frame ) break;
		
		
		allocateOnDemand( &frame1_1C, frame_size, IPL_DEPTH_8U, 1 );

		cvConvertImage(frame, frame1_1C );//, CV_CVTIMG_FLIP);

//		cvCanny(frame1_1C, frame1_1C, lowThresh*N*N, highThresh*N*N, aperature_size);
//		cvDilate(frame1_1C, frame1_1C,NULL,2);
		
		allocateOnDemand( &frame1, frame_size, IPL_DEPTH_8U, 3 );

		if (toggle_can == 1) {
			allocateOnDemand( &can, frame_size, IPL_DEPTH_8U, 1 );
			cvConvertImage(frame1_1C, can);//, CV_CVTIMG_FLIP);

			cvCanny(can, can, lowThresh*N*N, highThresh*N*N, aperature_size);
//			cvDilate(can, can,NULL,1);

			cvConvertImage(can, frame1);//, CV_CVTIMG_FLIP);
		}
		else {
		
			cvConvertImage(frame, frame1);//, CV_CVTIMG_FLIP);
		}


//	Get second frame
		frame = cvQueryFrame( capture );
		if( !frame ) break;

		allocateOnDemand( &frame2_1C, frame_size, IPL_DEPTH_8U, 1 );
		cvConvertImage(frame, frame2_1C);//, CV_CVTIMG_FLIP);

//		cvCanny(frame2_1C, frame2_1C, lowThresh*N*N, highThresh*N*N, aperature_size);
//		cvDilate(frame2_1C, frame2_1C,NULL,2);



//	Preparation: Allocate the necessary storage.
		allocateOnDemand( &eig_image, frame_size, IPL_DEPTH_32F, 1 );
		allocateOnDemand( &temp_image, frame_size, IPL_DEPTH_32F, 1 );




		number_of_features = NF;


//	Actually run the Shi and Tomasi algorithm!!
//	"frame1_1C" is the input image.
//	"eig_image" and "temp_image" are just workspace for the algorithm.
//	The first ".01" specifies the minimum quality of the features (based on the eigenvalues).
//	The second ".01" specifies the minimum Euclidean distance between features.
//	"NULL" means use the entire input image.  You could point to a part of the image.
//	WHEN THE ALGORITHM RETURNS:
//	"frame1_features" will contain the feature points.
//	"number_of_features" will be set to a value <= 400 indicating the number of feature points found.

		cvGoodFeaturesToTrack(frame1_1C, eig_image, temp_image, frame1_features, &number_of_features, 0.01, 0.01, NULL);


//	Pyramidal Lucas Kanade Optical Flow!


//	This is some workspace for the algorithm.
//	(The algorithm actually carves the image into pyramids of different resolutions.)
		allocateOnDemand( &pyramid1, frame_size, IPL_DEPTH_8U, 1 );
		allocateOnDemand( &pyramid2, frame_size, IPL_DEPTH_8U, 1 );


/*	Actually run Pyramidal Lucas Kanade Optical Flow!!
 * "frame1_1C" is the first frame with the known features.
 * "frame2_1C" is the second frame where we want to find the first frame's features.
 * "pyramid1" and "pyramid2" are workspace for the algorithm.
 * "frame1_features" are the features from the first frame.
 * "frame2_features" is the (outputted) locations of those features in the second frame.
 * "number_of_features" is the number of features in the frame1_features array.
 * "optical_flow_window" is the size of the window to use to avoid the aperture problem.
 * "5" is the maximum number of pyramids to use.  0 would be just one level.
 * "optical_flow_found_feature" is as described above (non-zero iff feature found by the flow).
 * "optical_flow_feature_error" is as described above (error in the flow for this feature).
 * "optical_flow_termination_criteria" is as described above (how long the algorithm should look).
 * "0" means disable enhancements.  (For example, the second array isn't pre-initialized with guesses.)
 */
		cvCalcOpticalFlowPyrLK(frame1_1C, frame2_1C, pyramid1, pyramid2, frame1_features, frame2_features, number_of_features, optical_flow_window, 5, optical_flow_found_feature, optical_flow_feature_error, optical_flow_termination_criteria, 0 );


/* For fun (and debugging :)), let's draw the flow field. */
		for(int i = 0; i < number_of_features && toggle_flow; i++) {
		
			/* If Pyramidal Lucas Kanade didn't really find the feature, skip it. */
			if ( optical_flow_found_feature[i] == 0 )	continue;

			int line_thickness;				line_thickness = 2;
			int magx,magy,mag;
			/* CV_RGB(red, green, blue) is the red, green, and blue components
			 * of the color you want, each out of 255.
			 */	
			CvScalar line_color;			line_color = CV_RGB(255,0,0);
	
			/* Let's make the flow field look nice with arrows. */

			/* The arrows will be a bit too short for a nice visualization because of the high framerate
			 * (ie: there's not much motion between the frames).  So let's lengthen them by a factor of 3.
			 */
			CvPoint p,q;
			p.x = (int) frame1_features[i].x;
			p.y = (int) frame1_features[i].y;
			q.x = (int) frame2_features[i].x;
			q.y = (int) frame2_features[i].y;

			double angle;		angle = atan2( (double) p.y - q.y, (double) p.x - q.x );
			double hypotenuse;	hypotenuse = sqrt( square(p.y - q.y) + square(p.x - q.x) );

			/* Here we lengthen the arrow by a factor of three. */
//			q.x = (int) (p.x - 3 * hypotenuse * cos(angle));
//			q.y = (int) (p.y - 3 * hypotenuse * sin(angle));

			p.x = p.x-3;
			p.y = p.y-3;
			q.x = p.x+6;
			q.y = p.y+6;
			magx = (int) (p.x - 1* hypotenuse * cos(angle));
			magy = (int) (p.y - 1 * hypotenuse * sin(angle));
//			mag	 = (int) sqrt(magx*magx+magy*magy);
			mag  = (int) (hypotenuse*50);

			/* Now we draw the main line of the arrow. */
			/* "frame1" is the frame to draw on.
			 * "p" is the point where the line begins.
			 * "q" is the point where the line stops.
			 * "CV_AA" means antialiased drawing.
			 * "0" means no fractional bits in the center cooridinate or radius.
			 */
			//cvLine( frame1, p, q, line_color, line_thickness, CV_AA, 0 );
			
			line_color = CV_RGB(mag,0,255-mag);
			cvRectangle( frame1, p, q, line_color, CV_FILLED, CV_AA, 0 );
			
			/* Now draw the tips of the arrow.  I do some scaling so that the
			 * tips look proportional to the main line of the arrow.
			 */			
			//p.x = (int) (q.x + 9 * cos(angle + pi / 4));
			//p.y = (int) (q.y + 9 * sin(angle + pi / 4));
			//cvLine( frame1, p, q, line_color, line_thickness, CV_AA, 0 );
			//p.x = (int) (q.x + 9 * cos(angle - pi / 4));
			//p.y = (int) (q.y + 9 * sin(angle - pi / 4));
			//cvLine( frame1, p, q, line_color, line_thickness, CV_AA, 0 );
		}





		cvShowImage( name1, frame1 );
		
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
