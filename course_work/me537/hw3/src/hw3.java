import java.io.*;
import java.util.Random;

public class hw3 {
	
	final static int MAXAVE		= 100;
	
	final static float ALPHA	= (float)0.001;
	final static float GAMMA	= (float)0.1;
	final static float EPSILON	= (float)0.1;
	final static double T		= 0.1;
	
	
	static String outputFolder	= "../output/";
	static String inputFolder	= "./input/";
	
	static int walls[][][]		= new int[10][5][4];
	
	static Slot[]	slots		= null;
//	static float[]	Q			= null;
	
	public static void main(String argv[]) throws Exception {	


		System.out.printf("\tME537 HW2\n\n");

		
		System.out.printf("\n\n\t\t\tTesting Part 1!\n");
		slotGreedy (100, "slot_parms.txt");
		slotEGreedy(100, "slot_parms.txt");
		slotSoftMax(100, "slot_parms.txt");
		
		System.out.printf("\n\n\t\t\tTesting Part 2!\n");
		initWalls();
		System.out.printf("greedy\n");
		gridGreedy(1000);
		System.out.printf("e-greedy\n");
		gridEGreedy(1000);
		System.out.printf("softmax\n");
		gridSoftmax(1000);
		System.out.printf("q\n");
		gridQ(1000);
		
		System.out.printf("\n\n\t\t\tDONE!\n");
		
	} // main
	
/////////////////////////////////////////////////////////////////////
// part 2

	
	private static void initWalls() {
		int x,y;
		
		for(x=0;x<10;x++) {
			for(y=0;y<5;y++){
				walls[x][y][0]	= 1;	// up
				walls[x][y][1]	= 1;	// right
				walls[x][y][2]	= 1;	// down
				walls[x][y][3]	= 1;	// left

				if (x == 0)
					walls[x][y][3] = 0;
				else if (x == 9)
					walls[x][y][1] = 0;
			
				if (y == 0)
					walls[x][y][2] = 0;
				else if (y == 4)
					walls[x][y][0] = 0;
			
			}
		}
		
		
		
	}
	
	private static void gridSoftmax(int kMax) {
		String			outFile	= "./output/grid_softmax_";
		BufferedWriter	writer	= null;
		Random			rand 	= new Random();

		float[]			Q		= null;
		float			sum 	= 0;
		float			tmp		= 0;
		
		int				a		= 0;
		float			r		= 0;
		
		int				nSteps	= 0;
		int				x;
		int				boxX;
		int				y;
		int				boxY;
		
//		int[]			p	= null;
		
		int				k		= 0;
		int				i,n;


		// repeat evo MAXAVE times
		for(n=0;n<MAXAVE;n++) {
			
			
			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter(outFile+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}

			// init everything...
			
			// init locations
			boxX = 9;
			boxY = 1;


			nSteps = 0;
			
			// Init Q table with very small random values and zero the hits table
			Q = new float[slots.length];
			for(i=0;i<Q.length;i++) {
				Q[i]	= rand.nextFloat()/100;
//				hits[i]	= 0;
			}
			
			// start algorithm
			for(k=0; k<kMax;k++) {
				
				// reset locations
				x = rand.nextInt(10);
				y = rand.nextInt(5);
				while (x == boxX && y == boxY ) {
					x = rand.nextInt(10);
					y = rand.nextInt(5);
				}

				nSteps = 0;
				while (nSteps < 100 && !(x == boxX && y == boxY) ) {	// try once

					nSteps++;
					
					// choose direction...
					sum = 0;
					for (i=0;i<Q.length;i++) {
						sum = sum + (float)Math.exp(Q[i]/T);
//						System.out.printf("Q[i] %1.3f   %1.4f  sum %1.3f\n",Q[i], Math.exp(Q[i]/T), sum);
					}
					
					a =-1;
					while (a==-1) {
						// pick a random action to look at
						i = rand.nextInt(Q.length);
						tmp = (float) (Math.exp(Q[i]/T)/sum);
						if (rand.nextFloat() < tmp)  // do we use it?
							a = i;
					}
					
//					System.out.printf("step %d\n",nSteps);
					
					// take action
					switch (a) {
					case 0:	y = y + walls[x][y][0]; break; // up
					case 1:	x = x + walls[x][y][1]; break; // right
					case 2:	y = y - walls[x][y][2]; break; // down
					case 3: x = x - walls[x][y][3]; break; // left
					default:	 break; // nothing
					}
					
					// get reward
					if (x == boxX && y == boxY)	// if we're at the box..
						r = 100;
					else
						r = 0;
					
	//				System.out.printf("r: %1.3f\nR: %1.3f\n",r,R);
	
					
					// update Q table
					Q[a] = Q[a] + ALPHA * (r - Q[a]);
					
					
				} // end while
				
				// write to output file...
				try {
					writer.write(String.format("%d\n", nSteps));
				} catch (IOException err) {
					err.printStackTrace();
				}
			} // end for
			
			
			try {							// close output file
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}			
			
			
		} // end AVE for
		
		
	} // end

