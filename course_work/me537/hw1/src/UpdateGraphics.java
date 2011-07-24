import javax.swing.JFrame;

public class UpdateGraphics extends Thread{

	JFrame frame;
	int usec;
	int nsec;
	
	NNetwork net;
	
	UpdateGraphics(JFrame jf, int u, int n){
		this.frame=jf;
		this.usec = u;
		this.nsec = n;
	}
	
	public void setNet(NNetwork net) {
		this.net = net;
	}

	public NNetwork getNet() {
		return this.net;
	}
	
	public void run(){
		while(true){
			frame.repaint();
			try {
				Thread.sleep(usec, nsec);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}