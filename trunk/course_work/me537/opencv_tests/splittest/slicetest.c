#include <stdio.h>
#include <cv.h>
#include <highgui.h>
#include <math.h>

#define NF			6
#define N_SLICES	8




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
	const char* name_slice0	= "Slice0";
	const char* name_slice9	= "Slice9";
	const char* name_ave	= "Original ave frame";

	
	CvCapture* capture = cvCreateCameraCapture(0) ;
		
	CvSize frame_size;
	CvScalar ave = cvScalar(1);
	
	
	CvRect  slice_rect;
	CvSize	slice_size;

	static IplImage * frame					= NULL;
	static IplImage * frame_g				= NULL;
	static IplImage * frame_small			= NULL;

	
	static IplImage	*ave_image				= NULL;
//	static IplImage *scale					= NULL;
	
	static IplImage *frame_slices[N_SLICES];

	char c;
	int i = 0;

////////////////////////////////////////////////////////////////////////////////
// init stuff
	cvNamedWindow( name_slice9, CV_WINDOW_AUTOSIZE );	
	cvNamedWindow( name_slice0, CV_WINDOW_AUTOSIZE );
	cvNamedWindow( name_ave, CV_WINDOW_AUTOSIZE );


//	frame_size	= cvSize(frame->width,frame->height);
	frame_size	= cvSize(128,128);

	// capture a frame so we can get an idea of the size of the source
	frame = cvQueryFrame( capture );
	if( !frame ) return 0;


	allocateOnDemand( &frame_g, cvSize(frame->width,frame->height), IPL_DEPTH_8U, 1 );
	
	allocateOnDemand( &ave_image, frame_size, IPL_DEPTH_8U, 1 );
	allocateOnDemand( &frame_small, frame_size, IPL_DEPTH_8U, 1 );


	slice_size = cvSize(ave_image->width/N_SLICES, ave_image->height);


	while(1) {

////////////////////////////////////////////////////////////////////////////////
// Pre processing		

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


//		cvDilate(ave_image, ave_image,NULL,4);


////////////////////////////////////////////////////////////////////////////////
// Generate NN inputs


		for (i=0;i<N_SLICES;i++) {
	
			slice_rect = cvRect(i*ave_image->width/N_SLICES, 0, ave_image->width/N_SLICES, ave_image->height);

			allocateOnDemand( &frame_slices[i], slice_size, IPL_DEPTH_8U, 1);

			cvSetImageROI(ave_image, slice_rect);
				
			cvCopy(ave_image, frame_slices[i], NULL);

		}


		cvResetImageROI(ave_image);  // remove this when we don't care about looking at the ave

////////////////////////////////////////////////////////////////////////////////
// Evaluate NN

//img(x,y)		((uchar*)(img->imageData + img->widthStep*y))[x]



////////////////////////////////////////////////////////////////////////////////
// GUI stuff

		cvShowImage( name_ave, ave_image );
		cvShowImage( name_slice0, frame_slices[0] );
		cvShowImage( name_slice9, frame_slices[N_SLICES-1] );

		
		c = cvWaitKey(5);
		
		if( c == 27 ) break;
		else if( c == 'q') {
			cvSaveImage("output.jpg",ave_image);
			cvSaveImage("input.jpg",frame);
		}

	} // end while


// clean up
	cvReleaseCapture( &capture );
	cvDestroyWindow( name_ave );
	cvDestroyWindow( name_slice0 );
	cvDestroyWindow( name_slice9 );
}