	private static void gridEGreedy(int kMax) {
		String			outFile	= "./output/grid_eGreedy_";
		BufferedWriter	writer	= null;
		Random			rand 	= new Random();

		float[]			Q		= null;
		int				a		= 0;
		float			r		= 0;
		
		int				nSteps	= 0;
		int				x;
		int				boxX;
		int				y;
		int				boxY;
		
//		int[]			p	= null;
		
		int				k		= 0;
		int				i,n;


		// repeat evo MAXAVE times
		for(n=0;n<MAXAVE;n++) {
			
			
			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter(outFile+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}

			// init everything...
			
			// init locations
			boxX = 9;
			boxY = 1;
			

			nSteps = 0;
			
			// Init Q table with very small random values and zero the hits table
			Q = new float[slots.length];
			for(i=0;i<Q.length;i++) {
				Q[i]	= rand.nextFloat()/100;
//				hits[i]	= 0;
			}
			
			// start algorithm
			for(k=0; k<kMax;k++) {
				
				// reset locations
				x = rand.nextInt(10);
				y = rand.nextInt(5);
				while (x == boxX && y == boxY ) {
					x = rand.nextInt(10);
					y = rand.nextInt(5);
				}
				nSteps = 0;
				while (nSteps < 100 && !(x == boxX && y == boxY) ) {	// try once

					nSteps++;
					
					// choose direction...
					if ((1-EPSILON) < rand.nextFloat())
						a = best(Q);
					else
						a = rand.nextInt(5);
					
					// take action
					switch (a) {
					case 0:	y = y + walls[x][y][0]; break; // up
					case 1:	x = x + walls[x][y][1]; break; // right
					case 2:	y = y - walls[x][y][2]; break; // down
					case 3: x = x - walls[x][y][3]; break; // left
					default:	 break; // nothing
					}


					
					
					// get reward
					if (x == boxX && y == boxY)	// if we're at the box..
						r = 100;
					else
						r = 0;

//					System.out.printf("a: %d  r: %1.3f\n",a,r);
					
	//				System.out.printf("r: %1.3f\nR: %1.3f\n",r,R);
	
					
					// update Q table
					Q[a] = Q[a] + ALPHA * (r - Q[a]);
					
//					if (nSteps>=100)
//						break;
					
				} // end while
				
				// write to output file...
				try {
					writer.write(String.format("%d\n", nSteps));
				} catch (IOException err) {
					err.printStackTrace();
				}
			} // end for
			
			
			try {							// close output file
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}			
			
			
		} // end AVE for
		
		
	} // end
	
