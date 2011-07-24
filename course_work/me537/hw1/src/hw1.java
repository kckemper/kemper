import javax.swing.*;
import java.io.*;
import java.util.Random;

public class hw1 {
	
	final static int MAXAVE		= 100;
	final static int MAXHIDDEN	= 5;
	
	final static int N_INPUTS	= 2;
	final static int N_OUTPUTS	= 2;
	
	static int nHidden			= 1;
	
	static float eta			= (float) 0.01;
	
	static NNetwork net;
	static UpdateGraphics ug1;
	
	static String outputFile	= "./y.out";
	
	static float[][]	x = null;
	static int[][]		y = null;
	
	
	public static void main(String argv[]) throws Exception {	
		
		final int WINX = 600;
		final int WINY = 400;

		
		System.out.printf("\tME537 HW1\n\n");

		// set up the graphics stuff...
		JFrame drawNNframe = new JFrame("Neural Network");
		drawNNframe.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		System.out.printf("setting up graphics update handles...\n");
		ug1 = new UpdateGraphics(drawNNframe,100,0);
		
		JPanel drawNNpanel = new DrawNetwork(net,ug1);
		drawNNframe.getContentPane().add(drawNNpanel);
		
		System.out.printf("Displaying the windows...\n");
		drawNNframe.setLocation(0,WINY+50);
		drawNNframe.setSize(WINX, WINY);
		drawNNframe.setVisible(true);
		
		ug1.start();
		
		System.out.printf("\n\n\t\t\tTESTING HIDDEN!\n");
		eta = (float)0.01;
//		testHiddens(MAXHIDDEN);
		
		System.out.printf("\n\n\t\t\tTESTING ETA!\n");	
		nHidden = 4;
		testEta((float)0.001,(float)0.05,5);
		
		System.out.printf("\n\n\t\t\tDONE!\n");
		
	} // main
	
	
	private static void testEta(float minEta, float maxEta, int etaSteps) {
		
		BufferedWriter writer	= null;
		Random rand = new Random();

		float[]	tmpX;
		int[]	tmpY;
		int randIndex;

		float ccp		= 0;
		float test1CPP	= 0;
		float test2CPP	= 0;
		float test3CPP	= 0;
		
		int maxEpochs	= 500;
		int i,j,n,ei;
		
		for(ei=0;ei<etaSteps;ei++) {
			eta = minEta+((maxEta-minEta)/(etaSteps-1))*ei;
			//net = new NNetwork(N_INPUTS,nHidden,N_OUTPUTS);
			//ug1.setNet(net);

			System.out.printf("# Eta step: %d\n",ei);
			
			for(n=0;n<MAXAVE;n++) {
				
				net = new NNetwork(N_INPUTS,nHidden,N_OUTPUTS);
				ug1.setNet(net);
				
				// open the files for use'n
				try {
					writer = new BufferedWriter(new FileWriter("./output/eta_"+String.valueOf(ei)+"_"+String.valueOf(n)));
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				
				try {
					writer.write(String.format("%d\n", MAXAVE ));
					writer.write(String.format("%d\n", etaSteps ));
					writer.write(String.format("%1.3f\n", eta ));
				} catch (IOException e) {
					e.printStackTrace();
				}
			
				
				for(i=0;i<maxEpochs;i++) {
	//				System.out.printf("Epoch: %d\n",i);
					
					readData("d1.train");
					// shuffle the data...
					for(j=0;j<x.length;j++) {
						
						randIndex = rand.nextInt(x.length);
						
						tmpX = x[j];
						tmpY = y[j];
						
						x[j] = x[randIndex];
						y[j] = y[randIndex];
						
						x[randIndex] = tmpX;
						y[randIndex] = tmpY;
		
					}
					
					ccp = loopOverData(true);
					
					readData("d1.test");
					test1CPP = loopOverData(false);
					
					readData("d2.test");
					test2CPP = loopOverData(false);
					
					readData("d3.test");
					test3CPP = loopOverData(false);
					
					try {
						writer.write(String.format("%d\t%1.3f\t%1.3f\t%1.3f\t%1.3f\n", i,ccp,test1CPP,test2CPP,test3CPP ));
					} catch (IOException e) {
						e.printStackTrace();
					}
					
				} // end for
				
				try {
					writer.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			} // end for
		} // end hidden for
		
		
		
	} // end test eta
	
	
	private static void testHiddens(int maxHidden) {
		
		BufferedWriter writer	= null;
		Random rand = new Random();
		
		float[]	tmpX;
		int[]	tmpY;
		int randIndex;

		float ccp		= 0;
		float test1CPP	= 0;
		float test2CPP	= 0;
		float test3CPP	= 0;
		
		int maxEpochs	= 500;
		int i,j,n,h;
		
		for(h=1;h<=maxHidden;h++) {
			nHidden = h;
			//net = new NNetwork(N_INPUTS,nHidden,N_OUTPUTS);
			//ug1.setNet(net);

			System.out.printf("# Hidden: %d\n",h);
			
			for(n=0;n<MAXAVE;n++) {
				
				net = new NNetwork(N_INPUTS,nHidden,N_OUTPUTS);
				ug1.setNet(net);
				
				// open the files for use'n
				try {
					writer = new BufferedWriter(new FileWriter("./output/hidden_"+String.valueOf(h)+"_"+String.valueOf(n)));
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				
				try {
					writer.write(String.format("%d\n", MAXAVE ));
					writer.write(String.format("%d\n", maxHidden ));
					writer.write(String.format("%1.3f\n", eta ));
				} catch (IOException e) {
					e.printStackTrace();
				}
			
				
				for(i=0;i<maxEpochs;i++) {
	//				System.out.printf("Epoch: %d\n",i);
					
					readData("d1.train");
					// shuffle the data...
					for(j=0;j<x.length;j++) {
						
						randIndex = rand.nextInt(x.length);
						
						tmpX = x[j];
						tmpY = y[j];
						
						x[j] = x[randIndex];
						y[j] = y[randIndex];
						
						x[randIndex] = tmpX;
						y[randIndex] = tmpY;
		
					}
					
					ccp = loopOverData(true);
					
					readData("d1.test");
					test1CPP = loopOverData(false);
					
					readData("d2.test");
					test2CPP = loopOverData(false);
					
					readData("d3.test");
					test3CPP = loopOverData(false);
					
					try {
						writer.write(String.format("%d\t%1.3f\t%1.3f\t%1.3f\t%1.3f\n", i,ccp,test1CPP,test2CPP,test3CPP ));
					} catch (IOException e) {
						e.printStackTrace();
					}
					
				} // end for
				
				try {
					writer.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			} // end for
		} // end hidden for
		
		
		
	} // end test hiddens
	
	
	
	private static void readData(String file){
		
		BufferedReader reader	= null;
//		BufferedWriter writer	= null;
		String line				= null;
		String[] tokens;
		
		int dataLength = 0;
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
			dataLength = Integer.parseInt(tokens[0]);
//			System.out.printf("dataLength=%d\n",dataLength);
			x = new float[dataLength][N_INPUTS];
			y = new int[dataLength][N_OUTPUTS];


			// read in the inputs and expected outputs
			for(i=0; i < dataLength; i++){
				line = reader.readLine();
				tokens = line.split("[\\s]+");
//				System.out.printf("line: %s\n",line);

				x[i][0] = Float.parseFloat(tokens[1]);
				x[i][1] = Float.parseFloat(tokens[2]);
				y[i][0] = Integer.parseInt(tokens[3]);
				y[i][1] = Integer.parseInt(tokens[4]);

//				System.out.printf("\t%1.4f\t%1.4f\t%d %d\n",x[i][0],x[i][1],y[i][0],y[i][1]);
			}
			
		} catch (IOException e) {e.printStackTrace();}

		try {
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	
	private static float loopOverData(Boolean train) {
		
//		BufferedWriter writer	= null;
		
		float[]		inputs			= new float[N_INPUTS];
		float[]		hiddens			= new float[nHidden];
		float[]		outputs			= new float[N_OUTPUTS];
		
		float[]		errors			= new float[N_OUTPUTS];
		float[]		deltas_out		= new float[N_OUTPUTS];
		float[]		deltas_hidden	= new float[nHidden]; 
		
		float[][]	delJ_out		= new float[nHidden][N_OUTPUTS];
		float[][]	delJ_hidden		= new float[N_INPUTS][nHidden];

		float[] w				= null;
		
		float	sum;
		
		float	ccp = 0;
		
		int i,j,u,v;

		int tmp0,tmp1;
		
		
		
//		try {
//			writer = new BufferedWriter(new FileWriter(outputFile));
//		} catch (FileNotFoundException e) {
//			e.printStackTrace();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
		
		
		// loop over training data...
		for (i=0;i<x.length;i++) {
			inputs = x[i];

			outputs = net.run( inputs );
			
			if (train) {
				
				hiddens = net.getHiddens();
				
				// compute errors and compute output deltas...
				for(v=0;v<N_OUTPUTS;v++) {
					errors[v]		= outputs[v] - y[i][v];
					deltas_out[v]	= errors[v]*outputs[v]*(1-outputs[v]);
				}
				
				// compute hidden deltas...
				for(u=0;u<nHidden;u++) {
					sum = 0;
					for(v=0;v<N_OUTPUTS;v++) {
						w = net.getWeightsOutputs(v);
						sum += w[u]*deltas_out[v];
					}
					deltas_hidden[u] = hiddens[u]*(1-hiddens[u])*sum;
				}
				
				// compute gradient: hidden->output...
				for(u=0;u<nHidden;u++) {
					for(v=0;v<N_OUTPUTS;v++) {
						delJ_out[u][v]	= deltas_out[v]*hiddens[u];
					}
				}
				
				// compute gradient: input->hidden...
				for(u=0;u<nHidden;u++) {
					for(j=0;j<N_INPUTS;j++) {
						delJ_hidden[j][u]	= deltas_hidden[u]*inputs[j];
					}
				}
				
				// take gradient step for output node weights...
				for(v=0;v<N_OUTPUTS;v++) {
					
					w = net.getWeightsOutputs(v);
					w[0] = w[0] - eta*deltas_out[v];
					for(u=0;u<nHidden;u++) {
						w[u+1] = w[u+1] - eta*delJ_out[u][v];
					}
					net.setWeightsOutputs(v, w);
				}
				
				// take gradient step for hidden node weights...
				for(u=0;u<nHidden;u++) {
					
					w = net.getWeightsHidden(u);
					w[0] = w[0] - eta*deltas_hidden[u];
					for(j=0;j<N_INPUTS;j++) {
						w[j+1] = w[j+1] - eta*delJ_hidden[j][u];
					}
					net.setWeightsHidden(u, w);				
				}
			}
			
			
			
			
			if (outputs[0] > 0.5)
				tmp0 = 1;
			else
				tmp0 = 0;
			
			if (outputs[1] > 0.5)
				tmp1 = 1;
			else
				tmp1 = 0;
			
			if ((tmp0 == y[i][0]) && (tmp1 == y[i][1]))
				ccp ++;
			
//			try {
//				writer.write(String.format("%d %d\n", tmp0, tmp1 ));
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
			
		} // end dataset for		
		
//		try {
//			writer.close();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
		
		return ccp/x.length;
		
	} // loopOverData
	
	
}
