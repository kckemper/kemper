import java.awt.*;
import javax.swing.*;

public class DrawNetwork extends JPanel{


	final int NODE_SIZE = 40;
	
	NNetwork net;
	UpdateGraphics ug;
	
	// constructor
	DrawNetwork (NNetwork net, UpdateGraphics ug) {
		this.net = net;
		this.ug = ug;
	}

	
	public void paintComponent(Graphics g)   {

		String str;
		// Get the drawing area
		int maxY = getSize().height;
//		int maxX = getSize().width;
		
		int x=0, y=0, x2, y2;
		int tempY;
		int i,j;
		
		net = ug.getNet();
		if (net == null) return;
		
		int nInput	= net.getNInputs();
		int nHidden = net.getNHidden();
		int nOutput = net.getNOutput();
		
		float [] inputs		= net.getInputs();
		float [] hiddens	= net.getHiddens();
		float [] outputs	= net.getOutputs();
		
		float [] w			= null;
	
		// Paint background
		super.paintComponent(g);

		if (inputs == null) {
			inputs = new float[nInput];
			for(i=0;i<nInput;i++) {
				inputs[i] = 0;
			}
		}
		if (hiddens == null) {
			hiddens = new float[nHidden];
			for(i=0;i<nHidden;i++) {
				hiddens[i] = 0;
			}
		}
		if (outputs == null) {
			outputs = new float[nInput];
			for(i=0;i<nOutput;i++) {
				outputs[i] = 0;
			}
		}
		
		
		x = x + 80;
		y = maxY;
		tempY = y;

		
		// draw inputs
		for (i=0; i<nInput; i++) {
			y = y - NODE_SIZE*2;
			g.setColor(Color.lightGray);
			g.fillRect(x - NODE_SIZE/2, y -NODE_SIZE/2, NODE_SIZE, NODE_SIZE);
			g.setColor(Color.black);
			g.drawString(""+i, x-3, y+5);

			str = String.format("%2.4f", inputs[i]);
			g.drawString(str, x-80, y+5);
		}

		y = y - NODE_SIZE*2;
		str = String.format("Inputs");
		g.drawString(str, x-20, y+20);
		
//		y = y - NODE_SIZE*2;
//		g.setColor(Color.lightGray);
//		g.fillOval(x - NODE_SIZE/2, y -NODE_SIZE/2, NODE_SIZE, NODE_SIZE);
//		g.setColor(Color.black);
//		g.drawString("0", x-3, y+5);
//		g.drawString("1", x-50, y+5);


		// draw hidden layer
		x = x + 200;
		y = tempY;
		for (i=0; i<nHidden; i++) {
			y = y - NODE_SIZE*2;
			g.setColor(Color.lightGray);
			g.fillOval(x - NODE_SIZE/2, y -NODE_SIZE/2, NODE_SIZE, NODE_SIZE);
			g.setColor(Color.black);
			g.drawString(""+i, x-3, y+5);
			
			// draw weights...
			w = net.getWeightsHidden(i);
			str = String.format("%1.3f", w[0]);
			g.drawString(str, x-20, y+35);
			for(j=1;j<w.length;j++) {
				str = String.format("%1.3f", w[j]);
				g.drawString(str, x-70, y+30-15*j);
			}
			
			// draw hidden outputs
			str = String.format("%1.3f", hiddens[i]);
			g.drawString(str, x+30, y+7);
			
		}

		y = y - NODE_SIZE*2;
		str = String.format("Hidden Layer");
		g.drawString(str, x-40, y+20);
		
//		y = y - 35;
//		g.setColor(Color.lightGray);
//		g.fillOval(x - NODE_SIZE/2, y -NODE_SIZE/2, NODE_SIZE, NODE_SIZE);
//		g.setColor(Color.black);
//		g.drawString("0", x-3, y+5);
//		g.drawString("1", x-30, y+5);
		

		// draw input-hidden connections
		y = tempY;
		x2 = x - 200;
		for (i=0; i<nHidden; i++){
			y = y - NODE_SIZE*2;
			y2 = tempY;
			for (j=0; j<nInput; j++) {
				y2 = y2 - NODE_SIZE*2;
				g.setColor(Color.lightGray);
				g.drawLine(x-10, y, x2+10, y2);
			}
		}
		
		// draw output layer
		x = x + 200;
		y = tempY;
		for (i=0; i<nOutput; i++) {
			y = y - NODE_SIZE*2;
			g.setColor(Color.lightGray);
			g.fillOval(x - NODE_SIZE/2, y -NODE_SIZE/2, NODE_SIZE, NODE_SIZE);
			g.setColor(Color.black);
			g.drawString(""+i, x-3, y+5);
			
			// draw weights...
			w = net.getWeightsOutputs(i);
			str = String.format("%1.3f", w[0]);
			g.drawString(str, x-20, y+35);
			for(j=1;j<w.length;j++) {
				str = String.format("%1.3f", w[j]);
				g.drawString(str, x-70, y+30-15*j);
			}

			
			
			g.setColor(Color.lightGray);
			g.drawLine(x+NODE_SIZE/2, y, x+NODE_SIZE/2+20, y);
			
			g.setColor(Color.black);
			str = String.format("%1.0f", outputs[i]);
			g.drawString(str, x+NODE_SIZE+10, y+5);
		}

		y = y - NODE_SIZE*2;
		str = String.format("Output Layer");
		g.drawString(str, x-40, y+20);
		
		
		// draw hidden-output connections
		y = tempY;
		x2 = x - 200;
		for (i=0; i<nOutput; i++){
			y = y - NODE_SIZE*2;
			y2 = tempY;
			for (j=0; j<nHidden; j++) {
				y2 = y2 - NODE_SIZE*2;
				g.setColor(Color.lightGray);
				g.drawLine(x-10, y, x2+10, y2);
			}
		}
		
		
		
	} // paintComponent
	
	// private
	
	
	
	
}