	private static void gridGreedy(int kMax) {
		
		String			outFile	= "./output/grid_greedy_";
		BufferedWriter	writer	= null;
		Random			rand 	= new Random();

		float[]			Q		= null;
		int				a		= 0;
		float			r		= 0;
		
		int				nSteps	= 0;
		int				x;
		int				boxX;
		int				y;
		int				boxY;
		
//		int[]			p	= null;
		
		int				k		= 0;
		int				i,n;


		// repeat evo MAXAVE times
		for(n=0;n<MAXAVE;n++) {
			
			
			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter(outFile+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}

			// init everything...
			
			// init locations
			boxX = 9;
			boxY = 1;
			
			nSteps = 0;
			
			// Init Q table with very small random values and zero the hits table
			Q = new float[slots.length];
			for(i=0;i<Q.length;i++) {
				Q[i]	= rand.nextFloat()/100;
//				hits[i]	= 0;
			}
			
			// start algorithm
			for(k=0; k<kMax;k++) {
				
				// reset locations
				x = rand.nextInt(10);
				y = rand.nextInt(5);
				while (x == boxX && y == boxY ) {
					x = rand.nextInt(10);
					y = rand.nextInt(5);
				}

				nSteps = 0;
				while (nSteps < 100 && !(x == boxX && y == boxY) ) {	// try once

					nSteps++;
					
					// choose direction...
					a = best(Q);
					
					// take action
					switch (a) {
					case 0:	y = y + walls[x][y][0]; break; // up
					case 1:	x = x + walls[x][y][1]; break; // right
					case 2:	y = y - walls[x][y][2]; break; // down
					case 3: x = x - walls[x][y][3]; break; // left
					default:	 break; // nothing
					}
					
					// get reward
					if (x == boxX && y == boxY)	// if we're at the box..
						r = 100;
					else
						r = 0;
					
	//				System.out.printf("r: %1.3f\nR: %1.3f\n",r,R);
	
					
					// update Q table
					Q[a] = Q[a] + ALPHA * (r - Q[a]);
					

				} // end while
				
				// write to output file...
				try {
					writer.write(String.format("%d\n", nSteps));
				} catch (IOException err) {
					err.printStackTrace();
				}
			} // end for
			
			
			try {							// close output file
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}			
			
			
		} // end AVE for
		
		
	} // end test

	
	
/////////////////////////////////////////////////////////////////////
	private static void gridQ(int kMax) {
		String			outFile	= "./output/grid_Q_";
		BufferedWriter	writer	= null;
		Random			rand 	= new Random();

		float[][][]		Qt		= new float[10][5][5];	// x,y,a
		
		int				a		= 0;
		float			r		= 0;
		
		int				nSteps	= 0;
		
		int				x;
		int				oldX;
		int				boxX;
		int				y;
		int				oldY;
		int				boxY;
		
//		int[]			p	= null;
		
		int				k		= 0;
		int				i,j,n;


		// repeat evo MAXAVE times
		for(n=0;n<MAXAVE;n++) {
			
			
			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter(outFile+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}

			// init everything...
			
			// init locations
			boxX = 9;
			boxY = 1;

			
			nSteps = 0;
			
			// Init Q table with very small random values and zero the hits table
			for(i=0;i<10;i++) {					// x
				for(j=0;j<5;j++) {				// y
					
					Qt[i][j][0]	= rand.nextFloat()/100;
					Qt[i][j][1]	= rand.nextFloat()/100;
					Qt[i][j][2]	= rand.nextFloat()/100;
					Qt[i][j][3]	= rand.nextFloat()/100;
					Qt[i][j][4]	= rand.nextFloat()/100;
				}
			}
			
			// start algorithm
			for(k=0; k<kMax;k++) {
				
				// reset locations
				x = rand.nextInt(10);
				y = rand.nextInt(5);
				while (x == boxX && y == boxY ) {
					x = rand.nextInt(10);
					y = rand.nextInt(5);
				}

				nSteps = 0;
				while (nSteps < 100 && !(x == boxX && y == boxY) ) {	// try once

					nSteps++;
					
					// choose direction...
					if ((1-EPSILON) < rand.nextFloat())
						a = best(Qt[x][y]);
					else
						a = rand.nextInt(5);
					
					// take action
					oldX = x;
					oldY = y;
					switch (a) {
					case 0:	y = y + walls[x][y][0]; break; // up
					case 1:	x = x + walls[x][y][1]; break; // right
					case 2:	y = y - walls[x][y][2]; break; // down
					case 3: x = x - walls[x][y][3]; break; // left
					default:	 break; // nothing
					}
					
					// get reward
					if (x == boxX && y == boxY)	// if we're at the box..
						r = 100;
					else
						r = 0;
					
	//				System.out.printf("r: %1.3f\nR: %1.3f\n",r,R);
	
					
					// update Q table
					Qt[oldX][oldY][a] = Qt[oldX][oldY][a] + ALPHA * (r + GAMMA*Qt[x][y][best(Qt[x][y])] - Qt[oldX][oldY][a]);
					
					
				} // end while
				
				// write to output file...
				try {
					writer.write(String.format("%d\n", nSteps));
				} catch (IOException err) {
					err.printStackTrace();
				}
			} // end for
			
			
			try {							// close output file
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}			
			
			
		} // end AVE for
		
		
	} // end
	
	
	
////////////////////////////////////////////////////////////////////////	
// part 1
	
