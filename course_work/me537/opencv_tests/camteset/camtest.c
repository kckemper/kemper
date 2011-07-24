#include "highgui.h"
#include "cv.h"




int high_switch_value	= 0;
int highInt				= 0;
int low_switch_value	= 0;
int lowInt				= 2;

int blur				= 6*2+1;

void switch_callback_h( int position ){
	highInt = position;
}
void switch_callback_l( int position ){
	lowInt = position;
}
void switch_callback_g( int position ){
	blur = position*2+1;
}

int main( int argc, char** argv ) {
	
	const char* name1 = "ESC to stop";
	const char* options = "Options";


	char c;
	int toggle_can	= 0;
	int toggle_sob	= 0;
	int toggle_orig	= 1;



	int N = 7;

	int aperature_size = N;
	double lowThresh = 20;
	double highThresh = 40;

	CvCapture* capture = cvCreateCameraCapture(0) ;
	
	IplImage* frame;
	IplImage* frame_g;
	IplImage* frame_b;
	IplImage* out_can;
	IplImage* out_sob;
	IplImage* out_sobU;
	IplImage* final_can;
	IplImage* final_sob;
	IplImage* final;
	
	CvPoint offset = cvPoint((N-1)/2,(N-1)/2);
	
	cvNamedWindow( name1, CV_WINDOW_AUTOSIZE );
	cvNamedWindow( options, CV_WINDOW_AUTOSIZE );

	frame = cvQueryFrame( capture );
	if( !frame ) return 0;

	
	frame_g	= cvCreateImage( cvSize(frame->width,frame->height), frame->depth, 0 );
	cvCvtColor(frame,frame_g,CV_BGR2GRAY);
	
	frame_b	= cvCreateImage( cvSize(frame_g->width+N-1,frame_g->height+N-1), frame_g->depth, frame_g->nChannels );
	out_can		= cvCreateImage( cvGetSize(frame_b), IPL_DEPTH_8U, frame_b->nChannels );
	out_sob		= cvCreateImage( cvGetSize(frame_b), IPL_DEPTH_16S, frame_b->nChannels );
	out_sobU	= cvCreateImage( cvGetSize(out_sob), IPL_DEPTH_8U, out_sob->nChannels );
	
	final_can	= cvCreateImage( cvGetSize(frame), IPL_DEPTH_8U, frame->nChannels );
	final_sob	= cvCreateImage( cvGetSize(frame), IPL_DEPTH_8U, frame->nChannels );

	final		= cvCreateImage( cvGetSize(frame), IPL_DEPTH_8U, frame->nChannels );

	// Create trackbars
	cvCreateTrackbar( "High", options, &high_switch_value, 4, switch_callback_h );
	cvCreateTrackbar( "Low", options, &low_switch_value, 4, switch_callback_l );
	cvCreateTrackbar( "Gaussian", options, &blur, 20, switch_callback_g );


	while(1) {
	
		switch( highInt ){
			case 0:
				highThresh = 200;
				break;
			case 1:
				highThresh = 400;
				break;
			case 2:
				highThresh = 600;
				break;
			case 3:
				highThresh = 800;
				break;
			case 4:
				highThresh = 1000;
				break;
		}
		
		switch( lowInt ){
			case 0:
				lowThresh = 0;
				break;
			case 1:
				lowThresh = 100;
				break;
			case 2:
				lowThresh = 200;
				break;
			case 3:
				lowThresh = 400;
				break;
			case 4:
				lowThresh = 600;
				break;
		}
	
		frame = cvQueryFrame( capture );
		if( !frame ) break;
		
		cvCvtColor(frame,frame_g,CV_BGR2GRAY);
		
		cvSmooth( frame_g, frame_g, CV_GAUSSIAN, blur, blur );

		cvCopyMakeBorder(frame_g, frame_b, offset, IPL_BORDER_REPLICATE, cvScalarAll(0));

		cvCanny(frame_b, out_can, lowThresh*N*N, highThresh*N*N, aperature_size);
		cvSobel(frame_b,out_sob,highInt,lowInt,N);
		cvConvertScaleAbs(out_sob,out_sobU,1,0);


		cvDilate(out_can,out_can,NULL,2);
		cvSmooth(out_can,out_can, CV_GAUSSIAN, 23, 23 );


		cvConvertImage(out_can,final_can);
		cvConvertImage(out_sobU,final_sob);
		
		cvSet(final, cvScalar(0,0,0));
		if (toggle_orig == 1)
			cvAdd(frame, final, final, NULL);

		if (toggle_can == 1)
			cvAdd(final_can, final, final, NULL);

		if (toggle_sob == 1)
			cvAdd(final_sob, final, final, NULL);


		cvShowImage( name1, final );
		
		c = cvWaitKey(5);
		
		if( c == 27 ) break;
		else if (c == ',') toggle_can = 0;
		else if (c == '.') toggle_can = 1;
		else if (c == '[') toggle_sob = 0;
		else if (c == ']') toggle_sob = 1;
		else if (c == ';') toggle_orig = 0;
		else if (c == '\'') toggle_orig = 1;


	}

	cvReleaseCapture( &capture );
	cvDestroyWindow( name1 );
	cvDestroyWindow( options );
}
