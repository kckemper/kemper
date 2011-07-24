#include <stdio.h>
#include <time.h>

#include "highgui.h"
#include "cv.h"

#define PIX(img,x,y) ((uchar*)((img)->imageData + (img)->widthStep*(y)))[(x)]


int rate	= 5;
int thresh	= 50;

void switch_callback_rate( int position ){
	if (position < 2)
		position = 2;
	rate = position;
}

void switch_callback_thresh( int position ){
	thresh = position;
}

int main( int argc, char** argv ) {
	
	const char* name1 	= "ESC to stop";
	const char* options = "Options";

	CvPoint		p,q;
	CvScalar	out_color;
	CvFont		font;
	
	char c;
	int flag			= 0;
	int toggle_pause	= 1;
	float ave, sum;
	int i,j,k;

	CvCapture* capture = cvCreateCameraCapture(0) ;

	
	IplImage* frame;
	
	cvNamedWindow( name1, CV_WINDOW_AUTOSIZE );
	cvNamedWindow( options, CV_WINDOW_AUTOSIZE );



	out_color = CV_RGB(255,0,0);

	cvInitFont(&font, CV_FONT_HERSHEY_SIMPLEX, 2.0, 2.0, 0, 5, CV_AA);


	frame = cvQueryFrame( capture );
	if( !frame ) return 0;


	CvSize size = cvSize( (int)cvGetCaptureProperty( capture, CV_CAP_PROP_FRAME_WIDTH), (int)cvGetCaptureProperty( capture, CV_CAP_PROP_FRAME_HEIGHT) );	


	CvVideoWriter *writer = cvCreateVideoWriter( "out.avi", CV_FOURCC('D', 'I', 'V', 'X'), 30, size );


	// Create trackbars
	cvCreateTrackbar( "Rate (seconds)", options, &rate, 120, switch_callback_rate );
	cvCreateTrackbar( "Threshold (0-255)", options, &thresh, 120, switch_callback_thresh );


	while(1) {

	
// capture frame	
		frame = cvQueryFrame( capture );
		if( !frame ) break;


//		printf("time %d\n",(int)time(NULL));		
		if ((int)time(NULL)%rate != 0) {		// if not 0
			flag = 1;
		}
		else if (flag == 1) {

			// determine if image is too dark...
			i = 0;
			ave = 0;
			sum = 0;
			for(j=0;j<frame->height;j++) {
				for(k=0;k<frame->width;k++) {
					sum += (float)PIX(frame,k,j);
					i++;
				}
			}
			ave = sum/i;


			printf("time %d,  ave %1.3f,  thresh %d\n",(int)time(NULL),ave,thresh);


			if ((toggle_pause == 0) && (ave > thresh)) {
				cvWriteFrame( writer, frame );
			
				p.x = (int)(10);
				p.y = (int)(10);
				q.x = (int)(20);
				q.y = (int)(20);
				cvRectangle( frame, p, q, out_color, CV_FILLED, CV_AA, 0 );
			}
			else if (toggle_pause == 1) {

				p.x = (int)(frame->width/2-100);
				p.y = (int)(frame->height/2);
				cvPutText(frame, "PAUSED", p, &font, out_color);
			
			}

			cvShowImage( name1, frame );

			flag = 0;
		}

				
		c = cvWaitKey(10);
		
		if( c == 27 ) break;
		else if (c == 'p') toggle_pause = 1;
		else if (c == 'u') toggle_pause = 0;

	}

	cvReleaseVideoWriter( &writer );
	cvReleaseCapture( &capture );
	cvDestroyWindow( name1 );
	cvDestroyWindow( options );
}