	private static void slotSoftMax(int kMax, String inputFile) {
		
		BufferedWriter	writer	= null;
		Random			rand 	= new Random();
		
		float[]			Q		= null;
		int				s		= 0;
		float			r		= 0;
		float			R		= 0;
		float			sum		= 0;
		
		float			tmp		= 0;
		
		int[]			hits	= null;
		
		int				k		= 0;
		int				i,n;


		// repeat evo MAXAVE times
		for(n=0;n<MAXAVE;n++) {
			

			readData(inputFolder+inputFile);

			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter("./output/softmax_"+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}

			// init everything...
			if (hits == null)
				hits	= new int[slots.length];
			
			// zero reward total
			R = 0;
			
			// Init Q table with very small random values and zero the hits table
			Q = new float[slots.length];
			for(i=0;i<Q.length;i++) {
				Q[i]	= rand.nextFloat()/100;
				hits[i]	= 0;
			}
			
			// start algorithm
			for(k=0; k<kMax;k++) {

				// choose slot to try...
				sum = 0;
				for (i=0;i<Q.length;i++) {
					sum += Math.exp(Q[i]/T);
				}
				
				s =-1;
				while (s==-1) {
					// pick a random action to look at
					i = rand.nextInt(Q.length);
					tmp = (float) (Math.exp(Q[i]/T)/sum);
					if (rand.nextFloat() < tmp)  // do we use it?
						s = i;
				}
				
				hits[s] ++;
				
				// get reward
				r  = slots[s].pull();
				R += r;
//				System.out.printf("r: %1.3f\nR: %1.3f\n",r,R);

				
				// update Q table
				Q[s] = Q[s] + ALPHA * (r - Q[s]);
				
				
				// write to output file...
				try {
					writer.write(String.format("%1.3f\n", R));
				} catch (IOException err) {
					err.printStackTrace();
				}
				
			} // end for
			
			
			try {							// close output file
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}
						
			// write hit table
			try {
				writer = new BufferedWriter(new FileWriter("./output/softmax_hits_"+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
				
				for (i=0;i<hits.length;i++) {
					writer.write(String.format("%d\t%d\n",slots[i].id, hits[i]));
				}
				writer.close();
				
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}
			
			
			
		} // end AVE for
		
		
	} // end test

	private static void slotEGreedy(int kMax, String inputFile) {
		
		BufferedWriter	writer	= null;
		Random			rand 	= new Random();
		
		float[]			Q		= null;
		int				s		= 0;
		float			r		= 0;
		float			R		= 0;
		
		int[]			hits	= null;
		
		int				k		= 0;
		int				i,n;


		// repeat evo MAXAVE times
		for(n=0;n<MAXAVE;n++) {
			

			readData(inputFolder+inputFile);

			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter("./output/e_greedy_"+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}

			// init everything...
			if (hits == null)
				hits	= new int[slots.length];
			
			// zero reward total
			R = 0;
			
			// Init Q table with very small random values and zero the hits table
			Q = new float[slots.length];
			for(i=0;i<Q.length;i++) {
				Q[i]	= rand.nextFloat()/100;
				hits[i]	= 0;
			}
			
			// start algorithm
			for(k=0; k<kMax;k++) {

				// choose slot to try...
				if ((1-EPSILON) < rand.nextFloat())
					s = best(Q);
				else
					s = rand.nextInt(slots.length);
				
				hits[s] ++;
				
				// get reward
				r  = slots[s].pull();
				R += r;
//				System.out.printf("r: %1.3f\nR: %1.3f\n",r,R);

				
				// update Q table
				Q[s] = Q[s] + ALPHA * (r - Q[s]);
				
				
				// write to output file...
				try {
					writer.write(String.format("%1.3f\n", R));
				} catch (IOException err) {
					err.printStackTrace();
				}
				
			} // end for
			
			
			try {							// close output file
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}
						
			// write hit table
			try {
				writer = new BufferedWriter(new FileWriter("./output/e_greedy_hits_"+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
				
				for (i=0;i<hits.length;i++) {
					writer.write(String.format("%d\t%d\n",slots[i].id, hits[i]));
				}
				writer.close();
				
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}
			
			
			
		} // end AVE for
		
		
	} // end test evo
	
	private static void slotGreedy(int kMax, String inputFile) {
////////////////////////////////////////////////////////////////////////
		
		BufferedWriter	writer	= null;
		Random			rand 	= new Random();

		float[]			Q		= null;
		int				s		= 0;
		float			r		= 0;
		float			R		= 0;
		
		int[]			hits	= null;
		
		int				k		= 0;
		int				i,n;


		// repeat evo MAXAVE times
		for(n=0;n<MAXAVE;n++) {
			

			readData(inputFolder+inputFile);

			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter("./output/greedy_"+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}

			// init everything...
			if (hits == null)
				hits	= new int[slots.length];
			
			// zero reward total
			R = 0;
			
			// Init Q table with very small random values and zero the hits table
			Q = new float[slots.length];
			for(i=0;i<Q.length;i++) {
				Q[i]	= rand.nextFloat()/100;
				hits[i]	= 0;
			}
			
			// start algorithm
			for(k=0; k<kMax;k++) {

				// choose slot to try...
				s = best(Q);
				hits[s] ++;
				
				// get reward
				r  = slots[s].pull();
				R += r;
//				System.out.printf("r: %1.3f\nR: %1.3f\n",r,R);

				
				// update Q table
				Q[s] = Q[s] + ALPHA * (r - Q[s]);
				
				
				// write to output file...
				try {
					writer.write(String.format("%1.3f\n", R));
				} catch (IOException err) {
					err.printStackTrace();
				}
				
			} // end for
			
			
			try {							// close output file
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}
						
			// write hit table
			try {
				writer = new BufferedWriter(new FileWriter("./output/greedy_hits_"+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
				
				for (i=0;i<hits.length;i++) {
					writer.write(String.format("%d\t%d\n",slots[i].id, hits[i]));
				}
				writer.close();
				
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}
			
			
			
		} // end AVE for
		
		
	} // end test evo

	
	// find index of highest Q value
	private static int best(float[] Qa) {
		int i;
		int best = 0;

		for(i=0;i<Qa.length;i++) {			
			if (Qa[i] > Qa[best]) {
				best = i;
			}
		}
		return best;
	}
	
	private static void readData(String file){
		
		BufferedReader	reader	= null;
		String			line	= null;
		String[]		tokens;
		int				i, nS;
		
		
		try {
			reader = new BufferedReader(new FileReader(file));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		
		// read in the inputs...
		try {
			line = reader.readLine();
			tokens = line.split("[ \\s]+");
			//Is this the first line of the file?
			if(tokens.length != 1)
				System.out.println("Malformed File!");
			
			//Get the data length
			nS = Integer.parseInt(tokens[0]);

			slots = new Slot[nS];


			// read in the inputs and expected outputs
			for(i=0; i < nS; i++){
				line = reader.readLine();
				tokens = line.split("[ \\s]+");

				// id, mu, sigma
				slots[i] = new Slot(i, Float.parseFloat(tokens[0]), Float.parseFloat(tokens[1]));
			}
			
		} catch (IOException e) {e.printStackTrace();}

		try {
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	
}
	
	
