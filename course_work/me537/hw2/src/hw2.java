import javax.swing.*;
import java.io.*;
import java.util.Random;

public class hw2 {
	
	final static int MAXAVE		= 100;
	
	static int nC				= 0;
	

	static String outputFolder	= "../output/";
	static String inputFolder	= "./input/";
	
	static City[]	C = null;
	
	public static void main(String argv[]) throws Exception {	
		

		System.out.printf("\tME537 HW2\n\n");

		
		System.out.printf("\n\n\t\t\tTESTING SA!\n");
		System.out.printf("T10\n");
		testSA(500, "T10");
		System.out.printf("T20\n");
		testSA(500, "T20");
		System.out.printf("T20A\n");
		testSA(500, "T20A");
		System.out.printf("T100\n");
		testSA(1000, "T100");

		System.out.printf("\n\n\t\t\tTESTING EVO!\n");
		System.out.printf("T10\n");
		testEvo(500, "T10");
		System.out.printf("T20\n");
		testEvo(500, "T20");
		System.out.printf("T20A\n");
		testEvo(500, "T20A");
		System.out.printf("T100\n");
		testEvo(1000, "T100");

		
		System.out.printf("\n\n\t\t\tDONE!\n");
		
	} // main
	
	
	
	
	private static void testEvo(int kMax, String inputFile) {
		
		BufferedWriter	writer	= null;
		Random			rand 	= new Random();
		City			tmp		= null;

		City			s[][]	= null;
		City			sNew[]	= null;
		float			eNew	= 0;

		float			eps		= 0;
		
		int				pop		= 10;
		int				k		= 0;
		
		int				randIndex;				
		int				i,j,n;		


		// repeat evo MAXAVE times
		for(n=0;n<MAXAVE;n++) {
			

			readData(inputFolder+inputFile);

			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter("./output/evo_"+inputFile+"_"+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
				writer.write(String.format("%d\n", nC));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}

			// init everything...
			
			// make random population
			s = new City[pop][];
			for(i=0;i<pop;i++) {
				// shuffle the data into some random state
				for(j=0;j<nC;j++) {					
					randIndex = rand.nextInt(nC);
					tmp = C[j];
					C[j] = C[randIndex];
					C[randIndex] = tmp;	
				}

				s[i]	= C.clone();
				
			}
			
			
			for(k=0; k<kMax;k++) {
//				System.out.printf("k: %d\n",k);
				
				// choose individual from pop
				if ((1-eps) < rand.nextFloat()) // choose best
					sNew	= s[best(s)].clone();

				else 	// choose random
					sNew	= s[rand.nextInt(s.length)].clone();
				
				
				// mutate
				sNew	= neighbour(sNew);
				
				// evaluate
				eNew	= energy(sNew);
				
				// replace worst or discard
				if ( energy(s[worst(s)]) > eNew)	// replace
					s[worst(s)] = sNew.clone();


//				System.out.printf("eBest: %1.3f\teNew: %1.3f\n\n",eBest,eNew);
				
				try {
					writer.write(String.format("%1.3f\n",energy(s[best(s)])));
				} catch (IOException err) {
					err.printStackTrace();
				}
				
			} // end for
			
			
			try {	
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}
			
			
			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter("./output/evo_"+inputFile+"_best_"+String.valueOf(n)));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}
			
			
			try {
				for (i=0;i<s[best(s)].length;i++) {
					writer.write(String.format("%d\n", s[best(s)][i].id));
				}
					
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}
			
			
		} // end AVE for
		
		
	} // end test evo
	

	private static void testSA(int kMax, String inputFile) {
		
		BufferedWriter	writer	= null;
		Random			rand 	= new Random();
		City			tmp		= null;

		City			s[]		= null;
		City			sBest[]	= null;
		City			sNew[]	= null;
		float			e		= 0;
		float			eBest	= 0;
		float			eNew	= 0;

		float			T		= 0;
		
		int				k		= 0;
		int				eMax	= 1000;
		
		int				randIndex;				
		int				i,j,n;		


		// repeat SA MAXAVE times
		for(n=0;n<MAXAVE;n++) {
			

			readData(inputFolder+inputFile);

			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter("./output/sa_"+inputFile+"_"+String.valueOf(n)));
				writer.write(String.format("%d\n", MAXAVE ));
				writer.write(String.format("%d\n", nC));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}

			// shuffle the data into some random state
			for(j=0;j<C.length;j++) {					
				randIndex = rand.nextInt(C.length);
				tmp = C[j];
				C[j] = C[randIndex];
				C[randIndex] = tmp;	
			}
			
			// init everything...
			
			s		= C.clone();
			sBest	= s.clone();
			
			e		= Float.POSITIVE_INFINITY;
			eBest	= e;
			
			T		= 1000;
			for(k=0; (k<kMax) && (e>eMax);k++) {
//				System.out.printf("k: %d\n",k);
				
				sNew	= neighbour(s);
				eNew	= energy(sNew);

				if (eNew < eBest) {
					sBest = sNew.clone();
					eBest = eNew;
					// move to it?
				}
				if ( Math.exp((e-eNew)/T) > rand.nextFloat() ) {
					s = sNew.clone();
					e = eNew;
				}
				
				T *= (kMax-k)/kMax;

//				System.out.printf("eBest: %1.3f\teNew: %1.3f\n\n",eBest,eNew);
				
				try {
					writer.write(String.format("%1.3f\n",eBest));
				} catch (IOException err) {
					err.printStackTrace();
				}
				
			} // end for
			
			
			try {	
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}
			
			
			// open the files for use'n
			try {
				writer = new BufferedWriter(new FileWriter("./output/sa_"+inputFile+"_best_"+String.valueOf(n)));
			} catch (FileNotFoundException err) {
				err.printStackTrace();
			} catch (IOException err) {
				err.printStackTrace();
			}
			
			
			try {
				for (i=0;i<sBest.length;i++) {
					writer.write(String.format("%d\n", sBest[i].id));
				}
					
				writer.close();
			} catch (IOException err) {
				err.printStackTrace();
			}
			
			
		} // end AVE for
		
		
	} // end test SA
	
	
	// find the total distance for the full path and return it as the "energy"
	private static float energy(City[] s) {
		int i;
		float dist = 0;
		
		for (i=0;i<(s.length-1);i++) {
			
			dist += (float)Math.sqrt( (double)((s[i].x - s[i+1].x)*(s[i].x - s[i+1].x) + (s[i].y - s[i+1].y)*(s[i].y - s[i+1].y) ) );
			
		}
		
		// end->start
		dist += (float)Math.sqrt( (double)((s[i].x-s[0].x)*(s[i].x-s[0].x) + (s[i].y-s[0].y)*(s[i].y-s[0].y) ) );
		
		
		return dist;
	}
	
	
	// shuffle two cities in the list
	private static City[] neighbour(City[] s) {
		City tmp;
		City ret[] = s.clone();
		Random rand = new Random();
		int rI;
		Boolean x	= rand.nextBoolean();
				
		if (x) { // move positive
			rI	= rand.nextInt(ret.length-1);
			tmp = ret[rI];
			ret[rI] = ret[rI+1];
			ret[rI+1] = tmp;
		}
		else { // move negative
			rI	= 1+rand.nextInt(ret.length-1);
			tmp = ret[rI];
			ret[rI] = ret[rI-1];
			ret[rI-1] = tmp;
		}
		return ret;
	}
	

	// find highest energy path
	private static int worst(City s[][]) {
		int i;
		int worst = 0;

		for(i=0;i<s.length;i++) {			
			if (energy(s[i]) > energy(s[worst])) {
				worst = i;
			}
		}
		
		return worst;
	}
	
	// find lowest energy path
	private static int best(City s[][]) {
		int i;
		int best = 0;

		for(i=0;i<s.length;i++) {			
			if (energy(s[i]) < energy(s[best])) {
				best = i;
			}
		}
		
		return best;
	}
	
	
	
	
	private static void readData(String file){
		
		BufferedReader reader	= null;
//		BufferedWriter writer	= null;
		String line				= null;
		String[] tokens;
		
		int i;
		
		try {
			reader = new BufferedReader(new FileReader(file));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		
		// read in the inputs...
		try {
			line = reader.readLine();
			tokens = line.split("[ \\t]+");
			//Is this the first line of the file?
			if(tokens.length != 1)
				System.out.println("Malformed File!");
			
			//Get the data length
			nC = Integer.parseInt(tokens[0]);
//			System.out.printf("dataLength=%d\n",dataLength);
			C = new City[nC];


			// read in the inputs and expected outputs
			for(i=0; i < nC; i++){
				line = reader.readLine();
				tokens = line.split("[\\s]+");
//				System.out.printf("line: %s\n",line);

				C[i] = new City(i, Float.parseFloat(tokens[1]), Float.parseFloat(tokens[2]));
//				System.out.printf("\t%d\t%1.4f\t%1.4f\n", C[i].id, C[i].x, C[i].y);
			}
			
		} catch (IOException e) {e.printStackTrace();}

		try {
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	
}
	
	
